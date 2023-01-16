##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.1"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.49.0"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

##############################################################################