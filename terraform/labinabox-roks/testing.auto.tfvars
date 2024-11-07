##############################################################################
## Global Variables
##############################################################################

#region     = "eu-de"     # eu-de for Frankfurt MZR
#icr_region = "de.icr.io"

##############################################################################
## VPC
##############################################################################
vpc_address_prefix_management = "manual"
vpc_enable_public_gateway     = true

existing_resource_group_name = "techxchange-group"

##############################################################################
## Cluster ROKS
##############################################################################
# Optional: Specify OpenShift version. If not included, 4.16 is used
openshift_version = ""
# openshift_os             = "REDHAT_8_64"
openshift_os             = "RHCOS"
openshift_machine_flavor = "bx2.4x16"
# openshift_machine_flavor = "bx2.16x64" # ODF Flavors


openshift_disable_public_service_endpoint = false
# Secure By default - Public outbound access is blocked as of OpenShift 4.15
# Protect network traffic by enabling only the connectivity necessary 
# for the cluster to operate and preventing access to the public Internet.
# By default, value is false.
openshift_disable_outbound_traffic_protection = true

# Available values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
openshift_wait_till          = "OneWorkerNodeReady"
openshift_update_all_workers = true

##############################################################################
## Secrets Manager
##############################################################################
existing_secrets_manager_name = "secrets-manager"

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

activity_tracker_name = "activity-tracker"
