# Install Confluent For Kubernetes

I followed this [guide](https://docs.confluent.io/operator/current/co-quickstart.html)

## pre-req:
* A Kubernetes cluster conforming to one of the supported versions. Done.
* kubectl installed, initialized, with the context set. You also must have the kubeconfig file configured for your cluster. and install kubectl on your desktop as well
* Helm 3 installed. Done.
* Access to the Confluent for Kubernetes bundle.
* For these quick start guides, your Kubernetes cluster is assumed to have the default dynamic storage provisioner.

Check pre-reqs:
```bash
ssh -i ~/keys/k3s-key ubuntu@cpmaster
sudo kubectl get nodes
sudo kubectl cluster-info
sudo kubectl cluster-info dump
sudo k3s kubectl config view
sudo kubectl get configmaps -n kube-system -o yaml
```

## Prepare your desktop to work with k3s cluster on Raspberry PI

First install kubectl on your local computer. Follow this [guide](https://kubernetes.io/docs/tasks/tools/install-kubectl-macos/) for MacOS. 
Now you have to add the the cluster to your local kubeconfig file. 
Therefore first ssh into the master node and copy the content of following file `/etc/rancher/k3s/k3s.yaml`:
```bash
# on kmaster
ssh -i ~/keys/k3s-key ubuntu@cpmaster
sudo cat /etc/rancher/k3s/k3s.yaml
```

Place the content in your local kubeconfig file that typically can be found in the home folder in `~/.kube/config`  
```Bash
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: TOKEN
    server: https://cpmaster:6443
  name: default
contexts:
- context:
    cluster: default
    user: default
  name: default
current-context: default
kind: Config
preferences: {}
users:
- name: default
  user:
    client-certificate-data: TOKEN
    client-key-data: TOKEN
```

Check on desktop if you could read the cluster
```bash
kubectl config use-context default
kubectl get nodes
```

## Setup CFK Operator into your cluster

Create a confluent namespace first
```bash
kubectl create namespace confluent
kubectl get ns
kubectl config get-contexts
kubectl config set-context --current --namespace=confluent
```
Set up the Helm Chart:
```bash
helm repo add confluentinc https://packages.confluent.io/helm
# Install Confluent for Kubernetes using Helm:
helm upgrade --install operator confluentinc/confluent-for-kubernetes --namespace confluent
# To run Confluent for Kubernetes you need a license key from Confluent after 30 days evalaution. To add the key do the following:
# If you want to test for 30 days drop the last : --set licenseKey=YOURLICENSEKEY
helm upgrade --install operator \
  confluentinc/confluent-for-kubernetes \
  --namespace confluent --set licenseKey=YOURLICENSEKEY
# Check that the Confluent for Kubernetes pod comes up and is running:
kubectl get pods --namespace confluent
```

CFK Operator is running.
You can continue with the use cases. Create [topic in confluent cloud](usecase_ccloudTopic.md).