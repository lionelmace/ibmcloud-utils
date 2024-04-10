variable "vpn_client_ip_pool" {
  type        = string
  description = "The VPN client IPv4 address pool, expressed in CIDR format. The request must not overlap with any existing address prefixes in the VPC or any of the following reserved address ranges: - 127.0.0.0/8 (IPv4 loopback addresses) - 161.26.0.0/16 (IBM services) - 166.8.0.0/14 (Cloud Service Endpoints) - 169.254.0.0/16 (IPv4 link-local addresses) - 224.0.0.0/4 (IPv4 multicast addresses). The prefix length of the client IP address pool's CIDR must be between /9 (8,388,608 addresses) and /22 (1024 addresses). A CIDR block that contains twice the number of IP addresses that are required to enable the maximum number of concurrent connections is recommended."
  default     = "10.0.0.0/20"
}

  # Use those IPs to access service endpoints and IaaS endpoints from your client
  # client_dns_server_ips  = ["161.26.0.10", "161.26.0.11"]
  # Use those IPs if you need to resolve private DNS names from your client.
  # Requires to be able to open OpenShift Console.
variable "client_dns_server_ips" {
  type        = list(string)
  description = "DNS server addresses that will be provided to VPN clients connected to this VPN server"
  default     = ["161.26.0.7", "161.26.0.8"]
}

resource "ibm_is_vpn_server" "vpn" {
  certificate_crn = ibm_sm_imported_certificate.server_cert.crn
  client_authentication {
    method        = "certificate"
    client_ca_crn = ibm_sm_imported_certificate.client_cert.crn
  }
  client_ip_pool         = var.vpn_client_ip_pool
  client_dns_server_ips  = var.client_dns_server_ips
  client_idle_timeout    = 2800
  enable_split_tunneling = true
  name                   = "${local.basename}-vpn-server"
  port                   = 443
  protocol               = "udp"
  subnets = [
    ibm_is_subnet.subnet[0].id, ibm_is_subnet.subnet[1].id
    # ibm_is_subnet.subnet.id
  ]
  security_groups = [
    ibm_is_vpc.vpc.default_security_group,
    ibm_is_security_group.vpn.id
  ]
  resource_group = local.resource_group_id
}

resource "ibm_is_security_group" "vpn" {
  resource_group = local.resource_group_id
  name           = "${local.basename}-vpn-group"
  vpc            = ibm_is_vpc.vpc.id
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

# allow clients to ping
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
  # remote    = "166.9.0.0/16"
  remote = "166.8.0.0/14"
}

resource "ibm_is_vpn_server_route" "route_cse_to_vpc" {
  vpn_server = ibm_is_vpn_server.vpn.id
  action     = "deliver"
  # destination = "166.9.0.0/16"
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

# Add outbound rules for each subnet (NEW)
resource "ibm_is_security_group_rule" "vpn_outbound_subnet" {
  count     = length(var.subnet_cidr_blocks)
  group     = ibm_is_security_group.vpn.id
  direction = "outbound"
  remote    = element(var.subnet_cidr_blocks, count.index)
}

# When you specify the DNS server "client_dns_server_ips" in the VPN, 
# you must also create a VPN route after the VPN server is provisioned, 
# with destination 161.26.0.0/16 and the translate action.
resource "ibm_is_vpn_server_route" "route_private_to_vpc" {
  vpn_server  = ibm_is_vpn_server.vpn.id
  action      = "translate"
  destination = "161.26.0.0/16"
  name        = "route-private-2-ibm-iaas-endpoints"
  depends_on  = [ibm_iam_authorization_policy.secret_group_to_vpn]
}

# Route to Subnets - NATing
# Ok in both translate and deliver
resource "ibm_is_vpn_server_route" "route_to_subnet" {
  count       = length(var.subnet_cidr_blocks)
  vpn_server  = ibm_is_vpn_server.vpn.id
  action      = "translate"
  destination = element(var.subnet_cidr_blocks, count.index)
  name        = "route-2-subnet-${count.index + 1}"
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
