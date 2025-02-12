##############################################################################
# IBM Cloud Provider
##############################################################################

terraform {
  required_version = ">=1.6"
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "1.71.1"
    }
    logdna = {
      source  = "logdna/logdna"
      version = ">= 1.16.0"
    }
    http-full = {
      source  = "salrashid123/http-full"
      version = "1.3.1"
    }
  }
}

provider "http-full" {}

provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  region           = var.region
}

provider "helm" {
  kubernetes {
    host                   = data.ibm_container_cluster_config.roks_cluster_config.host
    token                  = data.ibm_container_cluster_config.roks_cluster_config.token
    cluster_ca_certificate = data.ibm_container_cluster_config.roks_cluster_config.ca_certificate
  }
  # IBM Cloud credentials are required to authenticate to the helm repo
  registry {
    url      = "oci://icr.io/ibm/observe/logs-agent-helm"
    username = "iamapikey"
    password = var.ibmcloud_api_key # replace with an IBM cloud apikey
  }
}

# Init cluster config for helm
# ############################################################################
data "ibm_container_cluster_config" "roks_cluster_config" {
  # update this value with the cluster ID where these agents will be provisioned
  cluster_name_id   = ibm_container_vpc_cluster.roks_cluster.id
  resource_group_id = local.resource_group_id
}