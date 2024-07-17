##############################################################################
## Global Variables
##############################################################################

#region     = "eu-de"     # eu-de for Frankfurt MZR
#icr_region = "de.icr.io"
# existing_resource_group_name = ""

##############################################################################
## VPC
##############################################################################
vpc_classic_access            = false
vpc_address_prefix_management = "manual"
vpc_enable_public_gateway     = false


##############################################################################
## Existing Secrets Manager and Activity Tracker
##############################################################################
 # Create a trial version of no name is mentioned
existing_secrets_manager_name = ""
# existing_secrets_manager_name = "secrets-manager"
activity_tracker_name         = "activity-tracker"


##############################################################################
## Cluster ROKS
##############################################################################
openshift_version         = "4.15_openshift"
openshift_os              = "RHCOS"
# openshift_machine_flavor  = "bx2.16x64" # ODF Flavors
openshift_machine_flavor = "bx2.4x16"
openshift_disable_public_service_endpoint = true
# By default, public outbound access is blocked in OpenShift 4.15
openshift_disable_outbound_traffic_protection = false

# Available values: MasterNodeReady, OneWorkerNodeReady, or IngressReady
openshift_wait_till          = "OneWorkerNodeReady"
openshift_update_all_workers = false


##############################################################################
## Observability: Log Analysis (Mezmo) & Monitoring (Sysdig)
##############################################################################
# Available Plans: lite, 7-day, 14-day, 30-day
# log_plan                 = "7-day"
# log_enable_platform_logs = false

sysdig_plan                    = "graduated-tier"
sysdig_enable_platform_metrics = false