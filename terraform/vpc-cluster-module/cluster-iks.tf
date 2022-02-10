##############################################################################
# Kubernetes cluster
##############################################################################

module "vpc_kubernetes_cluster" {
  source = "terraform-ibm-modules/cluster/ibm//modules/vpc-kubernetes"

  vpc_id             = ibm_is_vpc.vpc.id
  resource_group_id  = ibm_resource_group.resource_group.id
  cluster_name       = var.kubernetes_cluster_name
  worker_pool_flavor = var.kubernetes_worker_pool_flavor
  worker_zones = {
    "${var.region}-1" = { subnet_id = element(ibm_is_subnet.subnet.*.id, 0) },
    "${var.region}-2" = { subnet_id = element(ibm_is_subnet.subnet.*.id, 1) },
    "${var.region}-3" = { subnet_id = element(ibm_is_subnet.subnet.*.id, 2) },
  }
  worker_nodes_per_zone = var.kubernetes_worker_nodes_per_zone
  kube_version          = var.kubernetes_version
  wait_till             = var.kubernetes_wait_till
  force_delete_storage  = var.kubernetes_force_delete_storage
  tags                  = var.tags

  # disable_public_service_endpoint = var.disable_public_service_endpoint
  # update_all_workers              = var.update_all_workers
}
