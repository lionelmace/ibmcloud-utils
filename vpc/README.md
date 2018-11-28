![](./images/kubernetes.png)
# Introduction

In this lab, you’ll gain a high level understanding of the Kubernetes architecture, features, and development concepts related to the IBM Cloud Kubernetes Service (IKS). Throughout the lab, you’ll get a chance to use the Command Line Interface (CLI) for provisioning a Kubernetes cluster, manage your running cluster, and bind a service.

![](./images/kubelabarchi.png)

This lab shows how to demonstrate the deployment of a web application for managing todos. The front end is written in Angular and the reminders are being stored in a Cloudant NoSQL dababase. All run on Node.js, in Docker container managed by Kubernetes.


# Pre-Requisites

+ Get a [IBM Cloud account](https://bluemix.net)
+ Install the [IBM Cloud CLI](https://console.bluemix.net/docs/cli/reference/ibmcloud/download_cli.html#install_use)
+ Install docker for [Mac](https://docs.docker.com/engine/installation/mac/) or [Windows](https://docs.docker.com/engine/installation/windows/)
+ Install [Kubectl](https://kubernetes.io/docs/user-guide/prereqs/)
+ Install a [Git client](https://git-scm.com/downloads)
+ Install [Node.js](https://nodejs.org)


# Steps

1. [Install IBM Cloud Kubernetes Service and Registry plugins](#step-1---install-ibm-cloud-Kubernetes-service-and-registry-plugins)
1. [Connect to IBM Cloud](#step-2---connect-to-ibm-cloud)
1. [Create a cluster](#step-3---create-a-cluster)
1. [Access the cluster via Kubernetes CLI and Dashboard](#step-4---access-the-cluster-via-kubernetes-cli-and-dashboard)
1. [Get and build the application code](#step-5---get-and-build-the-application-code)
1. [Build and Push the application container](#step-6---build-and-push-the-application-container)
1. [Bind a IBM Cloud service to a Kubernetes namespace](#step-7---bind-a-ibm-cloud-service-to-a-kubernetes-namespace)
1. [Create Kubernetes Services and Deployments](#step-8---create-kubernetes-services-and-deployments)
1. [Monitor your container with Weave Scope](#step-9---monitor-your-container-with-weave-scope)
1. [Scale and Clean your services](#step-10---scale-and-clean-your-services)
1. [Appendix - Issues when pushing to the container registry registry](#appendix---issues-when-pushing-to-the-container-registry)
1. [Appendix - Using Kubernetes namespaces](#appendix---using-kubernetes-namespaces)
1. [Appendix - Assigning Access to Namespaces](#appendix---assigning-access-to-namespaces)
1. [Appendix - Adding user-managed subnets and IP address to your Automatic Load Balancer](#appendix---adding-user-managed-subnets-and-ip-address-to-your-automatic-load-balancer)


# Step 1 - Install IBM Cloud Kubernetes Service and Registry plugins

To create Kubernetes clusters, and manage worker nodes, install the Container Service plug-in.

1. Open a command line utility.

1. Before installing the container plugin, we need to add the repository hosting IBM Cloud CLI plug-ins.
    ```
    ibmcloud plugin repos
    ```
    Output:
    ```
    Listing added plug-in repositories...

    Repo Name   URL
    Bluemix     https://plugins.ng.bluemix.net
    ```

1. If you don't see a repository, run the following command:
    ```
    ibmcloud plugin repo-add Bluemix https://plugins.ng.bluemix.net
    ```

1. To install the Container Service plugin, run the following command:
    ```
    ibmcloud plugin install container-service -r Bluemix
    ```

1. To manage a private image registry, install the Registry plug-in. This plug-in connects to a private image registry Bluemix, where you can store images that can be used to build containers. The prefix for running registry commands is **ibmcloud cr**.
    ```
    ibmcloud plugin install container-registry -r Bluemix
    ```

1. To verify that the plug-in is installed properly, run the following command:
    ```
    ibmcloud plugin list
    ```
    and both plug-ins are displayed in the results:
    ```
    Listing installed plug-ins...

    Plugin Name          Version
    container-registry     0.1.316   
    container-service      0.1.515 
    ```
1. To update the container registry plugin
    ```
    ibmcloud plugin update container-registry -r Bluemix
    ```

# Step 2 - Connect to IBM Cloud

1. Login to IBM Cloud
    ```
    ibmcloud login
    ```

1. Select the region (API Endpoint) where you deployed your application.

    | Location | Acronym | API Endpoint |
    | ----- | ----------- | ----------- |
    |Germany|eu-de|https://api.eu-de.bluemix.net|
    |Sydney|au-syd|https://api.au-syd.bluemix.net|
    |US East|us-east|https://api.us-east.bluemix.net|
    |US South|us-south|https://api.us-south.bluemix.net|
    |United Kingdom|eu-gb|https://api.eu-gb.bluemix.net|

    >  To switch afterwards to a different region, use the command `ibmcloud target -r eu-de`

1. Log in to the IBM Cloud Container Service Kubernetes plug-in. The prefix for running commands by using the IBM Cloud Container Service plug-in is **ibmcloud cs**.
    ```
    ibmcloud cs init
    ```


 
# Connect to IaaS
```
ibmcloud sl init -c 1433073
```
```
ibmcloud sl vs list
```



# Resources

For additional resources pay close attention to the following:

- [Running Kubernetes clusters with IBM Cloud Container Service](https://console.ng.bluemix.net/docs/containers/cs_cluster.html#cs_cluster_cli)
- [Container Service Swagger API](https://us-south.containers.bluemix.net/swagger)
- [Bash script to tail Kubernetes logs from multiple pods at the same time](https://github.com/johanhaleby/kubetail)
- [IBM Cloud CLI Plug-in Repository](http://clis.ng.bluemix.net/ui/repository.html#bluemix-plugins)
- [How to deploy, manage, and secure your container-based workloads](https://www.ibm.com/blogs/bluemix/2017/05/kubernetes-and-bluemix-container-based-workloads-part1/)
- [Deploy MicroProfile based Java microservices on Kubernetes Cluster](https://github.com/IBM/Java-MicroProfile-on-Kubernetes)
- [Kubernetes volume plugin that enables Kubernetes pods to access IBM Cloud Object Storage buckets]((https://github.com/IBM/ibmcloud-object-storage-plugin)
- [Modernize JPetStore demo with IBM Cloud Kubernetes Service](https://github.ibm.com/Bluemix/cloud-portfolio-solutions/tree/master/demos/jpetstore-kubernetes)
- [Pod security policies in IBM Cloud Kubernetes Service](https://www.ibm.com/blogs/bluemix/2018/06/pod-security-policies-ibm-cloud-kubernetes-service/)