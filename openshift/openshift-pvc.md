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

    ```
    oc get pv
    ```

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

## Resources

* [Quickstart for IBM Cloud Block Storage for VPC](https://cloud.ibm.com/docs/containers?topic=containers-vpc-block#vpc_block_qs)
* [Create a NGINX Pod That Uses the PVC](https://docs.openshift.com/container-platform/3.5/install_config/storage_examples/gluster_dynamic_example.html)