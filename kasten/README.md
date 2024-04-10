# Kasten Installation on IKS

## Pre-Requisites

    * Install the Helm package manager (https://helm.sh/)

## Connect to an IKS Cluster

1. Replace the cluster-name (including <>) with the the cluster name.

    ```sh
    export IKS_CLUSTER_NAME=<cluster-name>
    ```

1. Log in to the IKS cluster using the following command:

    ```sh
    ibmcloud ks cluster config -c $IKS_CLUSTER_NAME --admin
    ```

1. Set the values of both the ingress subdomain and the ingress secret of your cluster. Those values will be used in the deployment yaml later.

    ```sh
    export IKS_INGRESS_URL=$(ibmcloud ks cluster get -c $IKS_CLUSTER_NAME | grep "Ingress Subdomain" | awk '{print tolower($3)}')
    export IKS_INGRESS_SECRET=$(ibmcloud ks cluster get -c $IKS_CLUSTER_NAME | grep "Ingress Secret" | awk '{print tolower($3)}')
    ```

1. Verify the values you set

    ```sh
    echo $IKS_INGRESS_URL
    echo $IKS_INGRESS_SECRET
    ```

## Install Kasten K10 on IKS

1. Add the Kasten Helm charts repository using the following command:

    ```sh
    helm repo add kasten https://charts.kasten.io/
    ```

1. Create the namespace where Kasten will be installed. By default, the installation creates the namespace kasten-io.

    ```sh
    kubectl create namespace kasten-io
    ```

1. Install Kasten K10 in IKS using the following Helm command:

    ```sh
    helm install k10 kasten/k10 --namespace=kasten-io
    ```

    > Use this command to install on OpenShift
    > helm install k10 kasten/k10 --namespace=kasten-io --set scc.create=true

1. Check that installation is complete and all pods are up and running in the kasten-io namespace:

    ```sh
    kubectl get pods -n kasten-io
    ```

1. Create a route for accessing the Kasten dashboard:

    ```sh
    kubectl apply -f - <<EOF   
    ---
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
      name: k10-ingress
      namespace: kasten-io
    spec:
      ingressClassName: public-iks-k8s-nginx
      rules:
      - host: $IKS_INGRESS_URL
        http:
          paths:
          - path: /k10/
            pathType: Exact
            backend:
              service:
                name: gateway
                port:
                  number: 8080
    EOF
    ```

1. Open the K10 dashboard in a browser

    ```sh
    open https://$IKS_INGRESS_URL/k10
    ```
