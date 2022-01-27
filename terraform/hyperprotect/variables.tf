##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
}

variable "prefix" {
  description = "A unique identifier need to provision resources. Must begin with a letter"
  type        = string
  default     = ""
}

variable "region" {
  description = "IBM Cloud region where all resources will be provisioned"
  default     = ""
}

variable "resource_group" {
  description = "Name of resource group where all infrastructure will be provisioned"
  default     = ""
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf", "mytodo"]
}
