variable "ibmcloud_api_key" {
  type        = string
  description = "The IBM Cloud API Key"
  sensitive   = true
}

variable "region" {
  type        = string
  description = "Region to provision all resources created by this example"
  default     = "us-south"
}

variable "prefix" {
  type        = string
  description = "Prefix to append to all resources created by this example"
  default     = "redis"
}

variable "resource_group" {
  type        = string
  description = "An existing resource group name to use for this example, if unset a new resource group will be created"
  default     = null
}

variable "resource_tags" {
  type        = list(string)
  description = "Optional list of tags to be added to created resources"
  default     = []
}

variable "access_tags" {
  type        = list(string)
  description = "A list of access tags to apply to the Redis instance created by the module, see https://cloud.ibm.com/docs/account?topic=account-access-tags-tutorial for more details"
  default     = []
}

variable "redis_version" {
  description = "Version of the Redis instance. If no value is passed, the current preferred version of IBM Cloud Databases is used."
  type        = string
  default     = null
}

variable "admin_pass" {
  type        = string
  sensitive   = true
  default     = null
  description = "The password for the database administrator. If the admin password is null then the admin user ID cannot be accessed. More users can be specified in a user block."
}

variable "users" {
  type = list(object({
    name     = string
    password = string
    type     = optional(string)
    role     = optional(string)
  }))
  default     = []
  sensitive   = true
  description = "A list of users that you want to create on the database. Multiple blocks are allowed. The user password must be in the range of 10-32 characters."
}