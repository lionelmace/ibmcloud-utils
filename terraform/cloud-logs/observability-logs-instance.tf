
##############################################################################
# Cloud Logs Services
##############################################################################


# Cloud Logs Instance
##############################################################################

resource "ibm_resource_instance" "logs_instance" {
  resource_group_id = local.resource_group_id
  name              = format("%s-%s", local.basename, "cloud-logs")
  service           = "logs"
  plan              = "standard"
  location          = var.region
  tags              = var.tags
  service_endpoints = "private"

  parameters = {
    logs_bucket_crn = ibm_cos_bucket.logs-bucket-data.crn
    logs_bucket_endpoint = ibm_cos_bucket.logs-bucket-data.s3_endpoint_direct
    metrics_bucket_crn = ibm_cos_bucket.logs-bucket-metrics.crn
    metrics_bucket_endpoint = ibm_cos_bucket.logs-bucket-metrics.s3_endpoint_direct
    retention_period = 7
  }
  depends_on = [ibm_iam_authorization_policy.cloud-logs-cos]
}

# Cloud Logs Routing
##############################################################################
resource "ibm_logs_router_tenant" "logs_router_tenant_instance" {
  name = format("%s-%s", local.basename, "cloud-logs-router")
  targets {
    log_sink_crn = ibm_resource_instance.logs_instance.id
    name = "my-cloud-logs-target"
    parameters {
      host = ibm_resource_instance.logs_instance.extensions.external_ingress_private
      port = 443
    }
  }
  # targets {
  #   log_sink_crn = module.log_analysis.crn
  #   name = "my-log-analysis-target"
  #   parameters {
  #     host = "www.example-1.com"
  #     port = 80
  #     access_credential = "new-cred"
  #   }
  # }
}

output "logs-endpoint" {
  description = "The Cloud Logs Extension"
  value       = ibm_resource_instance.logs_instance.extensions.external_ingress_private
}

