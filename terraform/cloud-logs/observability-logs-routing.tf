
# Cloud Logs Routing
##############################################################################
resource "ibm_logs_router_tenant" "logs_router_tenant_instance" {
  name   = format("%s-%s", local.basename, "cloud-logs-router")
  region = var.region
  targets {
    log_sink_crn = ibm_resource_instance.logs_instance.id
    name = "my-cloud-logs-target"
    parameters {
      # Private Endpoint is not supported yet.
      # host = ibm_resource_instance.logs_instance.extensions.external_ingress_private
      host = ibm_resource_instance.logs_instance.extensions.external_ingress
      port = 443
    }
  }
  targets {
    log_sink_crn = module.log_analysis.crn
    name = "my-log-analysis-target"
    parameters {
      host = "logs.private.${var.region}.logging.cloud.ibm.com"
      port = 443
      access_credential = module.log_analysis.ingestion_key
    }
  }
}
