## terraform apply -var-file="testing.tfvars"

##############################################################################
## Global Variables
##############################################################################
#ibmcloud_api_key = ""      # Set the variable export TF_VAR_ibmcloud_api_key=
prefix         = "debug"
region         = "eu-de" # eu-de for Frankfurt MZR
resource_group = "debug"
tags           = ["tf", "debug"]


##############################################################################
## VPC
##############################################################################
vpc_classic_access            = false
vpc_address_prefix_management = "manual"
vpc_enable_public_gateway     = true
# vpc_locations                 = ["eu-de-1", "eu-de-2", "eu-de-3"]
# vpc_number_of_addresses       = 256


##############################################################################
## Cluster Kubernetes
##############################################################################
kubernetes_cluster_name          = "iks"
kubernetes_worker_pool_flavor    = "bx2.4x16"
kubernetes_worker_nodes_per_zone = 1
kubernetes_version               = "1.23.3"
kubernetes_wait_till             = "OneWorkerNodeReady"
# worker_pools=[ { name = "dev" machine_type = "cx2.8x16" workers_per_zone = 2 },
#                { name = "test" machine_type = "mx2.4x32" workers_per_zone = 2 } ]

##############################################################################
## Cluster OpenShift
##############################################################################
openshift_cluster_name       = "iro"
openshift_worker_pool_flavor = "bx2.4x16"
openshift_version            = "4.9.17_openshift"
# Possible values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
openshift_wait_till          = "OneWorkerNodeReady"

