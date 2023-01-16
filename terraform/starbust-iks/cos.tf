
##############################################################################
# COS Service for Buckets
##############################################################################

variable "cos_plan" {
  description = "COS plan type"
  type        = string
  default     = "standard"
}

variable "cos_region" {
  description = " Enter Region for provisioning"
  type        = string
  default     = "global"
}

resource "ibm_resource_instance" "cos" {
  name              = "${var.prefix}-cos"
  service           = "cloud-object-storage"
  plan              = var.cos_plan
  location          = var.cos_region
  resource_group_id = ibm_resource_group.resource_group.id
  tags              = var.tags

  parameters = {
    service-endpoints = "private"
  }
}