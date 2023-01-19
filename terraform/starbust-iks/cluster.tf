## IAM
##############################################################################
# Create a policy to all Kubernetes instances within the Resource Group
resource "ibm_iam_access_group_policy" "policy-k8s" {
  access_group_id = ibm_iam_access_group.accgrp.id
  roles           = ["Manager", "Writer", "Editor", "Operator", "Viewer"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = ibm_resource_group.resource_group.id
  }
}

## Resources
##############################################################################
resource "ibm_container_vpc_cluster" "cluster" {
  name = format("%s-%s", var.environment_id, var.cluster_name)
  # vpc_id                          = var.vpc_id
  vpc_id       = ibm_is_vpc.vpc.id
  flavor       = var.machine_type
  worker_count = var.worker_count
  # resource_group_id               = var.resource_group_id
  resource_group_id               = ibm_resource_group.resource_group.id
  update_all_workers              = true
  disable_public_service_endpoint = false
  kube_version                    = var.kube_version
  cos_instance_crn                = var.is_openshift_cluster ? ibm_resource_instance.openshift_cos_instance[0].id : null

  dynamic "zones" {
    for_each = { for subnet in ibm_is_subnet.subnet : subnet.id => subnet }
    content {
      name      = zones.value.zone
      subnet_id = zones.value.id
    }
  }

  entitlement = var.entitlement
  tags        = var.tags
}

resource "null_resource" "cluster_wait" {
  triggers = {
    cluster_id = ibm_container_vpc_cluster.cluster.id
  }
  provisioner "local-exec" {
    command = <<EOT
sleep 120
EOT
  }
  depends_on = [ibm_container_vpc_cluster.cluster]
}

resource "ibm_container_vpc_worker_pool" "worker_pools" {
  for_each          = { for pool in var.worker_pools : pool.pool_name => pool }
  cluster           = ibm_container_vpc_cluster.cluster.id
  resource_group_id = ibm_resource_group.resource_group.id
  worker_pool_name  = each.key
  flavor            = lookup(each.value, "machine_type", null)
  vpc_id            = ibm_is_vpc.vpc.id
  # worker_count = lookup(each.value, "min_size", null)
  worker_count = each.value.workers_per_zone

  # labels = merge({ "worker_pool_name" = each.key }, each.value.labels)

  dynamic "zones" {
    for_each = { for subnet in ibm_is_subnet.subnet : subnet.id => subnet }
    content {
      name      = zones.value.zone
      subnet_id = zones.value.id
    }
  }

  depends_on = [null_resource.cluster_wait]
}


data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = ibm_container_vpc_cluster.cluster.id
  resource_group_id = ibm_resource_group.resource_group.id
}

resource "ibm_resource_instance" "openshift_cos_instance" {
  count             = var.is_openshift_cluster ? 1 : 0
  name              = join("-", [var.environment_id, "roks-backup"])
  resource_group_id = ibm_resource_group.resource_group.id
  service           = "cloud-object-storage"
  plan              = "standard"
  location          = "global"
  tags              = var.tags
}
