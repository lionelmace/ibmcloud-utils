
# where to create resource
resource "ibm_resource_group" "rg" {
  name = "${local.basename}-group"
  tags = var.tags
}

# a vpc
resource "ibm_is_vpc" "vpc" {
  name                      = "${local.basename}-vpc"
  resource_group            = ibm_resource_group.rg.id
  address_prefix_management = "manual"
  tags                      = var.tags
}

# its address prefix
resource "ibm_is_vpc_address_prefix" "subnet_prefix" {
  name = "${local.basename}-zone-1"
  zone = "${var.region}-1"
  vpc  = ibm_is_vpc.vpc.id
  cidr = "10.10.10.0/24"
}

# a subnet
resource "ibm_is_subnet" "subnet" {
  name            = "${local.basename}-subnet"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-1"
  resource_group  = ibm_resource_group.rg.id
  ipv4_cidr_block = ibm_is_vpc_address_prefix.subnet_prefix.cidr
  tags            = var.tags
}

resource "ibm_is_public_gateway" "pgw" {
  name           = "${local.basename}-pgw"
  vpc            = ibm_is_vpc.vpc.id
  zone           = "${var.region}-1"
  resource_group = ibm_resource_group.rg.id
  tags           = var.tags
}

data "ibm_is_image" "image" {
  name = var.image_name
}

resource "tls_private_key" "rsa_4096_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_key" {
  content         = tls_private_key.rsa_4096_key.private_key_pem
  filename        = "rsakey.pem"
  file_permission = "0600"
}

# Generate an SSH Key
resource "ibm_is_ssh_key" "generated_ssh_key" {
  name           = "${local.basename}-ssh-key"
  resource_group = ibm_resource_group.rg.id
  public_key     = tls_private_key.rsa_4096_key.public_key_openssh
}

# Create a VSI (Virtual Server Instance)
resource "ibm_is_instance" "vsi" {
  name           = "${local.basename}-vsi"
  vpc            = ibm_is_vpc.vpc.id
  zone           = ibm_is_subnet.subnet.zone
  profile        = var.profile_name
  image          = data.ibm_is_image.image.id
  keys           = [ibm_is_ssh_key.generated_ssh_key.id]
  resource_group = ibm_resource_group.rg.id
  tags           = var.tags

  primary_network_interface {
    subnet = ibm_is_subnet.subnet.id
  }

  boot_volume {
    name = "${local.basename}-boot"
  }
}

# A Public Floating IP for the VSI
resource "ibm_is_floating_ip" "public_ip" {
  count = tobool(var.create_public_ip) ? 1 : 0

  name   = "${local.basename}-floating-ip"
  target = ibm_is_instance.vsi.primary_network_interface[0].id
  tags   = var.tags
}

# Enable SSH Inbound Rule
resource "ibm_is_security_group_rule" "sg-rule-inbound-ssh" {
  group     = ibm_is_vpc.vpc.default_security_group
  direction = "inbound"
  remote    = "0.0.0.0/0"

  tcp {
    port_min = 22
    port_max = 22
  }
}
