##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.5"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.60.0"
    }
  }
}

provider "ibm" {
  alias            = "child"
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "ibm" {
  alias            = "enterprise"
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}
##############################################################################