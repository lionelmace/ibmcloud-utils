# network.tf
#
#IBM Cloud Provider for Terraform™ VERSION: v0.14.0
#
#ibm_security_group_rule Argument Reference
#The following arguments are supported:
#
#direction - (Required, string) The direction of traffic. Accepted values: ingress or egress.
#ether_type - (Optional, string) The IP version. Accepted values (case sensitive): IPv4 or IPv6. Default value: ‘IPv4’.
#port_range_min - (Optional, int) The start of the port range for allowed traffic.
#port_range_max - (Optional, int) The end of the port range for allowed traffic.
#protocol - (Optional, string) The IP protocol type. Accepted values (case sensitive): icmp,tcp, or udp.
#remote_group_id - (Optional, int) The ID of the remote security group allowed as part of the rule.
#
#NOTE: Conflicts with remote_ip.
#
#remote_ip - (Optional, string) The CIDR or IP address for allowed connections.
#
#NOTE: Conflicts with remote_group_id.
#
#security_group_id - (Required, int) The ID of the security group this rule belongs to.
#########################################################
# This example creates the security groups used by the vsis. The Public security group rules
# allow internet access for download of source packages
#########################################################

#########################################################
# Create Public Security Group
#########################################################

resource "ibm_security_group" "sg_public_maximo" {
  name        = "sg_public_maximo"
  description = "Public access rule for maximo vsi"
}

#########################################################
# Create policies for security group
# 1. allow tcp on 443 for HTTPS access egress
# 2. allow tcp on 80 for HTTP access egress
#########################################################

resource "ibm_security_group_rule" "https-pub" {
  direction         = "egress"
  ether_type        = "IPv4"
  port_range_min    = 443
  port_range_max    = 443
  protocol          = "tcp"
  security_group_id = ibm_security_group.sg_public_maximo.id
}

resource "ibm_security_group_rule" "http-pub" {
  direction         = "egress"
  ether_type        = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  security_group_id = ibm_security_group.sg_public_maximo.id
}

#public SSH for demo access, please remove
resource "ibm_security_group_rule" "ssh_pub" {
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  security_group_id = ibm_security_group.sg_public_maximo.id
}

#########################################################
# Create Private Security Group
#########################################################

resource "ibm_security_group" "sg_private_maximo" {
  name        = "sg_private_maximo"
  description = "Private rules for maximo vsi´s"
}

resource "ibm_security_group" "sg_private_db" {
  name        = "sg_private_db"
  description = "Private rules for db vsi´s"
}

######################################################################################
# Create policies for private security groups
# source/destination ip set to generic 10.0.0.0/8, as deployment subnet not known
# at time SG examples is created. Similarly IPs for subnet in target data center = Osl01.
######################################################################################

# Management if linux

resource "ibm_security_group_rule" "ssh" {
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip         = "10.0.0.0/8" #replace for 0sl01 subnet CIDR or ip
  security_group_id = ibm_security_group.sg_private_maximo.id
}

resource "ibm_security_group_rule" "ssh_db" {
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 22
  port_range_max    = 22
  protocol          = "tcp"
  remote_ip         = "10.0.0.0/8" #replace for 0sl01 subnet CIDR or ip
  security_group_id = ibm_security_group.sg_private_db.id
}

# Management if windows

resource "ibm_security_group_rule" "rdp" {
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 3389
  port_range_max    = 3389
  protocol          = "tcp"
  remote_ip         = "10.0.0.0/8" #replace for 0sl01 subnet CIDR or ip
  security_group_id = ibm_security_group.sg_private_maximo.id
}

resource "ibm_security_group_rule" "rdp_db" {
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 3389
  port_range_max    = 3389
  protocol          = "tcp"
  remote_ip         = "10.0.0.0/8" #replace for 0sl01 subnet CIDR or ip
  security_group_id = ibm_security_group.sg_private_db.id
}

resource "ibm_security_group_rule" "http-in" {
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 80
  port_range_max    = 80
  protocol          = "tcp"
  remote_ip         = "10.0.0.0/8" #replace for 0sl01 subnet CIDR or ip
  security_group_id = ibm_security_group.sg_private_maximo.id
}

# Example for mysgl, create rules for DB, Maximo +++++
resource "ibm_security_group_rule" "mysql-in" {
  direction         = "ingress"
  ether_type        = "IPv4"
  port_range_min    = 3306
  port_range_max    = 3306
  protocol          = "tcp"
  remote_ip         = "10.0.0.0/8" #replace for 0sl01 subnet CIDR or ip
  security_group_id = ibm_security_group.sg_private_db.id
}

resource "ibm_security_group_rule" "mysql-out" {
  direction         = "egress"
  ether_type        = "IPv4"
  port_range_min    = 3306
  port_range_max    = 3306
  protocol          = "tcp"
  remote_ip         = "10.0.0.0/8" #replace for 0sl01 subnet CIDR or ip
  security_group_id = ibm_security_group.sg_private_db.id
}

#icmp_type specified via port_range_min
#icmp_code specified via port_range_max
resource "ibm_security_group_rule" "icmp_db" {
  direction         = "ingress"
  ether_type        = "IPv4"
  protocol          = "icmp"
  port_range_min    = 8
  port_range_max    = 0
  remote_ip         = "10.0.0.0/8"
  security_group_id = ibm_security_group.sg_private_db.id
}

resource "ibm_security_group_rule" "icmp" {
  direction         = "ingress"
  ether_type        = "IPv4"
  protocol          = "icmp"
  port_range_min    = 8
  port_range_max    = 0
  remote_ip         = "10.0.0.0/8"
  security_group_id = ibm_security_group.sg_private_maximo.id
}

# Allow access to IBM DNS name servers
resource "ibm_security_group_rule" "dns" {
  direction         = "egress"
  ether_type        = "IPv4"
  port_range_min    = 53
  port_range_max    = 53
  protocol          = "udp"
  remote_ip         = "10.0.0.0/8"
  security_group_id = ibm_security_group.sg_private_maximo.id
}

resource "ibm_security_group_rule" "dns_db" {
  direction         = "egress"
  ether_type        = "IPv4"
  port_range_min    = 53
  port_range_max    = 53
  protocol          = "udp"
  remote_ip         = "10.0.0.0/8"
  security_group_id = ibm_security_group.sg_private_db.id
}
