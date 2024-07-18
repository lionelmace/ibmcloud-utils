##############################################################################
# COS Instance with 2 buckets
# - data bucket where the ingested data is stored
# - metrics bucket to store any metrics that are generated from logs 
#   to optimize storage
##############################################################################


# COS Variables
##############################################################################
variable "cos_plan_for_logs" {
  description = "COS plan type"
  type        = string
  default     = "standard"
}

variable "cos_region_for_logs" {
  description = "Enter Region for provisioning"
  type        = string
  default     = "global"
}

# COS Service
##############################################################################

resource "ibm_resource_instance" "cos-for-logs" {
  name              = format("%s-%s", local.basename, "cos-scc")
  service           = "cloud-object-storage"
  plan              = var.cos_plan_for_logs
  location          = var.cos_region_for_logs
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
resource "ibm_cos_bucket" "logs-bucket-data" {
  bucket_name          = format("%s-%s", local.basename, "bucket-data")
  resource_instance_id = ibm_resource_instance.cos-for-logs.id
  storage_class        = "smart"

  # SCC Control 2.1.1.2
  # Ensure Cloud Object Storage encryption is enabled with BYOK
  # Key management services can only be added during bucket creation.
  depends_on  = [ibm_iam_authorization_policy.iam-auth-kms-cos-for-logs]
  kms_key_crn = ibm_kms_key.key.id

  # Does Cloud Logs require Cross-Region bucket for resiliency?
  cross_region_location = "eu"
  # region_location      = "eu-de"
  endpoint_type = "public"
}

## COS Metrics Bucket
##############################################################################
resource "ibm_cos_bucket" "logs-bucket-metrics" {
  bucket_name          = format("%s-%s", local.basename, "bucket-metrics")
  resource_instance_id = ibm_resource_instance.cos-for-logs.id
  storage_class        = "smart"

  # SCC Control 2.1.1.2
  # Ensure Cloud Object Storage encryption is enabled with BYOK
  # Key management services can only be added during bucket creation.
  depends_on  = [ibm_iam_authorization_policy.iam-auth-kms-cos-for-logs]
  kms_key_crn = ibm_kms_key.key.id

  # Does Cloud Logs require Cross-Region bucket for resiliency?
  cross_region_location = "eu"
  # region_location      = "eu-de"
  endpoint_type = "public"
}
