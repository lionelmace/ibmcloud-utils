##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.13"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.87.3"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

##############################################################################