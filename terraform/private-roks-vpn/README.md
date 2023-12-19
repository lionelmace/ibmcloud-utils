# Readme

1. Change key

chmod 0600 rsakey.pem
scp -i ./rsakey.pem ~/Downloads/openshift-client-linux.tar root@149.81.0.156:/root
scp -i ./rsakey.pem ~/Downloads/oc-mirror.tar root@149.81.0.156:/root
tar -C /usr/local/bin -xvf openshift-client-linux.tar
tar -C /usr/local/bin -xvf oc-mirror.tar
ibmcloud cr namespace-add odf-images


# Resources

* [Installing OpenShift Data Foundation on a private cluster](https://cloud.ibm.com/docs/openshift?topic=openshift-openshift-storage-odf-private)