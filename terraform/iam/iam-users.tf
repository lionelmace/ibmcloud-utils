
# invite the users in the account and attach them to their access group
resource "ibm_iam_user_invite" "invite_user" {
  users         = ["first.last@gmail.com"]
  access_groups = [ibm_iam_access_group.ag-vmware-lab.id]
}


# Update the policies of existing users
# Assign Access Group to an existing user
resource "ibm_iam_access_group_members" "assign-vmware-ag-to-user" {
  access_group_id = ibm_iam_access_group.ag-vmware-lab.id
  ibm_ids         = ["first.last@gmail.com"]
}

resource "ibm_iam_user_invite" "assign-existing-user-to-classic-infra" {
  users = ["first.last@gmail.com"]
  classic_infra_roles {
    # permission_set = "superuser"
    permission_set = "noacess"
  }
}

# Not supported by Terraform yet
# resource "ibm_iam_user_policy" "policy" {
#   ibm_ids = ["lionel.mace@gmail.com"]
#   classic_infra_roles {
#     # permission_set = "superuser"
#     permission_set = "noacess"
#   } 
# }