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

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.resource_group))
  }
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf", "federation"]
}



##############################################################################
# XX
##############################################################################

