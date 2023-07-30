#Check for info https://www.reddit.com/r/homelab/comments/ipsc4r/howto_k8s_metallb_and_external_dns_access_for/


#Kill and clean up
sudo kubeadm reset
sudo systemctl stop kubelet
sudo systemctl stop etcd
sudo systemctl stop containerd
sudo killall kube-apiserver
sudo rm -rf /var/lib/etcd/
sudo rm -rf /etc/cni/net.d/
# Set it up again
sudo kubeadm init --pod-network-cidr=10.10.0.0/16  --kubernetes-version=1.25.12-00
sudo apt install --reinstall kubeadm=1.25.12-00 kubelet=1.25.12-00 kubectl=1.25.12-00
#If all up again in vanilla state, copy config

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


###patch kubeproxy config and change strictarp: to false

kubectl edit configmap -n kube-system kube-proxy
kubectl taint nodes $(hostname) node-role.kubernetes.io/master:NoSchedule-
apiVersion: kubeproxy.config.k8s.io/v1alpha1
        kind: KubeProxyConfiguration
        mode: ""
        ipvs:
        strictARP: true
        
sudo systemctl restart kubelet

###Install repos

helm repo add projectcalico https://docs.tigera.io/calico/charts
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add nvidia https://nvidia.github.io/gpu-operator
helm repo update

###Create the tigera-operator namespace.

kubectl create namespace tigera-operator

kubectl create namespace jupyterhub
###Install the Tigera Calico operator and custom resource definitions using the Helm chart:

helm install calico projectcalico/tigera-operator --version v3.26.1 --namespace tigera-operator

###or if you created a values.yaml above:

helm install calico projectcalico/tigera-operator --version v3.26.1 -f values.yaml --namespace tigera-operator

###Confirm that all of the pods are running with the following command.

watch kubectl get pods -n calico-system

###Wait until each pod has the STATUS of Running.


kubectl delete -f 1.yml
kubectl delete -f 2.yml

# Let's try the newer version below
#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/namespace.yaml
#kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.9.3/manifests/metallb.yaml

kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/manifests/namespace.yaml
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/manifests/metallb.yaml
	
kubectl create secret generic -n metallb-system memberlist --from-literal=secretkey="$(openssl rand -base64 128)"
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

kubectl apply -f 1.yml
kubectl apply -f 2.yml





## Full disk?
Add below:
sudo vim /var/lib/kubelet/config.yaml

eviction-hard:
  memory.available<100Mi
  nodefs.available<1%
  nodefs.inodesFree<1%
  imagefs.available<1%
  imagefs.inodesFree<1%

Restart the kubelet service.

sudo systemctl restart kubelet

If the node has no longer diskpressure taint but still has

node.kubernetes.io/unschedulable:NoSchedule

Use below command to uncordon and enable scheduling :

kubectl uncordon $(hostname)

kubectl taint nodes $(hostname) node-role.kubernetes.io/master-
kubectl taint nodes $(hostname) node.kubernetes.io/disk-pressure:NoSchedule-

###
# Extras
helm install --wait --generate-name \
     nvidia/gpu-operator \
     --set operator.defaultRuntime=containerd

kubectl run gpu-test \
     --rm -t -i \
     --restart=Never \
     --image=nvcr.io/nvidia/cuda:10.1-base-ubuntu18.04 nvidia-smi



kubectl patch svc ext-dns-udp -n kube-system -p '{"spec": {"type": "LoadBalancer", "externalIPs":["10.1.71.6"]}}'
###
# DNS edit
###

kubectl get -n kube-system configmaps coredns -o yaml > core_dns.yaml
lvim core_dns.yaml
kubectl replace -n kube-system -f core_dns.yaml

## Run busybox to test pod DNS resolving
kubectl run busybox --image busybox:latest --restart=Never --rm -it busybox -- sh
kubectl run -it --rm --image=infoblox/dnstools dns-client  
