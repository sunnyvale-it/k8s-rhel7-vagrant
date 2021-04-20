# Kubernetes multi-node cluster with Vagrant + Virtualbox + Kubeadm

Virtualbox + Vagrant + kubectl have to be installed on the host machine as a prerequisite.

K8S nodes will be provisioned with RedHat Enterprise Linux and the installation procedure relys on this kind of OS.

All the istructions here after have to be run on the host machine.

Install vagrant plugins
```console
$ vagrant plugin install vagrant-vbguest
$ vagrant plugin install vagrant-reload
$ vagrant plugin install vagrant-hostmanager
```

Provision the environent

```console
$ cd vagrant
vagrant$ vagrant up
```

Test the environment

```console
vagrant$ export KUBECONFIG=$(pwd)/kubeconfig.yaml
vagrant$ kubectl get nodes

NAME     STATUS   ROLES    AGE   VERSION
master   Ready    master   18h   v1.15.3
node1    Ready    <none>   17h   v1.15.3
node2    Ready    <none>   17h   v1.15.3
```
