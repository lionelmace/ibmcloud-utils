##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
  type        = string
}

variable "prefix" {
  description = "A unique identifier need to provision resources. Must begin with a letter"
  type        = string
  default     = "starbust"
}

variable "region" {
  description = "IBM Cloud region where all resources will be provisioned"
  default     = "eu-de"
}

variable "resource_group" {
  description = "Name of resource group where all infrastructure will be provisioned"
  default     = "starbust"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.resource_group))
  }
}

variable "environment_id" {
  description = "Environment"
  default     = "dev"
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf", "starbust"]
}

##############################################################################
# OpenShift Variables
##############################################################################

variable "cluster_name" {
  description = "Cluster Name"
  default     = "standard"
}

variable "machine_type" {
  description = "The flavor of VPC worker node to use for your cluster. Use `ibmcloud ks flavors` to find flavors for a region."
  type        = string
  default     = "bx2.4x16"
}

variable "kube_version" {
  description = "Specify the Kubernetes version, including the major.minor version. To see available versions, run `ibmcloud ks versions`."
  type        = string
  default     = "1.23.15"
  # default     = "4.11.8_openshift"
}

variable "worker_count" {
  description = "Specify the number of workers."
  type        = number
  default     = "2"
}

variable "is_openshift_cluster" {
  type    = bool
  default = false
}

variable "worker_pools" {
  description = "List of maps describing worker pools"

  type = list(object({
    pool_name        = string
    machine_type     = string
    workers_per_zone = number
  }))

  default = [
    {
      pool_name        = "dev"
      machine_type     = "bx2.8x32"
      workers_per_zone = 1
      # },
      # {
      #     pool_name        = "odf"
      #     machine_type     = "bx2.16x64"
      #     workers_per_zone = 1
    }
  ]

  validation {
    error_message = "Worker pool names must match the regex `^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$`."
    condition = length([
      for pool in var.worker_pools :
      false if !can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", pool.pool_name))
    ]) == 0
  }

  validation {
    error_message = "Worker pools cannot have duplicate names."
    condition = length(distinct([
      for pool in var.worker_pools :
      pool.pool_name
    ])) == length(var.worker_pools)
  }

  # validation {
  #   error_message = "Worker pools must have at least two workers per zone."
  #   condition = length([
  #     for pool in var.worker_pools :
  #     false if pool.workers_per_zone < 2
  #   ]) == 0
  # }

}

variable "entitlement" {
  description = "Enable openshift entitlement during cluster creation ."
  type        = string
  default     = "cloud_pak"
}


##############################################################################
# VPC Variables
##############################################################################

# variable subnet_zone_list {
#     description = "A map containing cluster subnet IDs and subnet zones"
#     type        = list(
#       object(
#         {
#           id   = string
#           zone = string
#       }
#     )
#   )
# }

variable "create_vpc" {
  description = "True to create new VPC. False if VPC is already existing and subnets or address prefixies are to be added"
  type        = bool
  default     = true
}

variable "vpc_classic_access" {
  description = "Classic Access to the VPC"
  type        = bool
  default     = false
}

variable "vpc_address_prefix_management" {
  description = "Default address prefix creation method"
  type        = string
  default     = "manual"
}

variable "vpc_acl_rules" {
  default = [
    {
      name        = "egress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "inbound"
    },
    {
      name        = "ingress"
      action      = "allow"
      source      = "0.0.0.0/0"
      destination = "0.0.0.0/0"
      direction   = "outbound"
    }
  ]
}

variable "vpc_cidr_blocks" {
  description = "List of CIDR blocks for Address Prefix"
  default = [
    "10.243.0.0/18",
    "10.243.64.0/18",
  "10.243.128.0/18"]
}

variable "subnet_cidr_blocks" {
  description = "List of CIDR blocks for subnets"
  default = [
    "10.243.0.0/24",
    "10.243.64.0/24",
  "10.243.128.0/24"]
}

variable "vpc_enable_public_gateway" {
  description = "Enable public gateways, true or false"
  default     = true
}

variable "floating_ip" {
  description = "Floating IP `id`'s or `address`'es that you want to assign to the public gateway"
  type        = map(any)
  default     = {}
}
