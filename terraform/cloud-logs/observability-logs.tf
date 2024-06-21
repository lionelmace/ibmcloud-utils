
##############################################################################
# Cloud Logs Services
##############################################################################


# Cloud Logs Variables
##############################################################################
# variable "sysdig_plan" {
#   description = "plan type"
#   type        = string
#   default     = "graduated-tier"
#   # default     = "graduated-tier-sysdig-secure-plus-monitor"
# }

# variable "sysdig_private_endpoint" {
#   description = "Add this option to connect to your Sysdig service instance through the private service endpoint"
#   type        = bool
#   default     = true
# }


# Cloud Logs Resource
##############################################################################

resource "ibm_resource_instance" "logs_instance" {
  resource_group_id = local.resource_group_id
  name              = format("%s-%s", local.basename, "cloud-logs")
  service           = "logs"
  plan              = "beta"
  location          = var.region
  tags              = var.tags
  service_endpoints = "private"
}
