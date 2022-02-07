##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.0"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.38.1"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
  ibmcloud_timeout = 60
}

##############################################################################