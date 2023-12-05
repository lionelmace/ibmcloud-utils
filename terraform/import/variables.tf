variable "ibmcloud_api_key" {
  type = string
}

variable "region" {
  type        = string
  default     = "eu-de"
  description = "Region where to deploy the resources"
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf", "training"]
}

variable "prefix" {
  type        = string
  default     = ""
  description = "A prefix for all resources to be created. If none provided a random prefix will be created"
}

# resource "random_string" "random" {
#   count = var.prefix == "" ? 1 : 0

#   length  = 6
#   special = false
# }

# locals {
#   basename = lower(var.prefix == "" ? "learn-${random_string.random.0.result}" : var.prefix)
# }