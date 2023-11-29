
# COS Variables
##############################################################################
variable "cos_plan" {
  description = "COS plan type"
  type        = string
  default     = "standard"
}

variable "cos_region" {
  description = "Enter Region for provisioning"
  type        = string
  default     = "global"
}

# COS Service
##############################################################################

resource "ibm_resource_instance" "cos" {
  provider          = ibm.enterprise
  name              = format("%s-%s", local.basename, "cos")
  service           = "cloud-object-storage"
  plan              = var.cos_plan
  location          = var.cos_region
  resource_group_id = ibm_resource_group.group.id
  tags              = var.tags

  parameters = {
    service-endpoints = "public"
  }
}

## COS Bucket
##############################################################################
resource "ibm_cos_bucket" "cos-bucket" {
  bucket_name          = format("%s-%s", local.basename, "cos-bucket")
  resource_instance_id = ibm_resource_instance.cos.id
  storage_class        = "smart"

  cross_region_location = "eu"

  endpoint_type = "public"
}
