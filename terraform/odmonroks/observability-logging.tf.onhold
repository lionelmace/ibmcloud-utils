##############################################################################
# Log Analysis Services
##############################################################################


# Log Variables
##############################################################################
variable "log_plan" {
  description = "plan type (7-day, 14-day, 30-day, hipaa-30-day and lite)"
  type        = string
  default     = "7-day"
}

variable "log_service_endpoints" {
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  default     = "private"
}

variable "log_private_endpoint" {
  description = "Add this option to connect to your LogDNA service instance through the private service endpoint"
  type        = bool
  default     = true
}

variable "log_enable_platform_logs" {
  type        = bool
  description = "Receive platform logs in Logdna"
  default     = false
}

# required log analysis provider config
locals {
  at_endpoint = "https://api.${var.region}.logging.cloud.ibm.com"
}

provider "logdna" {
  alias      = "ld"
  servicekey = module.log_analysis.resource_key
  url        = local.at_endpoint
}

# Log Resource/Instance
##############################################################################

module "log_analysis" {
  source = "terraform-ibm-modules/observability-instances/ibm//modules/log_analysis"
  # version = "latest"
  providers = {
    logdna.ld = logdna.ld
  }

  resource_group_id    = ibm_resource_group.group.id
  instance_name        = format("%s-%s", local.basename, "logs")
  service_endpoints    = var.log_service_endpoints
  plan                 = var.log_plan
  enable_platform_logs = var.log_enable_platform_logs
  region               = var.region
  manager_key_tags     = var.tags
  tags                 = var.tags
}

output "log_analysis_crn" {
  description = "The CRN of the Log Analysis instance"
  value       = module.log_analysis.crn
}

## IAM
##############################################################################

resource "ibm_iam_access_group_policy" "iam-log-analysis" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Manager", "Viewer", "Standard Member"]

  resources {
    service           = "logdna"
    resource_group_id = ibm_resource_group.group.id
  }
}
