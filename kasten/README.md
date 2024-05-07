# Kasten Installation on IKS

## Pre-Requisites

    * IKS cluster version 1.29 with 2 nodes of each 4x16 (https://cloud.ibm.com/kubernetes/catalog/create)
    * IBM Cloud Object Storage (https://cloud.ibm.com/objectstorage/create)
    * Helm package manager (https://helm.sh/)

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

1. Check the status of PVC

    ```sh
    kubectl get pvc -n kasten-io
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
          - path: "/"
            pathType: Prefix
            backend:
              service:
                name: gateway
                port:
                  number: 8000
    EOF
    ```

1. Open the K10 dashboard in a browser

    ```sh
    open https://$IKS_INGRESS_URL/k10/
    ```

1. Accept the terms
   
   ![storage classes failed](./images/k10-accept-terms.png)

## Configure Storage Class for Snapshot Volume

1. In K10 console, go to the Settings > System Information. Scroll down to Storage Classes.

1. Click on Validate the default storage class **ibmc-vpc-block-10iops-tier**. The validation will fail because the VolumeSnapshotClass is missing.

    ![storage classes failed](./images/k10-storageclasses-validate.png)
  
1. Create the Volume Snapshot Slass

    ```sh
    kubectl apply -f - << EOF
    ---
    kind: VolumeSnapshotClass
    apiVersion: snapshot.storage.k8s.io/v1
    metadata:
      name: ibmc-vpcblock-odf-10iops-snapclass
      annotations:
        snapshot.storage.kubernetes.io/is-default-class: "true"
        k10.kasten.io/is-snapshot-class: "true"
    driver: vpc.block.csi.ibm.io
    deletionPolicy: Delete
    EOF
    ```

1. Revalidate the storage class. After the few seconds, the status should become **Valid**.

    ![storage classes](./images/k10-storageclasses.png)

## Create Location profile for IBM Cloud COS Standard bucket

1. Create Minio access key

    ```sh
    minio_access_key_id=$(echo $username)
    minio_access_key_secret=$(echo $password)
    ```

1. Create COS secret for K10

    ```sh
    kubectl create secret generic k10-s3-secret-cos \
      --namespace kasten-io \
      --type secrets.kanister.io/aws \
      --from-literal=aws_access_key_id=$minio_access_key_id\
      --from-literal=aws_secret_access_key=$minio_access_key_secret
    ```

    ```sh
    echo | kubectl apply -f - << EOF
    ---
    apiVersion: config.kio.kasten.io/v1alpha1
    kind: Profile
    metadata:
      name: minio-profile-standard
      namespace: kasten-io
    spec:
      type: Location
      locationSpec:
        credential:
          secretType: AwsAccessKey
          secret:
            apiVersion: v1
            kind: Secret
            name: k10-s3-secret-minio
            namespace: kasten-io
        type: ObjectStore
        objectStore:
          endpoint: http://$get_ip:9000
          name: s3-standard
          objectStoreType: S3
          skipSSLVerify: true
    EOF
    ```
