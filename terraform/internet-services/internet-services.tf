
data "ibm_cis" "cis_instance" {
  name = "cis-lionelmace"
}

data "ibm_cis_domain" "cis_instance_domain" {
  domain = "lionelmace.com"
  cis_id = data.ibm_cis.cis_instance.id
}

resource "ibm_cis_certificate_order" "test" {
    cis_id    = data.ibm_cis.cis_instance.id
    domain_id = data.ibm_cis_domain.cis_instance_domain.domain_id
    hosts     = ["test.lionelmace.com"]
    # certificate_authority = "lets_encrypt"
}

output "cis_instance_name" {
  value = data.ibm_cis.cis_instance.name
}

output "cis_instance_status" {
  value = data.ibm_cis_domain.cis_instance_domain.status
}
