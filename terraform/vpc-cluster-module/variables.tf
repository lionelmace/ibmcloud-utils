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


##############################################################################
# COS Service
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


##############################################################################
# Kubernetes Cluster
##############################################################################

variable "kubernetes_cluster_name" {
  description = "name for the iks cluster"
  default     = "iks"
}

variable "kubernetes_worker_pool_flavor" {
  description = "The flavor of VPC worker node to use for your cluster. Use `ibmcloud ks flavors` to find flavors for a region."
  type        = string
  default     = "bx2.4x16"
}

# variable "kubernetes_worker_zones" {
#   type    = map
#   default = {}
# }

variable "kubernetes_worker_nodes_per_zone" {
  description = "Number of workers to provision in each subnet"
  type        = number
  default     = 1
}

variable "kubernetes_version" {
  description = "Specify the Kubernetes version, including the major.minor version. To see available versions, run `ibmcloud ks versions`."
  type        = string
  default     = "1.22.4"
}

variable "kubernetes_wait_till" {
  description = "To avoid long wait times when you run your Terraform code, you can specify the stage when you want Terraform to mark the cluster resource creation as completed. Depending on what stage you choose, the cluster creation might not be fully completed and continues to run in the background. However, your Terraform code can continue to run without waiting for the cluster to be fully created. Supported args are `MasterNodeReady`, `OneWorkerNodeReady`, and `IngressReady`"
  type        = string
  default     = "OneWorkerNodeReady"

  validation {
    error_message = "`kubernetes_wait_till` value must be one of `MasterNodeReady`, `OneWorkerNodeReady`, or `IngressReady`."
    condition = contains([
      "MasterNodeReady",
      "OneWorkerNodeReady",
      "IngressReady"
    ], var.kubernetes_wait_till)
  }
}

variable "kubernetes_force_delete_storage" {
  description = "force the removal of persistent storage associated with the cluster during cluster deletion."
  type        = bool
  default     = true
}


##############################################################################
# OpenShift
##############################################################################

variable "openshift_cluster_name" {
  description = "Name of the cluster"
  type        = string
  default     = "iro"
}

variable "openshift_worker_pool_flavor" {
  description = " The flavor of the VPC worker node that you want to use."
  type        = string
  default     = "bx2.4x16"
}

variable "openshift_version" {
  description = "The OpenShift version that you want to set up in your cluster."
  type        = string
  default     = "4.8.21_openshift"
}

variable "openshift_worker_nodes_per_zone" {
  description = "The number of worker nodes per zone in the default worker pool."
  type        = number
  default     = 1
}

variable "worker_labels" {
  description = "Labels on all the workers in the default worker pool."
  type        = map(any)
  default     = null
}

variable "openshift_wait_till" {
  description = "specify the stage when Terraform to mark the cluster creation as completed."
  type        = string
  default     = "OneWorkerNodeReady"

  validation {
    error_message = "`openshift_wait_till` value must be one of `MasterNodeReady`, `OneWorkerNodeReady`, or `IngressReady`."
    condition = contains([
      "MasterNodeReady",
      "OneWorkerNodeReady",
      "IngressReady"
    ], var.openshift_wait_till)
  }
}

variable "disable_public_service_endpoint" {
  description = "Boolean value true if Public service endpoint to be disabled."
  type        = bool
  default     = false
}

variable "openshift_force_delete_storage" {
  description = "force the removal of persistent storage associated with the cluster during cluster deletion."
  type        = bool
  default     = true
}

variable "kms_config" {
  type    = list(map(string))
  default = []
}

variable "entitlement" {
  description = "Enable openshift entitlement during cluster creation ."
  type        = string
  default     = "cloud_pak"
}


##############################################################################
# Module: Log Services
##############################################################################
variable "logdna_plan" {
  description = "plan type (14-day, 30-day, 7-day, hipaa-30-day and lite)"
  type        = string
  default     = "30-day"
}

variable "logdna_service_endpoints" {
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  default     = "private"
}

variable "logdna_role" {
  description = "Type of role"
  type        = string
  default     = "Administrator"
}

variable "logdna_bind_key" {
  description = "Flag indicating that key should be bind to logdna instance"
  type        = bool
  default     = true
}

variable "logdna_key_name" {
  description = "Name of the instance key"
  type        = string
  default     = "log-ingestion-key"
}

variable "logdna_private_endpoint" {
  description = "Add this option to connect to your LogDNA service instance through the private service endpoint"
  type        = bool
  default     = true
}

variable "logdna_enable_platform_logs" {
  type        = bool
  description = "Receive platform logs in Logdna"
  default     = false
}


##############################################################################
# Monitoring Services
##############################################################################
variable "sysdig_plan" {
  description = "plan type"
  type        = string
  default     = "graduated-tier-sysdig-secure-plus-monitor"
}

variable "sysdig_service_endpoints" {
  description = "Types of the service endpoints. Possible values are 'public', 'private', 'public-and-private'."
  type        = string
  default     = "private"
}

variable "sysdig_bind_key" {
  description = "Enable this to bind key to logdna instance (true/false)"
  type        = bool
  default     = true
}

variable "sysdig_key_name" {
  description = "Name of the instance key"
  type        = string
  default     = "sysdig-ingestion-key"
}

variable "sysdig_private_endpoint" {
  description = "Add this option to connect to your Sysdig service instance through the private service endpoint"
  type        = bool
  default     = true
}

variable "sysdig_enable_platform_metrics" {
  type        = bool
  description = "Receive platform metrics in Sysdig"
  default     = false
}
