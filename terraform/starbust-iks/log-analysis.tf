##############################################################################
# Log Analysis Services
##############################################################################

variable "logdna_plan" {
  description = "plan type (14-day, 30-day, 7-day, hipaa-30-day and lite)"
  type        = string
  default     = "30-day"
}

variable "logdna_service_endpoints" {
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  default     = "private"
}

variable "logdna_role" {
  description = "Type of role"
  type        = string
  default     = "Administrator"
}

variable "logdna_bind_key" {
  description = "Flag indicating that key should be bind to logdna instance"
  type        = bool
  default     = true
}

variable "logdna_key_name" {
  description = "Name of the instance key"
  type        = string
  default     = "log-ingestion-key"
}

variable "logdna_private_endpoint" {
  description = "Add this option to connect to your LogDNA service instance through the private service endpoint"
  type        = bool
  default     = true
}

variable "logdna_enable_platform_logs" {
  type        = bool
  description = "Receive platform logs in Logdna"
  default     = false
}

## IAM
##############################################################################
resource "ibm_iam_access_group_policy" "iam-logdna" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Manager", "Viewer", "Standard Member"]

  resources {
    service           = "logdna"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}

## Resources
##############################################################################
module "logging_instance" {
  source = "terraform-ibm-modules/observability/ibm//modules/logging-instance"

  resource_group_id    = ibm_resource_group.resource_group.id
  name                 = format("%s-%s", var.prefix, "logs")
  is_sts_instance      = false
  service_endpoints    = var.logdna_service_endpoints
  bind_key             = var.logdna_bind_key
  key_name             = var.logdna_key_name
  plan                 = var.logdna_plan
  enable_platform_logs = var.logdna_enable_platform_logs
  region               = var.region
  tags                 = var.tags
  key_tags             = var.tags
}

output "logdna_instance_id" {
  description = "The ID of the Log Analysis instance"
  value       = module.logging_instance.id
}