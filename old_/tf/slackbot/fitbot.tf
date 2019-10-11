# Post to Slack
resource "aws_cloudwatch_event_rule" "post-to-slack" {
  name                = "${terraform.workspace}_post_to_slack"
  description         = "Trigger to remind about environment shutdown"
  schedule_expression = "cron(0 18 ? * MON-FRI *)"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
}

resource "aws_lambda_permission" "post-to-slack" {
  action        = "lambda:InvokeFunction"
  function_name = "${terraform.workspace}_manage_environments_mgmt_post_to_slack"
  principal     = "events.amazonaws.com"
  statement_id  = "${terraform.workspace}_post_to_slack"
  source_arn    = "${aws_cloudwatch_event_rule.post-to-slack.arn}"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
}

resource "aws_cloudwatch_event_target" "post-to-slack" {
  arn = "arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${terraform.workspace}_manage_environments_mgmt_post_to_slack"
  depends_on = [
    "aws_lambda_permission.post-to-slack"
  ]
  rule = "${terraform.workspace}_post_to_slack"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
}

# API gateway
resource "aws_api_gateway_rest_api" "fitbot" {
  name = "fitbot"
  description = "Gateway to manage Fitbot in Slack"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
}

resource "aws_api_gateway_resource" "fitbot" {
  rest_api_id = "${aws_api_gateway_rest_api.fitbot.id}"
  parent_id = "${aws_api_gateway_rest_api.fitbot.root_resource_id}"
  path_part = "event-handler"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
}

resource "aws_api_gateway_method" "fitbot" {
  rest_api_id = "${aws_api_gateway_rest_api.fitbot.id}"
  resource_id = "${aws_api_gateway_resource.fitbot.id}"
  http_method = "POST"
  authorization = "NONE"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
}

resource "aws_api_gateway_method_response" "fitbot" {
  rest_api_id = "${aws_api_gateway_rest_api.fitbot.id}"
  resource_id = "${aws_api_gateway_resource.fitbot.id}"
  http_method = "${aws_api_gateway_method.fitbot.http_method}"
  status_code = "200"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = true,
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
}

resource "aws_api_gateway_integration" "fitbot" {
  rest_api_id = "${aws_api_gateway_rest_api.fitbot.id}"
  resource_id = "${aws_api_gateway_resource.fitbot.id}"
  http_method = "${aws_api_gateway_method.fitbot.http_method}"
  type        = "AWS"
  uri         = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/arn:aws:lambda:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:function:${terraform.workspace}_manage_environments_mgmt_receive_from_slack/invocations"
  integration_http_method = "POST"
  passthrough_behavior = "WHEN_NO_MATCH"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
}

resource "aws_api_gateway_integration_response" "fitbot" {
  depends_on = [
    "aws_api_gateway_method_response.fitbot",
    "aws_api_gateway_integration.fitbot"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.fitbot.id}"
  resource_id = "${aws_api_gateway_resource.fitbot.id}"
  http_method = "${aws_api_gateway_method.fitbot.http_method}"
  status_code = "200"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = "'*'",
    "method.response.header.Access-Control-Allow-Credentials" = "'true'"
  }
}

resource "aws_lambda_permission" "fitbot-apigateway" {
  function_name = "${terraform.workspace}_manage_environments_mgmt_receive_from_slack"
  statement_id = "${terraform.workspace}_receive_from_slack"
  action = "lambda:InvokeFunction"
  principal = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_deployment.fitbot.execution_arn}/${aws_api_gateway_integration.fitbot.integration_http_method}/${aws_api_gateway_resource.fitbot.path_part}"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
}

resource "aws_api_gateway_deployment" "fitbot" {
  depends_on = [
    "aws_api_gateway_method.fitbot",
    "aws_api_gateway_integration.fitbot"
  ]
  rest_api_id = "${aws_api_gateway_rest_api.fitbot.id}"
  stage_name = "dev"
  count = "${local.aws_profile[terraform.workspace] == "cyclones-test_mgmt" ? 1 : 0}"
}
