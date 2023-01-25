# Install COS

```sh
helm ibmc install ibm-object-storage-plugin ibm-helm/ibm-object-storage-plugin --set license=true
```

Output:

```sh
Helm version: v3.8.0+gd141386
Checking cluster type
Installing the Helm chart...
PROVIDER: IBMC-VPC
WORKER_OS: debian
PLATFORM: k8s
KUBE_DRIVER_PATH: /usr/libexec/kubernetes
CONFIG_BUCKET_ACCESS_POLICY: false
CONFIG_QUOTA_LIMIT: false
DC: fra02
Region: eu-de
Chart: ibm-helm/ibm-object-storage-plugin
NAME: ibm-object-storage-plugin
LAST DEPLOYED: Mon Jan 23 09:23:19 2023
NAMESPACE: ibm-object-s3fs
STATUS: deployed
REVISION: 1
NOTES:
Thank you for installing: ibm-object-storage-plugin.   Your release is named: ibm-object-storage-plugin

1. Verify that the storage classes are created successfully:

   $ kubectl get storageclass | grep 'ibmc-s3fs'

2. Verify that plugin pods are in "Running" state:

   $ kubectl get pods -n ibm-object-s3fs -o wide | grep object

   The installation is successful when you see one `ibmcloud-object-storage-plugin` pod and one or more `ibmcloud-object-storage-driver` pods.
   The number of `ibmcloud-object-storage-driver` pods equals the number of worker nodes in your cluster. All pods must be in a `Running` state for the plug-in to function properly. If the pods fail, run `kubectl describe pod -n ibm-object-s3fs <pod_name>`
   to find the root cause for the failure.
######################################################
Additional steps for IBM Kubernetes Service(IKS) only:
######################################################

  1. If the plugin pods show an "ErrImagePull" or "ImagePullBackOff" error, copy the image pull secret 'all-icr-io' from "default" namespace to ibm-object-s3fs namespace of your cluster. The image pull secret 'all-icr-io' provides access to IBM Cloud Container Registry.

     a. Check the secret exists in "default" namespace

     $ kubectl get secrets -n default | grep icr-io

     Example output:
     ------------------------------------------------------------------
     all-icr-io         kubernetes.io/dockerconfigjson        1      2d
     ------------------------------------------------------------------

     b. Copy secret to ibm-object-s3fs  namespace

     $ kubectl get secret -n default all-icr-io -o yaml | sed 's/default/<namespace>/g' | kubectl -n <namespace> create -f -

     c. Verify that the image pull secret is available in the ibm-object-s3fs  namespace.

     $ kubectl get secrets -n ibm-object-s3fs | grep icr-io

  2. Verify that the state of the plugin pods changes to "Running".

     $ kubectl get pods -n ibm-object-s3fs | grep object
```
