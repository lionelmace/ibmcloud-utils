resource "ibm_iam_user_invite" "invite_user" {
  users         = ["first.lastname@company.fr"]
  access_groups = [ibm_iam_access_group.accgrp.id]
}