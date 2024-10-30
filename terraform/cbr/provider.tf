terraform {
  required_version = ">=1.4"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.70.1"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.4"
    }
  }
}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}
