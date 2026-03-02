provider "ibm" {
  region           = var.region
  ibmcloud_api_key = var.ibmcloud_api_key
}

data "ibm_iam_auth_token" "auth_token" {}

provider "restapi" {
  uri = "https://resource-controller.cloud.ibm.com" # See https://cloud.ibm.com/apidocs/resource-controller/resource-controller#endpoint-url for all possible endpoints
  headers = {
    Authorization = data.ibm_iam_auth_token.auth_token.iam_access_token
  }
  write_returns_object = true
}

provider "sysdig" {
  sysdig_secure_team_name = "Secure Operations"
  sysdig_secure_url       = "https://${var.region}.monitoring.cloud.ibm.com"
  ibm_secure_iam_url      = "https://iam.cloud.ibm.com"
  ibm_secure_instance_id  = module.scc_wp.guid
  ibm_secure_api_key      = var.ibmcloud_api_key
}