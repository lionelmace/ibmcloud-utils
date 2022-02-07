##############################################################################
# Account Variables
##############################################################################

variable "ibmcloud_api_key" {
  description = "The IBM Cloud platform API key needed to deploy IAM enabled resources"
}

variable "prefix" {
  description = "A unique identifier need to provision resources. Must begin with a letter"
  type        = string
  default     = "mytodo"
}

variable "region" {
  description = "IBM Cloud region where all resources will be provisioned"
  default     = "eu-de"
}

variable "resource_group" {
  description = "Name of resource group where all infrastructure will be provisioned"
  default     = "mytodo"

  validation {
    error_message = "Unique ID must begin and end with a letter and contain only letters, numbers, and - characters."
    condition     = can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", var.resource_group))
  }
}

variable "tags" {
  description = "List of Tags"
  type        = list(string)
  default     = ["tf", "mytodo"]
}


##############################################################################
# VPC Variables
##############################################################################

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

/* Used by module vpc
variable "default_address_prefix" {
  description = "Default address prefix creation method"
  type        = string
  default     = null
}*/

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
  description = "List of CIDR blocks for subnets"
  default = [
    "10.10.10.0/24",
    "10.10.11.0/24",
  "10.10.12.0/24"]
}

# variable "address_prefixes" {
#   description = "List of Prefixes for the vpc"
#   type = list(object({
#     name     = string
#     location = string
#     ip_range = string
#   }))
#   default = []
# }

# variable "vpc_locations" {
#   description = "zones per region"
#   type        = list(string)
#   default     = ["eu-de-1", "eu-de-2", "eu-de-3"]
# }

# variable "vpc_number_of_addresses" {
#   description = "Number of IPV4 Addresses"
#   type        = number
#   default     = null
# }

# variable "vpc" {
#   description = "ID of the Existing VPC to which subnets, gateways are to be attached"
#   type        = string
#   default     = null
# }

# variable "subnet_access_control_list" {
#   description = "Network ACL ID"
#   type        = string
#   default     = null
# }

# variable "vpc_routing_table" {
#   description = "Routing Table ID"
#   type        = string
#   default     = null
# }

variable "vpc_enable_public_gateway" {
  description = "Enable public gateways, true or false"
  default     = true
}

# module-vpc
# variable "create_gateway" {
#   description = "True to create new Gateway"
#   type        = bool
#   default     = true
# }

# module-vpc
# variable "public_gateway_name" {
#   description = "Prefix to the names of Public Gateways"
#   type        = string
#   default     = ""
# }

variable "floating_ip" {
  description = "Floating IP `id`'s or `address`'es that you want to assign to the public gateway"
  type        = map(any)
  default     = {}
}

