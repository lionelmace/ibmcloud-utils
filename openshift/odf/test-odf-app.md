# ODF Post installation

## Verify ODF Installation

1. You can list Persistent volumes to see that ODF hast created "local storage" PVs

    ```sh
    oc get pv
    ```

    ```sh
    NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM                                           STORAGECLASS                       REASON   AGE
    pvc-0ff387d4-0661-4a5a-8fc4-853b31c41634   50Gi       RWO            Delete           Bound    openshift-storage/db-noobaa-db-pg-0             ocs-storagecluster-ceph-rbd                 16s
    pvc-1f3af832-06f2-491b-91a8-d5a745882aca   250Gi      RWO            Delete           Bound    openshift-storage/ocs-deviceset-0-data-0mnswq   ibmc-vpc-block-metro-10iops-tier            4m41s
    pvc-62c34380-c66a-4cef-a6b4-f5071166f02e   50Gi       RWO            Delete           Bound    openshift-storage/rook-ceph-mon-c               ibmc-vpc-block-metro-10iops-tier            7m43s
    pvc-b1725328-3911-4bc3-b189-0575150b49b5   250Gi      RWO            Delete           Bound    openshift-storage/ocs-deviceset-2-data-0bfgmk   ibmc-vpc-block-metro-10iops-tier            4m39s
    pvc-c01025c8-ba20-422c-9487-0a3a033396f8   50Gi       RWO            Delete           Bound    openshift-storage/rook-ceph-mon-b               ibmc-vpc-block-metro-10iops-tier            7m43s
    pvc-c564075a-0d6b-4811-8571-9a98d49f3616   50Gi       RWO            Delete           Bound    openshift-storage/rook-ceph-mon-a               ibmc-vpc-block-metro-10iops-tier            7m43s
    pvc-f61faa79-d09e-4e89-b1b8-7a7a1c3c18db   250Gi      RWO            Delete           Bound    openshift-storage/ocs-deviceset-1-data-0b4wzk   ibmc-vpc-block-metro-10iops-tier            4m41s
    ```

1. Check pods. This is the main pod to check logs if something is not going ok

    ```bash
    oc get pods -n kube-system | grep ibm-ocs
    ```

    ```sh
    ibm-ocs-operator-controller-manager-754cfddcd4-5q2bw   1/1     Running   0               11m
    ```

    ```bash
    oc get pods -n openshift-storage
    ```

    ```sh
    NAME      READY   STATUS      RESTARTS        AGE
    csi-addons-controller-manager-59b5767cb7-9vpdn                    2/2     Running     0               12m
    csi-cephfsplugin-6hk5l                                            3/3     Running     0               12m
    csi-cephfsplugin-dhvbt                                            3/3     Running     0               12m
    csi-cephfsplugin-kc5pp                                            3/3     Running     0               12m
    csi-cephfsplugin-provisioner-6f7d55f87d-8wsqf                     6/6     Running     0               12m
    csi-cephfsplugin-provisioner-6f7d55f87d-gs6qp                     6/6     Running     0               12m
    csi-rbdplugin-77d4h                                               3/3     Running     0               12m
    csi-rbdplugin-b7rbw                                               3/3     Running     0               12m
    csi-rbdplugin-m452t                                               3/3     Running     0               12m
    csi-rbdplugin-provisioner-6dc4c58464-8hkkt                        6/6     Running     0               12m
    csi-rbdplugin-provisioner-6dc4c58464-q78rn                        6/6     Running     0               12m
    noobaa-core-0                                                     1/1     Running     0               4m48s
    noobaa-db-pg-0                                                    1/1     Running     0               4m48s
    noobaa-default-backing-store-noobaa-pod-4106d0a4                  1/1     Running     0               2m10s
    noobaa-endpoint-5594c6cb48-nwqtd                                  1/1     Running     0               2m23s
    noobaa-operator-57858bd76f-brfrv                                  1/1     Running     1 (4m47s ago)   13m
    ocs-metrics-exporter-f9dcd6c9f-5lhxl                              1/1     Running     0               13m
    ocs-operator-8658489b98-fsqv9                                     1/1     Running     0               13m
    odf-console-7c97b7d86f-27wn9                                      1/1     Running     0               13m
    odf-operator-controller-manager-7c79ccf96c-d6zq5                  2/2     Running     0               13m
    rook-ceph-crashcollector-10.243.0.4-574785f77b-gtmtz              1/1     Running     0               9m41s
    rook-ceph-crashcollector-10.243.128.4-6bb86fc487-bq6lf            1/1     Running     0               9m37s
    rook-ceph-crashcollector-10.243.64.4-6b54bd564-xrftp              1/1     Running     0               9m47s
    rook-ceph-mds-ocs-storagecluster-cephfilesystem-a-59c459ff5h4rr   2/2     Running     0               5m43s
    rook-ceph-mds-ocs-storagecluster-cephfilesystem-b-6b8f4985skfwh   2/2     Running     0               5m42s
    rook-ceph-mgr-a-ff69bd784-6cxlw                                   2/2     Running     0               9m48s
    rook-ceph-mon-a-57496587f7-wdbbw                                  2/2     Running     0               12m
    rook-ceph-mon-b-6fb577f7fc-l2crg                                  2/2     Running     0               10m
    rook-ceph-mon-c-5d8c77f8b9-rhzhs                                  2/2     Running     0               10m
    rook-ceph-operator-65c8bdf75b-rd66b                               1/1     Running     0               13m
    rook-ceph-osd-0-677865bc6c-psdlv                                  2/2     Running     0               5m54s
    rook-ceph-osd-1-dff55cdbf-xgzxk                                   2/2     Running     0               5m55s
    rook-ceph-osd-2-7c99d477f6-cqkkp                                  2/2     Running     0               5m51s
    rook-ceph-osd-prepare-ocs-deviceset-0-data-0mnswq-mpx8m           0/1     Completed   0               9m26s
    rook-ceph-osd-prepare-ocs-deviceset-1-data-0b4wzk-gm8f9           0/1     Completed   0               9m26s
    rook-ceph-osd-prepare-ocs-deviceset-2-data-0bfgmk-vq4p5           0/1     Completed   0               9m25s
    rook-ceph-rgw-ocs-storagecluster-cephobjectstore-a-d9bf9cbkhkg6   2/2     Running     0               5m28s
    ```

1. Check Storage Cluster resource. It is can be in "Error" phase during the deployment.

    ```bash
    oc get storagecluster -n openshift-storage
    ```

    ```sh
    NAME                 AGE   PHASE   EXTERNAL   CREATED AT             VERSION
    ocs-storagecluster   11m   Ready              2022-10-20T15:03:44Z   4.10.0    
    ```

## Test ODF with an example application

1. Test ODF with a sample pod.

    ```bash
    oc apply -f - <<EOF
    ---
    kind: PersistentVolumeClaim
    apiVersion: v1
    metadata:
      name: odf-pvc
      namespace: default
    spec:
      accessModes:
        - ReadWriteMany
      resources:
        requests:
          storage: 20Mi
      storageClassName: ocs-storagecluster-cephfs

    ---
    apiVersion: v1
    kind: Pod
    metadata:
      name: odf-test
    spec:
      containers:
      - name: test-odf
        image: nginx
        command: ["/bin/sh"]
        args: ["-c", "while true; do echo $(date -u) >> /test/test.txt; sleep 600; done"] 
        volumeMounts:
          - name: persistent-storage
            mountPath: "/test"
      restartPolicy: "Never"
      volumes:
        - name: persistent-storage
          persistentVolumeClaim:
            claimName: odf-pvc
    EOF
    ```

    The output will be similar to

    ```bash
    persistentvolumeclaim/odf-pvc created
    pod/odf-test created
    ```

1. To verify that the pod is deployed, wait for your app to get into a Running status.

    ```sh
    oc get pods
    ```

    ```sh
    Example output

    NAME                                READY   STATUS    RESTARTS   AGE
    app                                 1/1     Running   0          2m58s
    ```

1. Verify that the app can write data. Log in to your pod.

    ```sh
    oc exec <app-pod-name> -it -- bash
    ```

1. Display the contents of the test.txt file to confirm that your app can write data to your persistent storage.

    ```sh
    cat /test/test.txt
    ```

    ```sh
    Example output
    Thu Oct 20 16:22:49 UTC 2022
    ```

1. Exit the pod.

    ```sh
    exit
    ```
