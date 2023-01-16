## terraform apply -var-file="testing.tfvars"

##############################################################################
## Global Variables
##############################################################################
#ibmcloud_api_key = ""      # Set the variable export TF_VAR_ibmcloud_api_key=
prefix         = "starbust"
region         = "eu-de" # eu-de for Frankfurt MZR
resource_group = "starbust"
tags           = ["tf", "starbust"]


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
# machine_type = "bx2.4x16"
machine_type = "bx2.8x32"
worker_count = 1
kube_version = "1.23.15"
# Possible values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
# kubernetes_wait_till          = "OneWorkerNodeReady"
# kubernetes_update_all_workers = false


##############################################################################
## ICD Postgres
##############################################################################
icd_dbaas_plan = "standard"
# expected length in the range (10 - 32) - must not contain special characters
icd_dbaas_adminpassword     = "Passw0rd01"
icd_dbaas_version        = "11"
icd_dbaas_service_endpoints = "public"
# icd_dbaas_users = [{
#   name     = "user123"
#   password = "password12"
# }]
# icd_dbaas_whitelist = [{
#   address     = "172.168.1.1/32"
#   description = "desc"
# }]


##############################################################################
## Observability: Log Analysis (LogDNA) & Monitoring (Sysdig)
##############################################################################
# Available Plans: lite, 7-day, 14-day, 30-day
logdna_plan                 = "7-day"
logdna_enable_platform_logs = false

sysdig_plan                    = "graduated-tier"
# sysdig_plan                    = "graduated-tier-sysdig-secure-plus-monitor"
sysdig_enable_platform_metrics = false


