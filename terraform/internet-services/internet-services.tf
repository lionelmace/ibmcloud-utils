
data "ibm_cis" "cis_instance" {
  name = "cis-lionelmace"
}

data "ibm_cis_domain" "cis_instance_domain" {
  domain = "lionelmace.com"
  cis_id = data.ibm_cis.cis_instance.id
}

# resource "ibm_cis_certificate_order" "test" {
#     cis_id    = data.ibm_cis.cis_instance.id
#     domain_id = data.ibm_cis_domain.cis_instance_domain.domain_id
#     hosts     = ["test.lionelmace.com"]
#     # certificate_authority    = "lets_encrypt"
# }

output "cis_instance_name" {
  value = data.ibm_cis.cis_instance.name
}

output "cis_instance_status" {
  value = data.ibm_cis_domain.cis_instance_domain.status
}

## Workaround to order advanced certificate by API
##############################################################################
data "ibm_iam_auth_token" "tokendata" {}

data "http" "cis_certificate_order" {
  provider = http-full

  url    = "https://api.cis.cloud.ibm.com/v2/${data.ibm_cis.cis_instance.id}/zones/${data.ibm_cis_domain.cis_instance_domain.domain_id}/ssl/certificate_packs/order"
  method = "POST"

  request_headers = {
    x-auth-user-token = data.ibm_iam_auth_token.tokendata.iam_access_token
    content-type      = "application/json"
    accept            = "application/json"
  }

  request_body = jsonencode(
    {
        type = "advanced"
        hosts = ["test.lionelmace.com"]
        validation_method = "txt"
        validity_days = 90
        certificate_authority = "lets_encrypt"
    }
  )
}