##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "APIkey that's associated with the account to provision resources to"
  type        = string
  default     = ""
  sensitive   = true
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