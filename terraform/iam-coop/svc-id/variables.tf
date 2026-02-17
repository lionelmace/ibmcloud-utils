##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "APIkey that's associated with the account to provision resources to"
  type        = string
  # default     = ""
  sensitive = true
}

variable "region" {
  description = "IBM Cloud region where all resources will be provisioned (e.g. eu-de)"
  default     = "eu-de"
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf", "iam"]
}

variable "prefix" {
  type = string
  # default     = ""
  description = "A prefix for all resources to be created. If none provided a random prefix will be created"
}

# Warning: only computed at apply time, 
resource "random_string" "random" {
  # count = var.prefix == "" ? 1 : 0
  length  = 6
  special = false
  upper   = false
}

locals {
  # Any value that depends on basename (like the VPC name) becomes unknown at plan time.
  # basename = lower(var.prefix == "" ? "icn-${random_string.random.0.result}" : var.prefix)
  # VPE module needs the supplied VPC/Subnet names at plan time. So removed random.
  basename = lower(var.prefix == "" ? "coop" : var.prefix)
}
