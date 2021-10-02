## K8s cluster creation labs
testing purposes only

### Prereqs

local clusters require virtualbox or an alternative (kvm) supported by vagrant
vagrant & ansible

e.g. get a full running Kubernetes cluster with a master/control-plane and 2 worker nodes in 3 simple steps:

1. install virtualbox, vagrant & ansible
2. clone this repo, `cd` to `kubes-local-vagrant-ubuntu-ansible`
3. run `vagrant up`

To interact with the cluster, use its cluster config (see task ```Setup kubeconfig for vagrant user```) or SSH into the master node by `vagrant ssh k8s-master`
