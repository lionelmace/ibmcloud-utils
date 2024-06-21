##############################################################################
# COS Instance with 2 buckets
# - data bucket where the ingested data is stored
# - metrics bucket to store any metrics that are generated from logs 
#   to optimize storage
##############################################################################


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
  name              = format("%s-%s", local.basename, "cos-scc")
  service           = "cloud-object-storage"
  plan              = var.cos_plan
  location          = var.cos_region
  resource_group_id = local.resource_group_id
  tags              = var.tags

  parameters = {
    # SCC Control 2.1.3
    # Ensure network access for Cloud Object Storage is set to be exposed only on private endpoints
    service-endpoints = "public"
  }
}

## COS Data Bucket
##############################################################################
resource "ibm_cos_bucket" "bucket-data" {
  bucket_name          = format("%s-%s", local.basename, "bucket-data")
  resource_instance_id = ibm_resource_instance.cos.id
  storage_class        = "smart"

  # SCC Control 2.1.1.2
  # Ensure Cloud Object Storage encryption is enabled with BYOK
  # Key management services can only be added during bucket creation.
  depends_on  = [ibm_iam_authorization_policy.iam-auth-kms-cos]
  kms_key_crn = ibm_kms_key.key.id

  # Does Cloud Logs require Cross-Region bucket for resiliency?
  cross_region_location = "eu"
  # region_location      = "eu-de"
  endpoint_type = "public"
}

## COS Metrics Bucket
##############################################################################
resource "ibm_cos_bucket" "bucket-metrics" {
  bucket_name          = format("%s-%s", local.basename, "bucket-metrics")
  resource_instance_id = ibm_resource_instance.cos.id
  storage_class        = "smart"

  # SCC Control 2.1.1.2
  # Ensure Cloud Object Storage encryption is enabled with BYOK
  # Key management services can only be added during bucket creation.
  depends_on  = [ibm_iam_authorization_policy.iam-auth-kms-cos]
  kms_key_crn = ibm_kms_key.key.id

  # Does Cloud Logs require Cross-Region bucket for resiliency?
  cross_region_location = "eu"
  # region_location      = "eu-de"
  endpoint_type = "public"
}
