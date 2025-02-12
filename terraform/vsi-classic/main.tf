#Example Terraform script to create 2 servers, resource grups and resource group rules.

resource "ibm_compute_vm_instance" "dbsrv01" {
  hostname          = "dbsrv01"
  domain            = "test.local"
  network_speed     = 10
  hourly_billing    = true
  datacenter        = "osl01"
  cores             = 1
  memory            = 1024
  local_disk        = false
  os_reference_code = "UBUNTU_16_64"
  disks             = [25]

  #  public_vlan_id  = 2434079   #ic sl vlan list -d osl01
  private_vlan_id = 2434081   #ic sl vlan list -d osl01
  ssh_key_ids     = [1153343] #ic sl security sshkey-list

  private_security_group_ids = ["${ibm_security_group.sg_private_db.id}"]

  #public_security_group_ids  = [""]        #For VSI with public access
  private_network_only = true #Change if private network only
  tags                 = ["group:database"]
  wait_time_minutes    = 30
}

resource "ibm_compute_vm_instance" "maximo01" {
  hostname          = "maximo01"
  domain            = "test.local"
  network_speed     = 10
  hourly_billing    = true
  datacenter        = "osl01"
  cores             = 1
  memory            = 1024
  local_disk        = false
  os_reference_code = "UBUNTU_16_64"
  disks             = [25]

  public_vlan_id  = 2434079   #ic sl vlan list -d osl01
  private_vlan_id = 2434081   #ic sl vlan list -d osl01
  ssh_key_ids     = [1153343] #ic sl security sshkey-list

  private_security_group_ids = ["${ibm_security_group.sg_private_maximo.id}"]
  public_security_group_ids  = ["${ibm_security_group.sg_public_maximo.id}"] #For VSI with public access
  private_network_only       = false                                         #Change if private network only
  tags                       = ["group:maximo"]
  wait_time_minutes          = 30
}

