
##############################################################################
# Monitoring Services
##############################################################################

variable "sysdig_plan" {
  description = "plan type"
  type        = string
  default     = "graduated-tier"
  # default     = "graduated-tier-sysdig-secure-plus-monitor"
}

variable "sysdig_service_endpoints" {
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  default     = "private"
}

variable "sysdig_bind_key" {
  description = "Enable this to bind key to logdna instance (true/false)"
  type        = bool
  default     = true
}

variable "sysdig_key_name" {
  description = "Name of the instance key"
  type        = string
  default     = "sysdig-ingestion-key"
}

variable "sysdig_private_endpoint" {
  description = "Add this option to connect to your Sysdig service instance through the private service endpoint"
  type        = bool
  default     = true
}

variable "sysdig_enable_platform_metrics" {
  type        = bool
  description = "Receive platform metrics in Sysdig"
  default     = false
}

## IAM
##############################################################################
resource "ibm_iam_access_group_policy" "iam-sysdig" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Writer", "Editor"]

  resources {
    service           = "sysdig-monitor"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}


## Resources
##############################################################################
module "monitoring_instance" {
  source = "terraform-ibm-modules/observability/ibm//modules/monitoring-sysdig"

  resource_group_id       = ibm_resource_group.resource_group.id
  name                    = format("%s-%s", var.prefix, "monitoring")
  plan                    = var.sysdig_plan
  service_endpoints       = var.sysdig_service_endpoints
  enable_platform_metrics = var.sysdig_enable_platform_metrics
  bind_key                = var.sysdig_bind_key
  key_name                = var.sysdig_key_name
  region                  = var.region
  tags                    = var.tags
  key_tags                = var.tags
}

output "monitoring_instance_id" {
  description = "The ID of the Cloud Monitoring instance"
  value       = module.monitoring_instance.id
}