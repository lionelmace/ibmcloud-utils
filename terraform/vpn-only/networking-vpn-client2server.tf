
variable "vpn_client_ip_pool" {
  default = "192.168.0.0/16"
}

resource "ibm_is_vpn_server" "vpn" {
  certificate_crn = ibm_sm_imported_certificate.server_cert.crn
  client_authentication {
    method        = "certificate"
    client_ca_crn = ibm_sm_imported_certificate.client_cert.crn
  }
  client_ip_pool         = var.vpn_client_ip_pool
  client_idle_timeout    = 2800
  enable_split_tunneling = true
  name                   = "${local.basename}-vpn-server"
  port                   = 443
  protocol               = "udp"
  subnets = [
    data.ibm_is_vpc.vpc.subnets[0].id, data.ibm_is_vpc.vpc.subnets[1].id
  ]
  security_groups = [
    ibm_is_security_group.vpn.id
  ]
  resource_group = data.local.resource_group_id
}

resource "ibm_is_security_group" "vpn" {
  resource_group = data.local.resource_group_id
  name           = "${local.basename}-vpn-group"
  vpc            = data.ibm_is_vpc.vpc.id
}

resource "ibm_is_security_group_rule" "vpn_inbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "inbound"
  udp {
    port_min = 443
    port_max = 443
  }
}

# allow clients to use SSH to connect to hosts in the cloud
resource "ibm_is_security_group_rule" "vpn_ssh_outbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  tcp {
    port_min = 22
    port_max = 22
  }
}

# allow clients to use SSH to ping
resource "ibm_is_security_group_rule" "vpn_icmp_outbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  icmp {
    type = 8
    code = 0
  }
}

# allow clients to reach cloud service endpoints
resource "ibm_is_security_group_rule" "vpn_cse_outbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  remote    = "166.8.0.0/14"
}

resource "ibm_is_vpn_server_route" "route_cse_to_vpc" {
  vpn_server  = ibm_is_vpn_server.vpn.id
  action      = "deliver"
  destination = "166.8.0.0/14"
  name        = "route-2-ibm-cloud-service-endpoints"
  depends_on  = [ibm_iam_authorization_policy.secret_group_to_vpn]
}

# allow clients to reach private backend
resource "ibm_is_security_group_rule" "vpn_private_outbound" {
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  remote    = "161.26.0.0/16"
}

resource "ibm_is_vpn_server_route" "route_private_to_vpc" {
  vpn_server  = ibm_is_vpn_server.vpn.id
  action      = "deliver"
  destination = "161.26.0.0/16"
  name        = "route-private-2-ibm-iaas-endpoints"
  depends_on  = [ibm_iam_authorization_policy.secret_group_to_vpn]
}

data "ibm_is_vpn_server_client_configuration" "config" {
  vpn_server = ibm_is_vpn_server.vpn.id
}

output "full-ovpn-config" {
  value = <<EOT
${data.ibm_is_vpn_server_client_configuration.config.vpn_server_client_configuration}

<cert>
${nonsensitive(module.pki.certificates["client"].cert.cert_pem)}
</cert>

<key>
${nonsensitive(module.pki.certificates["client"].private_key.private_key_pem)}
</key>
EOT
}

output "vpn" {
  value = ibm_is_vpn_server.vpn
}
