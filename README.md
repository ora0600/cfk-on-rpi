# Running k3s on Raspberry PI cluster with Confluent for Kubernetes

This Repository explains how to setup a k3s cluster on Raspberry PI 4-Node-cluster and deply Confluent for Kubernetes to use CFK API for CD of Confluent components for Confluent Cloud.
Follow this guide to create Kubernetes setup step-by-step.

![RPI k3s cluster with CFK](img/ConfluentforKubernetesonRaspberryPIk3scluster.png)

# Prepare the cluster:
* cpmaster
* cpworker1
* cpworker2
* cpworker3

# Deploy Confluent for Kubernetes
The installation of CFP Operator in k3s cluster is ver simple. These pre-reqs have to be there.


# Use cases 

* Topic Depleyment to Confluent Cloud cluster

# Monitoring
Add die RPI Cluster to my Grafana/Prometheus iMac.

# Software
we will use the following software to run the cluster on Raspberry PIs
* Ubuntu OS Server 23.10 64-bit
* Helm
* kubectl
* k3s , v1.27.7+k3s2
* Confluent for Kubernetes 2.7

# Hardware
We will run with Raspberry PI 4B. Best would be with 8 GB RAM, but this is not easy to get today. 4GB RAM do work also quite good. I did add a buying list with links to Amazon, but please keep in mind that Amazon prices are maybe not the best:
* 2 x [Raspberry PI 4 4GB RAM](https://amzn.to/3FwZHX0) and 2 x [Raspberry PI 4 8GB RAM](https://amzn.to/3L47MDK) (Raspberry )
    * 1 x [RPI cluster buildcase](https://amzn.to/3RaEDf6)
* 1 x [USB Power Hub](https://amzn.to/3N7t4Uv)
    * 4 x [USB-C Power cable](https://amzn.to/3FHU6xb)
* 1 x [unmanaged Network Router](https://amzn.to/3vUyha8)
    * 1 x [Network cable](https://amzn.to/399lb00)
* 4 x [128 GB SDCard](https://amzn.to/3N7t4Uv)
* 1 x [LED light band](https://amzn.to/3Ftp6AI)
* 1 x [Power Cable](https://amzn.to/3smIaLE)

# Note/license:
***Note***: Confluent fpr Kuebernetes is a commercial software product from Confluent and has to be licensed. You will get for the first 30 days an evaluation license without any charges.