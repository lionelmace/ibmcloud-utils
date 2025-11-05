########################################################################################################################
# Input variables
########################################################################################################################

variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API key."
  sensitive   = true
}

variable "provider_visibility" {
  description = "Set the visibility value for the IBM terraform provider. Supported values are `public`, `private`, `public-and-private`. [Learn more](https://registry.terraform.io/providers/IBM-Cloud/ibm/latest/docs/guides/custom-service-endpoints)."
  type        = string
  default     = "private"

  validation {
    condition     = contains(["public", "private", "public-and-private"], var.provider_visibility)
    error_message = "Invalid visibility option. Allowed values are 'public', 'private', or 'public-and-private'."
  }
}

variable "prefix" {
  type        = string
  nullable    = true
  description = "The prefix to add to all resources that this solution creates (e.g `prod`, `test`, `dev`). To skip using a prefix, set this value to `null` or an empty string. [Learn more](https://terraform-ibm-modules.github.io/documentation/#/prefix.md)."

  validation {
    # - null and empty string is allowed
    # - Must not contain consecutive hyphens (--): length(regexall("--", var.prefix)) == 0
    # - Starts with a lowercase letter: [a-z]
    # - Contains only lowercase letters (a–z), digits (0–9), and hyphens (-)
    # - Must not end with a hyphen (-): [a-z0-9]
    condition = (var.prefix == null || var.prefix == "" ? true :
      alltrue([
        can(regex("^[a-z][-a-z0-9]*[a-z0-9]$", var.prefix)),
        length(regexall("--", var.prefix)) == 0
      ])
    )
    error_message = "Prefix must begin with a lowercase letter and may contain only lowercase letters, digits, and hyphens '-'. It must not end with a hyphen('-'), and cannot contain consecutive hyphens ('--')."
  }

  validation {
    # must not exceed 16 characters in length
    condition     = var.prefix == null || var.prefix == "" ? true : length(var.prefix) <= 16
    error_message = "Prefix must not exceed 16 characters."
  }
}

variable "region" {
  type        = string
  description = "The region to provision all resources."
  default     = "eu-de"
}

variable "existing_resource_group_name" {
  type        = string
  description = "The name of an existing resource group to provision the resources. [Learn more](https://cloud.ibm.com/docs/account?topic=account-rgs&interface=ui#create_rgs) about how to create a resource group."
  default     = "Default"
}

variable "code_engine_project_name" {
  description = "The name of the IBM Cloud Code Engine project to be deployed. If specified, the prefix leads the project name in the <prefix>-<code_engine_project_name> format."
  type        = string
  default     = "project"
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to add to the created resources."
  default     = []
}


##############################################################################
# vpc
##############################################################################

variable "enable_cloud_logs" {
  description = "Whether to enable support for Cloud Logs. If enabled, a new Cloud Logs instance will be provisioned and integrated with the deployment."
  type        = bool
  nullable    = false
  default     = true
}

variable "vpc_zones" {
  type        = number
  description = "Number of VPC zones to use (must be 1, 2, or 3)"
  default     = 3

  validation {
    condition     = contains([1, 2, 3], var.vpc_zones)
    error_message = "zones must be 1, 2, or 3 only."
  }
}

variable "cos_plan" {
  description = "The plan to use when Object Storage instances are created. [Learn more](https://cloud.ibm.com/docs/cloud-object-storage?topic=cloud-object-storage-provision)."
  type        = string
  default     = "standard"
  validation {
    condition     = contains(["standard", "cos-one-rate-plan"], var.cos_plan)
    error_message = "The value is not valid. Possible values are `standard` or `cos-one-rate-plan`."
  }
}

########################################################################################################################
# Cloud monitoring
########################################################################################################################

variable "cloud_monitoring_plan" {
  type        = string
  description = "The IBM Cloud Monitoring plan to provision. If 'None' is selected, Cloud Monitoring will not be configured."
  default     = "graduated-tier"

  validation {
    condition     = can(regex("^none$|^lite$|^graduated-tier$", var.cloud_monitoring_plan))
    error_message = "The plan value must be one of the following: none, lite and graduated-tier."
  }
}

variable "enable_platform_metrics" {
  type        = bool
  description = "Receive platform metrics in the provisioned IBM Cloud Monitoring instance. Only 1 instance in a given region can be enabled for platform metrics."
  default     = false
}