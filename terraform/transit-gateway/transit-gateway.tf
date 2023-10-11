
resource "ibm_tg_gateway" "my_tgw"{
  name="transit-gateway-1"
  location="eu-de"
  global=false
  resource_group = ibm_resource_group.group.id
}  

resource "ibm_tg_connection" "test_ibm_tg_connection" {
  gateway      = ibm_tg_gateway.my_tgw.id
  network_type = "vpc"
  name         = "myconnection"
  network_id   = ibm_is_vpc.vpc.crn
}

resource "ibm_tg_connection" "test_ibm_tg_connection2" {
  gateway      = ibm_tg_gateway.my_tgw.id
  network_type = "vpc"
  name         = "myconnection2"
  network_id   = ibm_is_vpc.vpc2.crn
}

## Workaround to tag transit gateway
## To be removed once TGW supports tagging via Terraform
## RFE: https://github.com/IBM-Cloud/terraform-provider-ibm/issues/4856
##############################################################################
data "ibm_iam_auth_token" "tokendata" {}

data "http" "tag_resource" {
  provider = http-full

  url    = "https://tags.global-search-tagging.cloud.ibm.com/v3/tags/attach?tag_type=user"
  method = "POST"

  request_headers = {
    authorization = data.ibm_iam_auth_token.tokendata.iam_access_token
    content-type  = "application/json"
    accept        = "application/json"
  }

  request_body = jsonencode(
    { 
      resources = [{ resource_id = "${ibm_tg_gateway.my_tgw.crn}" }]
      tag_names = ["tf", "tag_2"]
    }
  )
}