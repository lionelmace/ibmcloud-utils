# PVC Sample

1. Deploy the pod

    ```sh
    oc apply -f openshift-nginx-pvc.yml
    ```

1. View the PVC

    ```sh
    oc get pvc
    ```

    Output:

    ```sh
    NAME       STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS                     AGE
    gluster1   Bound    pvc-4817ce86-f82e-4afa-85fa-973a4dd3dee1   10Gi       RWO            ibmc-vpc-block-general-purpose   15m
    ```

    > Notice that the PVC is bound to a dynamically created volume.

1. View the persistent volume

    ```sh
    oc get pv
    ```

1. View the volume in [VPC Block Storage](https://cloud.ibm.com/vpc-ext/storage/storageVolumes)

1. View the pod

    ```sh
    oc get pods -o wide
    ```

1. oc exec into the container

    ```sh
    oc exec -ti nginx-pod /bin/sh
    ```

    Error:
    > Error from server: error dialing backend: dial tcp 10.10.0.8:10250: connect: connection timed out

1. Delete the pod and the pvc

    ```sh
    oc delete -f openshift-nginx-pvc.yml
    ```

## Debug commands when there is volume storage issues

1. View the status of the volume attachment

    ```sh
    kubectl get volumeattachment | grep pvc-03cd14d5-3206-424a-b704-8e18ea66c48d
    ```

    Output:

    ```sh
    csi-0bdfbec9a8eb02590d66a44884867de965182bcab53fcaf75715ae5b5dd601ef   vpc.block.csi.ibm.io   pvc-03cd14d5-3206-424a-b704-8e18ea66c48d   10.154.44.8    false      4d23h
    ```

    > If the status for the field ATTACHED is mark as FALSE for ATTACHED, there is an issue...!!!

1. Scale down Deployment to zero in the console before deleting an attachment

1. Delete the storage attachment

    ```sh
    ic ks storage attachment rm --cluster brmcm3tf0uukor9d8u7g --worker kube-brmcm3tf0uukor9d8u7g-extranetdev-poolwor-00003f3b --attachment 02b7-c550e985-dd3a-417e-93c9-f17e90a70322
    ```

1. Delete volume attachement id (Don't worry there is no impact on the existing volume)

    ```sh
    kubectl delete volumeattachment csi-0bdfbec9a8eb02590d66a44884867de965182bcab53fcaf75715ae5b5dd601ef
    ```

1. If the previous command has no effeect, run the command below

    ```sh
    kubectl patch volumeattachment csi-0bdfbec9a8eb02590d66a44884867de965182bcab53fcaf75715ae5b5dd601ef -p '{"metadata":{"finalizers":null}}'
    ```

1. Restart the controler

    ```sh
    kubectl delete po ibm-vpc-block-csi-controller-0 -n kube-system
    ```

1. Check the controler was restarted. Wait for a few minutes so that kubernetes can be notified.

    ```sh
    kubectl get pods -n kube-system | grep vpc
    ```

1. Check the version of the CSI addon

    ```sh
    ibmcloud oc cluster addon versions --addon vpc-block-csi-driver
    ```

## Resources

* [Quickstart for IBM Cloud Block Storage for VPC](https://cloud.ibm.com/docs/containers?topic=containers-vpc-block#vpc_block_qs)
* [Create a NGINX Pod That Uses the PVC](https://docs.openshift.com/container-platform/3.5/install_config/storage_examples/gluster_dynamic_example.html)