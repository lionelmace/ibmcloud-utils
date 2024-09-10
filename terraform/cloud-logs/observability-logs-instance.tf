
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

output "logs-endpoint" {
  description = "The Cloud Logs Extension"
  value       = ibm_resource_instance.logs_instance.extensions
}

# Cloud Logs Routing
##############################################################################
resource "ibm_logs_router_tenant" "logs_router_tenant_instance" {
  name = format("%s-%s", local.basename, "cloud-logs-router")
  targets {
    log_sink_crn = ibm_resource_instance.logs_instance.id
    name = "my-cloud-logs-target"
    parameters {
      # Private Endpoint is not supported yet.
      # host = ibm_resource_instance.logs_instance.extensions.external_ingress_private
      # port = 443
      host = ibm_resource_instance.logs_instance.extensions.external_ingress
      port = 80
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

# Activity tracker event routing
##############################################################################
resource "ibm_atracker_route" "atracker_route" {
  name = format("%s-%s", local.basename, "at-route")
  rules {
    target_ids = [ ibm_atracker_target.atracker_cloudlogs_target.id ]
    locations = [ var.region, "global" ]
  }
  lifecycle {
    # Recommended to ensure that if a target ID is removed here and destroyed in a plan, this is updated first
    create_before_destroy = true
  }
}

resource "ibm_atracker_target" "atracker_cloudlogs_target" {
  cloudlogs_endpoint {
    target_crn = ibm_resource_instance.logs_instance.id
  }
  name = format("%s-%s", local.basename, "cloudlogs-target")
  target_type = "cloud_logs"
  region = var.region
}
