
##############################################################################
# Create a resource group or reuse an existing one
##############################################################################

variable "rg_name" {
  type        = string
  default     = ""
  description = "Name of Resource Group"
}

data "ibm_resource_group" "group" {
  name = var.rg_name
}