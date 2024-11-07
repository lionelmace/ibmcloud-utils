# IAM S2S Service to Service Authorization
##############################################################################

# S2S Authorization from Cloud Logs to COS
resource "ibm_iam_authorization_policy" "cloud-logs-cos" {
  source_service_name = "logs"
  # source_resource_instance_id = ibm_resource_instance.logs_instance.guid
  target_service_name         = "cloud-object-storage"
  target_resource_instance_id = ibm_resource_instance.cos-for-logs.guid
  roles                       = ["Writer"]
}

# S2S Authorization from Logs Router to Cloud Logs
resource "ibm_iam_authorization_policy" "cloud-logs-router" {
  source_service_name         = "logs-router"
  target_service_name         = "logs"
  target_resource_instance_id = ibm_resource_instance.logs_instance.guid
  roles                       = ["Sender"]
}

##############################################################################
resource "ibm_iam_authorization_policy" "iam-auth-kms-cos-for-logs" {
  source_service_name         = "cloud-object-storage"
  source_resource_instance_id = ibm_resource_instance.cos-for-logs.guid
  target_service_name         = "kms"
  target_resource_instance_id = ibm_resource_instance.key-protect.guid
  roles                       = ["Reader"]
}

##############################################################################
resource "ibm_iam_authorization_policy" "iam-auth-atracker-2-logs" {
  source_service_name         = "atracker"
  target_service_name         = "logs"
  target_resource_instance_id = ibm_resource_instance.logs_instance.guid
  roles                       = ["Sender"]
}