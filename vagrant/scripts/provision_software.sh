sudo swapoff -a

sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo sed -i 's/$releasever/7/g' /etc/yum.repos.d/docker-ce.repo

cat <<EOF | sudo tee /etc/yum.repos.d/centos7.repo
[base]
name=CentOS $releasever – Base
baseurl=http://mirror.centos.org/centos/7/os/\$basearch/
gpgcheck=0
enabled=1

[updates]
name=CentOS $releasever – Updates
baseurl=http://mirror.centos.org/centos/7/updates/\$basearch/
gpgcheck=0
enabled=1

[extras]
name=CentOS $releasever – Extras
baseurl=http://mirror.centos.org/centos/7/extras/\$basearch/
gpgcheck=0
enabled=1
EOF

#subscription-manager register --auto-attach

#subscription-manager repos --enable=rhel-7-server-rpms \
#  --enable=rhel-7-server-extras-rpms \
#  --enable=rhel-7-server-optional-rpms

sudo yum install -y docker-ce

sudo mkdir /etc/docker/
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "storage-driver": "overlay2"
}
EOF

sudo mkdir -p /etc/systemd/system/docker.service.d
sudo systemctl start docker 
sudo chmod 777 /var/run/docker.sock
sudo systemctl restart docker 
sudo systemctl daemon-reload
sudo systemctl enable docker && sudo systemctl start docker
sudo docker info | grep overlay
sudo docker info | grep systemd

cat <<EOF | sudo tee /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-\$basearch
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
exclude=kubelet kubeadm kubectl
EOF


sudo yum install -y kubelet-1.20.0-0.x86_64 kubeadm kubectl --disableexcludes=kubernetes

sudo echo "KUBELET_EXTRA_ARGS=--cgroup-driver=systemd" > /etc/default/kubelet

sudo systemctl enable --now kubelet



