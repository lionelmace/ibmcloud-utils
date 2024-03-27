# How to install Samba SMB on ROKS 4.14

## Install csi-driver-smb

1. Connect to the OpenShift cluster

1. Install CSI Driver via Helm

    ```sh
    helm repo add csi-driver-smb https://raw.githubusercontent.com/kubernetes-csi/csi-driver-smb/master/charts
    helm install csi-driver-smb csi-driver-smb/csi-driver-smb --namespace kube-system --version v1.14.0
    ```

1. Check pods status

    ```sh
    kubectl --namespace=kube-system get pods --selector="app.kubernetes.io/name=csi-driver-smb" --watch
    ```

## Set variables

:bulb: smbserver below is on line on IBM Cloud

```sh
SERVER="10.243.0.5"
SHARE="samba"
USERNAME="Administrator"
PASSWORD="yourpasswordhere"
PROJECT="default"
```

## Set project
:warning: Log as cluster admin
```
oc project ${PROJECT}
```

## Create smb secret

```sh
oc create secret generic creds --from-literal=username=${USERNAME} --from-literal=password=${PASSWORD} -n $(oc project -q)
```

## Create smb storage class

```sh
cat << EOF | oc apply -f -
apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: smb
provisioner: smb.csi.k8s.io
parameters:
  source: //${SERVER}/${SHARE}
  # if csi.storage.k8s.io/provisioner-secret is provided, will create a sub directory
  # with PV name under source
  csi.storage.k8s.io/provisioner-secret-name: creds
  csi.storage.k8s.io/provisioner-secret-namespace: $(oc project -q)
  csi.storage.k8s.io/node-stage-secret-name: creds
  csi.storage.k8s.io/node-stage-secret-namespace: $(oc project -q)
reclaimPolicy: Delete  # available values: Delete, Retain
volumeBindingMode: Immediate
mountOptions:
  - dir_mode=0777
  - file_mode=0777
  - uid=1001
  - gid=1001
EOF
```

## Create statefulset app

```sh
cat << EOF | oc apply -f -
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: statefulset-smb
  labels:
    app: nginx
spec:
  serviceName: statefulset-smb
  securityContext:
    privileged: true
  replicas: 1
  template:
    metadata:
      labels:
        app: nginx
    spec:
      nodeSelector:
        "kubernetes.io/os": linux
      containers:
        - name: statefulset-smb
          image: mcr.microsoft.com/oss/nginx/nginx:1.19.5
          command:
            - "/bin/bash"
            - "-c"
            - while true; do echo $(date) >> /mnt/smb/outfile; sleep 1; done
          volumeMounts:
            - name: persistent-storage
              mountPath: /mnt/smb
              readOnly: false
  updateStrategy:
    type: RollingUpdate
  selector:
    matchLabels:
      app: nginx
  volumeClaimTemplates:
    - metadata:
        name: persistent-storage
      spec:
        storageClassName: smb
        accessModes: ["ReadWriteOnce"]
        resources:
          requests:
            storage: 10Gi
EOF
```

## Display mount point in container

```sh
oc exec -it statefulset-smb-0 -- df -h /mnt/smb
```

## Errors

mkdir /mnt/samba
mount -t cifs //10.243.0.5/samba /mnt/samba -o username=Administrator

Error: mount: /mnt/samba: cannot mount //10.243.0.5/samba read-only.

Solution: install
yum -y install cifs-utils

```sh
oc describe pod statefulset-smb-0
```

> 0/3 nodes are available: pod has unbound immediate PersistentVolumeClaims. preemption: 0/3 nodes are available: 3 Preemption is not helpful for scheduling..

```sh
oc describe pvc persistent-storage-statefulset-smb-0
```

> Output: mount error(13): Permission denied

## What is displayed on ROKS (RHEL8) 4.12

```
Filesystem      Size  Used Avail Use% Mounted on
/dev/vdb        295G  179G  101G  64% /mnt/smb
```

:ERROR: ON ROKS THE VOLUME IS MOUNTED ON LOCAL FILE SYSTEM WHICH IS NOT EXPECTED !!!

### What is expected and displayed on Openshift (RHCOS) 4.12 

```
Filesystem      Size  Used Avail Use% Mounted on
//161.156.173.196/readwrite       100G  2.1G   98G   3% /mnt/smb
```