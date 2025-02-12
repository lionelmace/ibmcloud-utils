##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.4"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.58.1"
    }
    http-full = {
      source = "salrashid123/http-full"
    }
  }
}

provider "http-full" {}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

##############################################################################