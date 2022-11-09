## terraform apply -var-file="testing.tfvars"

##############################################################################
## Global Variables
##############################################################################
#ibmcloud_api_key = ""      # Set the variable export TF_VAR_ibmcloud_api_key=
prefix         = "showme"
region         = "eu-de" # eu-de for Frankfurt MZR
resource_group = "showme"
tags           = ["tf", "showme"]


##############################################################################
## VPC
##############################################################################
vpc_classic_access            = false
vpc_address_prefix_management = "manual"
vpc_enable_public_gateway     = true


##############################################################################
## Cluster Kubernetes
##############################################################################
cluster_name = "iks"
machine_type = "bx2.4x16"
worker_count = 1
kube_version = "1.25.3"
# Possible values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
# kubernetes_wait_till          = "OneWorkerNodeReady"
# kubernetes_update_all_workers = false
# worker_pools=[ { name = "dev" machine_type = "cx2.8x16" workers_per_zone = 2 },
#                { name = "test" machine_type = "mx2.4x32" workers_per_zone = 2 } ]


##############################################################################
## Observability: Log Analysis (LogDNA) & Monitoring (Sysdig)
##############################################################################
# Available Plans: lite, 7-day, 14-day, 30-day
logdna_plan                 = "7-day"
logdna_enable_platform_logs = false

sysdig_plan                    = "graduated-tier-sysdig-secure-plus-monitor"
sysdig_enable_platform_metrics = false


