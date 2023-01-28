
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

## IAM
##############################################################################
# Platform Role "Operator" enables to create Service Credentials
resource "ibm_iam_access_group_policy" "policy-cos" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Reader", "Writer", "Manager", "Content Reader", "Object Reader", "Object Writer", "Operator"]
 
  resources {
    service           = "cloud-object-storage"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}

## Resources
##############################################################################
resource "ibm_resource_instance" "cos" {
  name              = format("%s-%s", var.prefix, "cos")
  service           = "cloud-object-storage"
  plan              = var.cos_plan
  location          = var.cos_region
  resource_group_id = ibm_resource_group.resource_group.id
  tags              = var.tags

  parameters = {
    service-endpoints = "private"
  }
}