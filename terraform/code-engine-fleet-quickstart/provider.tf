########################################################################################################################
# Provider config
########################################################################################################################

provider "ibm" {
  ibmcloud_api_key      = var.ibmcloud_api_key
  region                = var.region
  # visibility            = var.provider_visibility
  # private_endpoint_type = (var.provider_visibility == "private" && var.region == "ca-mon") ? "vpe" : null
}