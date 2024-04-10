
resource "ibm_sm_secret_group" "secret_group" {
  instance_id = local.secrets_manager_guid
  name        = "${local.basename}-vpn-group"
  region      = var.region
  description = "Created by terraform as part of the client VPN example."
}

resource "ibm_sm_imported_certificate" "server_cert" {
  instance_id     = local.secrets_manager_guid
  name            = "${local.basename}-server-cert"
  description     = "Server certificate created by terraform as part of the client VPN example."
  secret_group_id = ibm_sm_secret_group.secret_group.secret_group_id
  certificate     = module.pki.certificates["server"].cert.cert_pem
  private_key     = module.pki.certificates["server"].private_key.private_key_pem
  intermediate    = module.pki.ca.cert.cert_pem
}

resource "ibm_sm_imported_certificate" "client_cert" {
  instance_id     = local.secrets_manager_guid
  name            = "${local.basename}-client-cert"
  description     = "Client certificate created by terraform as part of the client VPN example."
  secret_group_id = ibm_sm_secret_group.secret_group.secret_group_id
  certificate     = module.pki.certificates["client"].cert.cert_pem
  intermediate    = module.pki.ca.cert.cert_pem
}

resource "ibm_iam_authorization_policy" "secret_group_to_vpn" {
  subject_attributes {
    name  = "accountId"
    value = local.account_id
  }

  subject_attributes {
    name  = "serviceName"
    value = "is"
  }

  subject_attributes {
    name  = "resourceType"
    value = "vpn-server"
  }

  roles = ["SecretsReader"]

  resource_attributes {
    name  = "accountId"
    value = local.account_id
  }

  resource_attributes {
    name  = "serviceName"
    value = "secrets-manager"
  }

  resource_attributes {
    name  = "resourceType"
    value = "secret-group"
  }

  resource_attributes {
    name  = "resource"
    value = ibm_sm_secret_group.secret_group.secret_group_id
  }
}

output "server_cert_crn" {
  value = ibm_sm_imported_certificate.server_cert.crn
}

output "client_cert_crn" {
  value = ibm_sm_imported_certificate.client_cert.crn
}

output "client_cert" {
  value     = module.pki.certificates["client"].cert.cert_pem
  sensitive = true
}

output "client_key" {
  value     = module.pki.certificates["client"].private_key.private_key_pem
  sensitive = true
}

