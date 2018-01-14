#!/bin/bash

# 1st check terraform status in tf/cluster to 
# see if there's already a running k8 in place
# if not, then use kops to generate k8 tf config

kops create cluster --name m8tt.ddigital.org --dns-zone ddigital.org --state=s3://digital-tf-state  --out=./tf/cluster --target terraform  --zones eu-central-1a,eu-central-1b --admin-access 78.96.101.50/32,109.166.194.99/32

echo -e "install the dashboard:\n\nkubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.7.1.yaml"

#The dashboard project provides a nice administrative UI:
#
#Install using:
#
#kubectl create -f https://raw.githubusercontent.com/kubernetes/kops/master/addons/kubernetes-dashboard/v1.7.1.yaml
#
#And then navigate to https://api.<clustername>/ui
#
#(/ui is an alias to https://<clustername>/api/v1/proxy/namespaces/kube-system/services/kubernetes-dashboard)
#
#The login credentials are:
#
#    Username: admin
#    Password: get by running kops get secrets kube --type secret -oplaintext or kubectl config view --minify

