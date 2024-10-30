
# Activity Tracker Event Routing
##############################################################################
resource "ibm_atracker_route" "atracker_route" {
  name = format("%s-%s", local.basename, "at-route")
  rules {
    target_ids = [ibm_atracker_target.atracker_cloudlogs_target.id]
    locations  = [var.region, "global"]
  }
  lifecycle {
    # Recommended to ensure that if a target ID is removed here and destroyed in a plan, this is updated first
    create_before_destroy = true
  }
  depends_on = [ibm_iam_authorization_policy.iam-auth-atracker-2-logs]
}

resource "ibm_atracker_target" "atracker_cloudlogs_target" {
  cloudlogs_endpoint {
    target_crn = ibm_resource_instance.logs_instance.id
  }
  name        = format("%s-%s", local.basename, "cloudlogs-target")
  target_type = "cloud_logs"
  region      = var.region
}
