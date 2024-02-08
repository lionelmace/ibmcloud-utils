
module "pki" {
  source  = "particuleio/pki/tls"
  version = "2.0.0"

  ca = {
    algorithm   = "RSA"
    ecdsa_curve = "secp384r1"
    subject = {
      common_name         = "${local.basename} CA"
      organization        = "Org"
      organizational_unit = "OU"
      street_address = [
        "Street"
      ]
      locality      = "Locality"
      province      = "Province"
      country       = "Country"
      postal_code   = "Postal Code"
      serial_number = "Serial Number"
    }
    validity_period_hours = 87600
    early_renewal_hours   = 78840
    allowed_uses = [
      "cert_signing",
      "crl_signing",
      "code_signing",
      "server_auth",
      "client_auth",
      "digital_signature",
      "key_encipherment",
    ]
  }

  certificates = {
    server = {
      algorithm   = "RSA"
      ecdsa_curve = "secp384r1"
      subject = {
        common_name         = "${local.basename} Server"
        organization        = "Org"
        organizational_unit = "OU"
        street_address = [
          "Street"
        ]
        locality      = "Locality"
        province      = "Province"
        country       = "Country"
        postal_code   = "Postal Code"
        serial_number = "Serial Number"
      }
      validity_period_hours = 8740
      early_renewal_hours   = 8040
      dns_names = [
        "vpn-server.vpn.ibm.com"
      ]
      uris = []
      allowed_uses = [
        "server_auth",
        "client_auth",
        "digital_signature",
      ]
    }

    client = {
      algorithm   = "RSA"
      ecdsa_curve = "secp384r1"
      subject = {
        common_name         = "${local.basename} Client"
        organization        = "Org"
        organizational_unit = "OU"
        street_address = [
          "Street"
        ]
        locality      = "Locality"
        province      = "Province"
        country       = "Country"
        postal_code   = "Postal Code"
        serial_number = "Serial Number"
      }
      validity_period_hours = 8740
      early_renewal_hours   = 8040
      dns_names = [
        "vpn-client.vpn.ibm.com"
      ]
      uris = []
      allowed_uses = [
        "server_auth",
        "client_auth",
        "digital_signature",
      ]
    }
  }
}

