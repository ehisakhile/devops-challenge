# Project Documentation

## Overview

This project uses Terraform, Docker, Kubernetes (K3s), and Helm to deploy and manage two APIs, providing a streamlined and scalable solution for managing containerized services. I called the bird API *bird-fact-app* and birdImage API, *bird-fact-service*. The pods are designed with high availability and scalability in mind, using Kubernetes Horizontal Pod Autoscaling (HPA) to adjust the number of api instances based on real-time resource utilization.

## Running Application

You may access the application on this address: [http://3.138.194.89:30001/](http://3.138.194.89:30001/)

## Infrastructure
The infrastructure was built using Terraform. You can find the infrastructure code in the [infrastructure](./infrastructure/) folder. For security, I set up a bastian host which is in the public subnet, the master and worker nodes are in the private subnet. To access the nodes, I opened SSH port (22). Other ports required by the nodes to work was also set.

## K8s Cluster
Setting up the cluster was quite a challenge but I was able to pull it off using K3s - a highly available, certified Kubernetes distribution designed for production workloads.

### Installation steps

#### Master Node 

Install K3s
``` bash
  curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=192.168.0.0/16 --disable-network-policy --disable=traefik" sh -
  ```

Get Token
``` bash
  sudo cat /var/lib/rancher/k3s/server/node-token
```

Install Calico

``` bash
kubectl apply -f https://raw.githubusercontent.com/projectcalico/calico/v3.28.2/manifests/calico.yaml
```
#### Worker Node 

Join Master Node

``` bash
curl -sfL https://get.k3s.io | K3S_URL=https://<master-node-ip>:6443 K3S_TOKEN=<Token> sh -
```

## Setting up Autoscaling
For high availability and to manage fluctuating workloads, I implemented Horizontal Pod Autoscaling (HPA) in the Kubernetes manifest. This ensures that the number of running pods adjusts automatically based on CPU usage, helping maintain application performance and optimize resource usage. To gather resource usage data such as CPU and memory from the cluster, I used **Metric Server** because it is lightweight and meets the demand of the application.


## Observability

For observability, I set up a Prometheus-Grafana Stack using Helm, I configured alert manager to send notifications to a Slack channel.

### Installation steps

Install Helm on Cluster

``` bash
  curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
```
``` bash
chmod 700 get_helm.sh
```
``` bash
./get_helm.sh
```

Install Prometheus Stack

``` bash
helm upgrade --install kube-prometheus-stack kube-prometheus-stack \
  --namespace kube-prometheus-stack --create-namespace \
  --repo https://prometheus-community.github.io/helm-charts
  ```
