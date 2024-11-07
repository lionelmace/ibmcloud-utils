## SCC Instance
##############################################################################
resource "ibm_resource_instance" "scc_instance" {
  name              = format("%s-%s", local.basename, "scc")
  service           = "compliance"
  plan              = "security-compliance-center-standard-plan"
  location          = var.region
  resource_group_id = local.resource_group_id
}

resource "ibm_scc_instance_settings" "scc_instance_settings" {
  instance_id = ibm_resource_instance.scc_instance.guid
  event_notifications {
    instance_crn = ibm_resource_instance.event-notifications.crn
  }
  object_storage {
    instance_crn = ibm_resource_instance.cos-scc.crn
    bucket       = ibm_cos_bucket.scc-bucket.bucket_name
  }
}
