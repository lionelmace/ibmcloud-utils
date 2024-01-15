##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "APIkey that's associated with the account to provision resources to"
  type        = string
  default     = ""
  sensitive   = true
}

variable "prefix" {
  type        = string
  default     = ""
  description = "A prefix for all resources to be created. If none provided a random prefix will be created"
}

resource "random_string" "random" {
  count = var.prefix == "" ? 1 : 0

  length  = 6
  special = false
}

locals {
  basename = lower(var.prefix == "" ? "private-${random_string.random.0.result}" : var.prefix)
}

variable "region" {
  description = "IBM Cloud region where all resources will be provisioned (e.g. eu-de)"
  default     = "eu-de"
}

variable "icr_region" {
  description = "IBM Container Registry Region (e.g. de.icr.io)"
  default     = "de.icr.io"
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf", "icn"]
}

# Account ID is required for CBR (Context Based Restrictions) and SCC scope
##############################################################################
data "ibm_iam_auth_token" "tokendata" {}
data "ibm_iam_account_settings" "account_settings" {}

locals {
  account_id = data.ibm_iam_account_settings.account_settings.account_id
}