##############################################################################
## Global Variables
##############################################################################

#region     = "eu-de"     # eu-de for Frankfurt MZR
#icr_region = "de.icr.io"

##############################################################################
## VPC
##############################################################################
vpc_classic_access            = false
vpc_address_prefix_management = "manual"
vpc_enable_public_gateway     = true


##############################################################################
## Cluster IKS
##############################################################################
iks_worker_nodes_per_zone = 1
iks_machine_flavor        = "bx2.4x16"
# iks_machine_flavor    = "bx2.16x64" # ODF or Portworx flavor

# Possible values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
iks_wait_till          = "IngressReady"
iks_update_all_workers = true


##############################################################################
## Cluster ROKS
##############################################################################
openshift_machine_flavor = "bx2.4x16"
# openshift_machine_flavor = "bx2.16x64" # ODF Flavors

# Available values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
openshift_wait_till          = "OneWorkerNodeReady"
openshift_update_all_workers = false


##############################################################################
## COS
##############################################################################
cos_plan   = "standard"
cos_region = "global"


##############################################################################
## Observability: Log Analysis (Mezmo) & Monitoring (Sysdig)
##############################################################################
# Available Plans: lite, 7-day, 14-day, 30-day
log_plan                 = "7-day"
log_enable_platform_logs = false

sysdig_plan                    = "graduated-tier"
sysdig_enable_platform_metrics = false