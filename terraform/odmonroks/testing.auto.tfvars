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
## Cluster ROKS
##############################################################################
# Optional: Specify OpenShift version. If not included, 4.15 is used
openshift_version        = "4.15.17_openshift"
openshift_os             = "RHCOS"
openshift_machine_flavor = "bx2.16x64" # ODF Flavors
# openshift_machine_flavor = "bx2.4x16"

openshift_disable_public_service_endpoint = false
# By default, public outbound access is blocked in OpenShift 4.15
openshift_disable_outbound_traffic_protection = true

# Available values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
openshift_wait_till          = "OneWorkerNodeReady"
openshift_update_all_workers = false

##############################################################################
## Secrets Manager
##############################################################################
# existing_secrets_manager_name = "secrets-manager"
existing_secrets_manager_name = ""

##############################################################################
## COS
##############################################################################
# cos_plan   = "standard"
# cos_region = "global"


##############################################################################
## Observability: Log Analysis (Mezmo) & Monitoring (Sysdig)
##############################################################################
# Available Plans: lite, 7-day, 14-day, 30-day
log_plan                 = "7-day"
log_enable_platform_logs = false

sysdig_plan                    = "graduated-tier"
sysdig_enable_platform_metrics = false

activity_tracker_name = "activity-tracker"
