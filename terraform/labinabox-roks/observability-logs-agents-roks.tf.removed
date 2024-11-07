# ############################################################################
# Install observability agents
# ############################################################################

##############################################################################
# Service ID with logs sender role + apikey
##############################################################################

# As a `Sender`, you can send logs to your IBM Cloud Logs service instance - but not query or tail logs. This role is meant to be used by agents and routers sending logs.
module "iam_service_id" {
  source                          = "terraform-ibm-modules/iam-service-id/ibm"
  version                         = "1.2.0"
  iam_service_id_name             = format("%s-%s", local.basename, "service-id")
  iam_service_id_description      = "Logs Agent service id"
  iam_service_id_apikey_provision = true
  iam_service_policies = {
    logs = {
      roles = ["Sender"]
      resources = [{
        service = "logs"
      }]
    }
  }
}

data "ibm_container_cluster_config" "cluster_config" {
  cluster_name_id   = ibm_container_vpc_cluster.roks_cluster.id
  resource_group_id = ibm_resource_group.group.id
}

# Sleep to allow RBAC sync on cluster
resource "time_sleep" "wait_operators" {
  depends_on      = [data.ibm_container_cluster_config.cluster_config]
  create_duration = "45s"
}

module "observability_agents" {
  source                    = "terraform-ibm-modules/observability-agents/ibm"
  is_vpc_cluster            = true
  cluster_id                = ibm_container_vpc_cluster.roks_cluster.id
  cluster_resource_group_id = ibm_resource_group.group.id
  depends_on                = [time_sleep.wait_operators]

  # Logs Agent
  logs_agent_enabled     = true
  logs_agent_iam_mode    = "IAMAPIKey"
  logs_agent_iam_api_key = module.iam_service_id.service_id_apikey
  # cloud_logs_ingress_endpoint = module.observability_instances.cloud_logs_ingress_private_endpoint
  cloud_logs_ingress_endpoint = ibm_resource_instance.logs_instance.extensions.external_ingress_private
  cloud_logs_ingress_port     = 3443
  logs_agent_enable_scc       = true # only true for Openshift

  # Monitoring agent
  cloud_monitoring_enabled = false
  #   cloud_monitoring_access_key      = module.observability_instances.cloud_monitoring_access_key
  #   cloud_monitoring_instance_region = module.observability_instances.region
}