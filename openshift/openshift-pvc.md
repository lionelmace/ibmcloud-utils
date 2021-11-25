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

## Debug commands when there is volume storage attachment issues

1. Find and view the status of the volumeattachment of the created pod

    ```sh
    kubectl get volumeattachment
    ```

    Output:

    ```sh
    NAME        ATTACHER               PV                       NODE        ATTACHED   AGE
    csi-40e115dd24ce588ced600b9ddf5fc222ff46c25d4faed88291987b04bef3d3bf   vpc.block.csi.ibm.io   pvc-7ac3d626-fe7c-4154-8663-53e6f1f221dc   10.10.0.8   true       3m24s
    ```

    > The ATTACHER status should be true as above. If the status for the field ATTACHED is mark as FALSE, there is an issue...!!!

1. Get the volumeattachment name that starts with `csi`

    ```sh
    export VOL_ATTACHMENT_ID=$(kubectl get volumeattachment | awk '{print tolower($1)}')
    ```

1. Scale down Deployment to zero in the console before deleting an attachment

1. Get the storage attachment

    ```sh
    ibmcloud ks storage attachment ls --cluster <cluster-id> --worker <worker-id>
    ```

    Output:

    ```sh
    Listing volume attachments...
    OK
    ID                                          Name                                Status     Type   Volume ID                                   Volume Name                                Worker ID
    02b7-1b2a3de5-6e03-4e8e-b506-70d7528d8408   primal-shopping-cornflake-setup     attached   data   r010-f697156e-00d3-4cca-8a05-029621f96cf2   pvc-7ac3d626-fe7c-4154-8663-53e6f1f221dc   kube-c3vsi01f0t5r5ia3mir0-iro-workerf-00000559
    02b7-6a4ef0de-f7ce-4893-818d-c6468e601007   cyclic-bogged-sixtyfold-underhand   attached   boot   r010-f0e0e03f-f724-4a15-807c-0b9c90052689   banish-flashcard-regally-basis             kube-c3vsi01f0t5r5ia3mir0-iro-workerf-00000559
    ```

1. View details of a volume

    ```sh
    ibmcloud is vol r010-f697156e-00d3-4cca-8a05-029621f96cf2
    ```

    Output:

    ```sh
    Getting volume r010-f697156e-00d3-4cca-8a05-029621f96cf2 under account ACME as user lionel.mace@fr.ibm.com...

    ID                                     r010-f697156e-00d3-4cca-8a05-029621f96cf2
    Name                                   pvc-7ac3d626-fe7c-4154-8663-53e6f1f221dc
    CRN                                    crn:v1:bluemix:public:is:eu-de-1:a/0b5a00334eaf9eb9339d2ab48f7326b4::volume:r010-f697156e-00d3-4cca-8a05-029621f96cf2
    Status                                 available
    Capacity                               10
    IOPS                                   3000
    Bandwidth(Mbps)                        393
    Profile                                general-purpose
    Encryption key                         -
    Encryption                             provider_managed
    Resource group                         demo
    Created                                2021-08-04T14:29:57+02:00
    Zone                                   eu-de-1
    Tags                                   clusterid:c3vsi01f0t5r5ia3mir0,namespace:apvc-test,provisioner:vpc.block.csi.ibm.io,pv:pvc-7ac3d626-fe7c-4154-8663-53e6f1f221dc,pvc:gluster1,reclaimpolicy:delete,storageclass:ibmc-vpc-block-general-purpose
    Volume Attachment Instance Reference   Attachment type   Instance ID                                 Instance name                                    Auto delete   Attachment ID                               Attachment name
                                        data              02b7_cefeb890-57ec-4b3e-8763-b40a27d600db   kube-c3vsi01f0t5r5ia3mir0-iro-workerf-00000559   false         02b7-1b2a3de5-6e03-4e8e-b506-70d7528d8408   primal-shopping-cornflake-setup

    Active                                 true
    Busy                                   false
    ```

1. Delete the storage attachment starting with `02b7`

    ```sh
    ic ks storage attachment rm --cluster <cluster-id> --worker <worker-id> --attachment 02b7_cefeb890-57ec-4b3e-8763-b40a27d600db
    ```

1. Delete volume attachement id (Don't worry there is no impact on the existing volume)

    ```sh
    kubectl delete volumeattachment $VOL_ATTACHMENT_ID
    ```

    Example

    ```sh
    kubectl delete volumeattachment csi-0bdfbec9a8eb02590d66a44884867de965182bcab53fcaf75715ae5b5dd601ef
    ```

1. Check the volument attachment was deleted

    ```sh
    kubectl get volumeattachment
    ```

1. If the volume attachment is still there, run the command below

    ```sh
    kubectl patch volumeattachment $VOL_ATTACHMENT_ID -p '{"metadata":{"finalizers":null}}'
    ```

1. Delete the pod

    ```sh
    kubectl delete pod <pod_id>
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
