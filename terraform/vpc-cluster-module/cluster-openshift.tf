
##############################################################################
# OpenShift cluster
##############################################################################

module "vpc_openshift_cluster" {
  source = "terraform-ibm-modules/cluster/ibm//modules/vpc-openshift"

  vpc_id             = ibm_is_vpc.vpc.id
  resource_group_id  = ibm_resource_group.resource_group.id
  cluster_name       = var.openshift_cluster_name
  worker_pool_flavor = var.openshift_worker_pool_flavor
  worker_zones = {
    "${var.region}-1" = { subnet_id = element(ibm_is_subnet.subnet.*.id, 0) },
    "${var.region}-2" = { subnet_id = element(ibm_is_subnet.subnet.*.id, 1) },
    "${var.region}-3" = { subnet_id = element(ibm_is_subnet.subnet.*.id, 2) },
  }
  worker_nodes_per_zone           = var.openshift_worker_nodes_per_zone
  kube_version                    = var.openshift_version
  worker_labels                   = var.worker_labels
  wait_till                       = var.openshift_wait_till
  disable_public_service_endpoint = var.disable_public_service_endpoint
  cos_instance_crn                = module.cos.cos_instance_id
  force_delete_storage            = var.openshift_force_delete_storage
  entitlement                     = var.entitlement
  tags                            = var.tags
}

##############################################################################
# Attach Log Analysis Service to cluster
##############################################################################
module "openshift_logdna_attach" {
  source = "terraform-ibm-modules/cluster/ibm//modules/configure-logdna"

  cluster            = module.vpc_openshift_cluster.vpc_openshift_cluster_id
  logdna_instance_id = module.logging_instance.guid
  private_endpoint   = var.logdna_private_endpoint
}

##############################################################################
# Attach Monitoring Service to cluster
##############################################################################
module "openshift_sysdig_attach" {
  source = "terraform-ibm-modules/cluster/ibm//modules/configure-sysdig-monitor"

  cluster            = module.vpc_openshift_cluster.vpc_openshift_cluster_id
  sysdig_instance_id = module.monitoring_instance.guid
  private_endpoint   = var.sysdig_private_endpoint
}
