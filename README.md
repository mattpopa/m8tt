## To set up a cluster, use kops to get configs for the running cluster,
## or create a new one.
## 
## Get all clusters in a state store
kops get clusters --state=s3://digital-tf-state 

## Export K8's cluster config file
kops export kubecfg kubernetes-cluster.example.com  --state=s3://digital-tf-state 

## If using more than one cluster, list all available clusters with
kubectl config get-contexts

## then select the desired one by 
kubectl config set-context arpahico.k8.example.com

## ## If using more than one config, use the KUBECONFIG env, and join them with ":" 
$ KUBECONFIG=/path/to/mimi/config:/path/to/gigi/config
$ echo $KUBECONFIG

##  ##  If there isn't one already up, create one by using ./generate_k8_tf_conf.sh script

