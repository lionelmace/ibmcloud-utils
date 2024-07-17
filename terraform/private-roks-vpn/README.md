# Deploy an air-gapped ROKS cluster with VPN

Those Terraform scripts will deploy the following services:
* VPC with 3 subnets without any Public Gateway
* ROKS cluster with public service endpoint disable et outbound protect traffic enabled
* VPN with automatically generated .ovpn to be able to connect to the OpenShift Console

## Resources

* [Installing OpenShift Data Foundation on a private cluster](https://cloud.ibm.com/docs/openshift?topic=openshift-openshift-storage-odf-private)