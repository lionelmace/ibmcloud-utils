provider "ibm" {
  ibmcloud_api_key = var.ibmcloud_api_key
  generation       = 2
  region           = "us-south"
}

#This file will create a VPC, 2 Subnets, 3 Security Groups and Rules, 2 VSIs, and a Gateway
#This file creates a VPC identical to the VPC we created in the VPC Product Tour

#Create a VPC 
resource "ibm_is_vpc" "vpc1" {
  name = "vpcdte"
}

#Eric let's create default subnet with VPC
resource "ibm_is_subnet" "subnet1" {
  name            = "vpc-pubpriv-backend-subnet"
  vpc             = ibm_is_vpc.vpc1.id
  zone            = var.zone1
  ipv4_cidr_block = "10.240.0.0/24"
}

#Eric let's create 2nd Subnet for Bastion VSI
resource "ibm_is_subnet" "bastion-subnet" {
  name            = "vpc-secure-bastion-subnet"
  vpc             = ibm_is_vpc.vpc1.id
  zone            = var.zone1
  ipv4_cidr_block = "10.240.1.0/24"
  public_gateway  = ibm_is_public_gateway.dte_gateway.id
}

#Eric let's create Public Gateway
resource "ibm_is_public_gateway" "dte_gateway" {
  name = "dte_gateway"
  vpc  = ibm_is_vpc.vpc1.id
  zone = var.zone1
}

#Eric let's create Security Group
resource "ibm_is_security_group" "vpc-secure-bastion-sg" {
  name = "vpc-secure-bastion-sg"
  vpc  = ibm_is_vpc.vpc1.id
}

#Eric let's create 2 Inbound Security Group Rules
resource "ibm_is_security_group_rule" "bastion_security_group_rule_tcp" {
  group     = ibm_is_security_group.vpc-secure-bastion-sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 22
    port_max = 22
  }
}

resource "ibm_is_security_group_rule" "bastion_security_group_rule_icmp" {
  group     = ibm_is_security_group.vpc-secure-bastion-sg.id
  direction = "inbound"
  remote    = "0.0.0.0/0"
  icmp {
    type = 8
  }
}

#Terraform does not generate SSH keys but it will upload an SSH key to IBM Cloud
resource "ibm_is_ssh_key" "sshkey" {
  name       = "linuxsshkey"
  public_key = file(var.ssh_public_key)
  #above line reads from variables.tf file to get the path and filename
}

#Eric Create Bastion Jumphost Virtual Server
resource "ibm_is_instance" "bastion" {
  name    = "vpc-secure-bastion-vsi"
  image   = var.image   #the VSI image such as Centos7
  profile = var.profile #the VSI hardware such as RAM and CPU

  primary_network_interface {
    subnet          = ibm_is_subnet.bastion-subnet.id
    security_groups = [ibm_is_security_group.vpc-secure-bastion-sg.id]
  }

  vpc  = ibm_is_vpc.vpc1.id
  zone = var.zone1
  keys = [ibm_is_ssh_key.sshkey.id]
}

#let's create Maintenance Security Group
resource "ibm_is_security_group" "vpc-secure-maintenance-sg" {
  name = "vpc-secure-maintenance-sg"
  vpc  = ibm_is_vpc.vpc1.id
}

#let's create 4 Outbound Security Group Rules and 1 Inbound
#Rule 1
resource "ibm_is_security_group_rule" "sm_security_group_rule_tcp1" {
  group     = ibm_is_security_group.vpc-secure-maintenance-sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 80
    port_max = 80
  }
}

#Rule 2
resource "ibm_is_security_group_rule" "sm_security_group_rule_tcp_2" {
  group     = ibm_is_security_group.vpc-secure-maintenance-sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 443
    port_max = 443
  }
}

#Rule 3
resource "ibm_is_security_group_rule" "sm_security_group_rule_tcp3" {
  group     = ibm_is_security_group.vpc-secure-maintenance-sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  tcp {
    port_min = 53
    port_max = 53
  }
}

#Rule 4
resource "ibm_is_security_group_rule" "sm_security_group_rule_udp" {
  group     = ibm_is_security_group.vpc-secure-maintenance-sg.id
  direction = "outbound"
  remote    = "0.0.0.0/0"
  udp {
    port_min = 53
    port_max = 53
  }
}

#Rule 5 Inbound set to Security Group
resource "ibm_is_security_group_rule" "sm_security_group_rule_tcp4" {
  group     = ibm_is_security_group.vpc-secure-maintenance-sg.id
  direction = "inbound"
  remote    = ibm_is_security_group.vpc-secure-bastion-sg.id
  tcp {
    port_min = 22
    port_max = 22
  }
}

#let's create 1 Outbound Security Group Rule
resource "ibm_is_security_group_rule" "bastion_security_group_rule_tcp2" {
  group     = ibm_is_security_group.vpc-secure-bastion-sg.id
  direction = "outbound"
  remote    = ibm_is_security_group.vpc-secure-maintenance-sg.id
  tcp {
    port_min = 22
    port_max = 22
  }
}

#Eric let's create 3nd Subnet for Web Server VSI
resource "ibm_is_subnet" "vpc-secure-private-subnet" {
  name            = "vpc-secure-private-subnet"
  vpc             = ibm_is_vpc.vpc1.id
  zone            = var.zone1
  ipv4_cidr_block = "10.240.2.0/24"
  public_gateway  = ibm_is_public_gateway.dte_gateway.id
}

#Eric let's create Web Server Security Group
resource "ibm_is_security_group" "vpc-secure-private-sg" {
  name = "vpc-secure-private-sg"
  vpc  = ibm_is_vpc.vpc1.id
}

#Eric Create Web Server Virtual Server VSI
resource "ibm_is_instance" "vpc-secure-private-vsi" {
  name    = "vpc-secure-private-vsi"
  image   = var.image   #the VSI image such as Centos7
  profile = var.profile #the VSI hardware such as RAM and CPU

  primary_network_interface {
    subnet          = ibm_is_subnet.vpc-secure-private-subnet.id
    security_groups = [ibm_is_security_group.vpc-secure-private-sg.id, ibm_is_security_group.vpc-secure-maintenance-sg.id]
  }

  vpc  = ibm_is_vpc.vpc1.id
  zone = var.zone1
  keys = [ibm_is_ssh_key.sshkey.id]
}

