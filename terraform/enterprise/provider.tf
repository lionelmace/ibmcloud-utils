##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.5"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.64.1"
    }
  }
}

provider "ibm" {
  alias = "child"
  # how do I get the API Key after account creation?
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "ibm" {
  alias            = "enterprise"
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}
##############################################################################