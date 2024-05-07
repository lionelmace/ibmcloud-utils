##############################################################################
# Kubernetes cluster
##############################################################################


# Kubernetes Variables
##############################################################################

variable "iks_cluster_name" {
  description = "name for the iks cluster"
  default     = "kasten-iks-cluster"
}

variable "iks_version" {
  description = "Specify the Kubernetes version, including the major.minor version. To see available versions, run `ibmcloud ks versions`."
  type        = string
  default     = ""
}

variable "iks_machine_flavor" {
  description = "The flavor of VPC worker node to use for your cluster. Use `ibmcloud ks flavors` to find flavors for a region."
  type        = string
  default     = "bx2.4x16"
}

variable "iks_worker_nodes_per_zone" {
  description = "Number of workers to provision in each subnet"
  type        = number
  default     = 1
}

variable "iks_wait_till" {
  description = "To avoid long wait times when you run your Terraform code, you can specify the stage when you want Terraform to mark the cluster resource creation as completed. Depending on what stage you choose, the cluster creation might not be fully completed and continues to run in the background. However, your Terraform code can continue to run without waiting for the cluster to be fully created. Supported args are `MasterNodeReady`, `OneWorkerNodeReady`, and `IngressReady`"
  type        = string
  default     = "OneWorkerNodeReady"

  validation {
    error_message = "`iks_wait_till` value must be one of `MasterNodeReady`, `OneWorkerNodeReady`, or `IngressReady`."
    condition = contains([
      "MasterNodeReady",
      "OneWorkerNodeReady",
      "IngressReady"
    ], var.iks_wait_till)
  }
}

variable "iks_force_delete_storage" {
  description = "force the removal of persistent storage associated with the cluster during cluster deletion."
  type        = bool
  default     = true
}

variable "iks_update_all_workers" {
  description = "Kubernetes version of the worker nodes is updated."
  type        = bool
  default     = true
}

variable "iks_disable_public_service_endpoint" {
  description = "Boolean value true if Public service endpoint to be disabled."
  type        = bool
  default     = false
}

variable "iks_worker_pools" {
  description = "List of maps describing worker pools"

  type = list(object({
    pool_name        = string
    machine_type     = string
    workers_per_zone = number
  }))

  default = [
    {
      pool_name        = "dev"
      machine_type     = "cx2.2x4"
      workers_per_zone = 1
      # },
      # {
      #     pool_name        = "secondary"
      #     machine_type     = "bx2.16x64"
      #     workers_per_zone = 1
    }
  ]

  validation {
    error_message = "Worker pool names must match the regex `^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$`."
    condition = length([
      for pool in var.iks_worker_pools :
      false if !can(regex("^([a-z]|[a-z][-a-z0-9]*[a-z0-9])$", pool.pool_name))
    ]) == 0
  }

  validation {
    error_message = "Worker pools cannot have duplicate names."
    condition = length(distinct([
      for pool in var.iks_worker_pools :
      pool.pool_name
    ])) == length(var.iks_worker_pools)
  }
}

## Resources
##############################################################################
resource "ibm_container_vpc_cluster" "iks_cluster" {
  name              = format("%s-%s", local.basename, var.iks_cluster_name)
  vpc_id            = ibm_is_vpc.vpc.id
  resource_group_id = ibm_resource_group.group.id
  # Optional: Specify Kubes version. If not included, default version is used
  kube_version         = var.iks_version == "" ? null : var.iks_version
  tags                 = var.tags
  update_all_workers   = var.iks_update_all_workers
  force_delete_storage = var.iks_force_delete_storage

  flavor                          = var.iks_machine_flavor
  worker_count                    = var.iks_worker_nodes_per_zone
  wait_till                       = var.iks_wait_till
  disable_public_service_endpoint = var.iks_disable_public_service_endpoint
  # By default, public outbound access is blocked in OpenShift versions 4.15
  disable_outbound_traffic_protection = true


  dynamic "zones" {
    for_each = { for subnet in ibm_is_subnet.subnet : subnet.id => subnet }
    content {
      name      = zones.value.zone
      subnet_id = zones.value.id
    }
  }

  kms_config {
    instance_id      = ibm_resource_instance.key-protect.guid # GUID of Key Protect instance
    crk_id           = ibm_kms_key.key.key_id                 # ID of customer root key
    private_endpoint = true
  }
}

# Additional Worker Pool
##############################################################################
resource "ibm_container_vpc_worker_pool" "iks_worker_pools" {
  for_each          = { for pool in var.iks_worker_pools : pool.pool_name => pool }
  cluster           = ibm_container_vpc_cluster.iks_cluster.id
  resource_group_id = ibm_resource_group.group.id
  worker_pool_name  = each.key
  flavor            = lookup(each.value, "machine_type", null)
  vpc_id            = ibm_is_vpc.vpc.id
  worker_count      = each.value.workers_per_zone

  dynamic "zones" {
    for_each = { for subnet in ibm_is_subnet.subnet : subnet.id => subnet }
    content {
      name      = zones.value.zone
      subnet_id = zones.value.id
    }
  }
}

# data "ibm_container_vpc_alb" "iks_cluster_alb" {
#   alb_id = ibm_container_vpc_cluster.iks_cluster.albs[0].id
# }

# output "iks_cluster_alb" {
#   value = data.ibm_container_vpc_alb.iks_cluster_alb
# }

##############################################################################
# Connect Log Analysis Service to cluster
# 
# Integrating Logging requires the master node to be 'Ready'
# If not, you will face a timeout error after 45mins
##############################################################################
resource "ibm_ob_logging" "iks_connect_log" {
  depends_on       = [module.log_analysis.key_guid]
  cluster          = ibm_container_vpc_cluster.iks_cluster.id
  instance_id      = module.log_analysis.guid
  private_endpoint = var.log_private_endpoint
}

##############################################################################
# Connect Monitoring Service to cluster
# 
# Integrating Monitoring requires the master node to be 'Ready'
# If not, you will face a timeout error after 45mins
##############################################################################
resource "ibm_ob_monitoring" "iks_connect_monitoring" {
  depends_on       = [module.cloud_monitoring.key_guid]
  cluster          = ibm_container_vpc_cluster.iks_cluster.id
  instance_id      = module.cloud_monitoring.guid
  private_endpoint = var.sysdig_private_endpoint
}


# Registers a Secrets Manager instance with the IKS cluster
##############################################################################

# Authorization policy between IKS and Secrets Manager
resource "ibm_iam_authorization_policy" "iks-sm" {
  source_service_name         = "containers-kubernetes"
  source_resource_instance_id = ibm_container_vpc_cluster.iks_cluster.id
  target_service_name         = "secrets-manager"
  target_resource_instance_id = local.secrets_manager_guid
  roles                       = ["Manager"]
}

resource "ibm_container_ingress_instance" "instance" {
  cluster      = ibm_container_vpc_cluster.iks_cluster.id
  instance_crn = local.secrets_manager_id
  is_default   = true
}