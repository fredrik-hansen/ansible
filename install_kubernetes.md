# Install Kubernetes and Kubeflow on a GPU Host with NVIDIA DeepOps


We go through the installation process of Kubeflow, an open source machine learning platform that takes advantage of Kubernetes capabilities to deliver end-to-end workflow to data scientists, ML engineers, and DevOps professionals. 

We will use the DeepOps installer from NVIDIA which simplifies the installation process.
 
Based on AMD Ryzen Threadripper 3960X CPU with 48 Cores, NVIDIA GeForce RTX 3090 GPU with 24GB and 10496 CUDA Cores, 128GB RAM, and 3TB of NVMe storage
  
## Preparing the Host GPU Machine for DeepOps
  
  
###  Preparing the Bootstrap Machine

Since NVIDIA DeepOps relies on Kubespray and Ansible, you need a bootstrap machine to run the playbooks. This can be an Ubuntu VM that has access to the target host machine. I used an Ubuntu 18.04 VirtualBox VM running on my Mac as the bootstrap machine.

Make sure you can SSH into the GPU host without a password which means you need to have the SSH private key available on the bootstrap machine.

Start by cloning the DeepOps GitHub repository on the bootstrap/provisioning machine.
	
```git clone https://github.com/NVIDIA/deepops.git```

Switch to the most stable version of the installer.

```cd deepops```
```git checkout tags/20.12```
	

Install the prerequisites and configure Ansible.
	
```./scripts/setup.sh```

Next, update the inventory file with the GPU host details.

```nvim config/inventory```
	

Under [all], add the hostname and the IP address. I am calling my host amd with an IP address 10.1.4.3

Add the same host under the [kube-master], [etcd], and [kube-node] sections.

If you have a multinode cluster, you can split them as control plane and worker nodes in the inventory files. 

Note that Kubespray will rename the host(s) based on the inventory file. It’s not recommended to change the hostname after installing Kubernetes.

Now, we are ready to kick off the installation.
###Installing Kubernetes with DeepOps

Now that the host and the bootstrap machines are ready, let’s run the installation.

It starts with a single command shown below. I had better results when I used the CUDA repo to install the NVIDIA CUDA runtime and cuDNN libraries. 

The other option is to install the runtime through the GPU operator.

Run the command to ensure that the installer uses the CUDA repo to configure the runtime.

```ansible-playbook -u ubuntu -l k8s-cluster -e '{"nvidia_driver_ubuntu_install_from_cuda_repo": yes}' playbooks/k8s-cluster.yml```

This will start the Ansible playbook to install Kubernetes. 

It may take anywhere from 10 to 20 minutes depending on your Internet connection.

Copy the configuration file and kubectl to access the cluster.

```cp config/artifacts/kubectl /usr/local/bin/
mkdir ~/.kube
cp config/artifacts/admin.conf ~/.kube/config```

	

We are now ready to access the single-node Kubernetes cluster.
	
```kubectl get nodes```

### Test if Kubernetes is able to access the GPU.
```export CLUSTER_VERIFY_EXPECTED_PODS=1 
./scripts/k8s/verify_gpu.sh ```

	
```kubectl run gpu-test --rm -t -i --restart=Never --image=nvcr.io/nvidia/cuda:10.1-base-ubuntu18.04 --limits=nvidia.com/gpu=1 nvidia-smi```

##Configuring the Kubernetes Cluster

Let’s go ahead and install NFS provisioner, Prometheus, and Grafana.

The below command ensures that NFS is used as a backend for dynamic provisioning of PVCs. It’s also useful to share volumes between Jupyter Notebooks.
	
```ansible-playbook playbooks/k8s-cluster/nfs-client-provisioner.yml```

This step also configures a default storage class which is essential for Kubeflow installation.

```kubectl get sc```

To install Prometheus and Grafana, run the following command:
	
```./scripts/k8s/deploy_monitoring.sh```

You can access the Grafana dashboard at http://gpu_host:30200 with username admin and password deepops.

Here is the dashboard showing the GPU node statistics.

###Installing Kubeflow

Finally, we are ready to install Kubeflow. Just run the below command and wait for a few minutes to access the UI.
	
```./scripts/k8s/deploy_kubeflow.sh```

After the installation is done, make sure that all pods in the kubeflow namespace are running.
	
```kubectl get pods -n kubeflow```

You can access the Kubeflow dashboard at http://gpu_host:31380
