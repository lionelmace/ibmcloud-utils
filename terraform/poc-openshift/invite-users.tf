resource "ibm_iam_user_invite" "invite_user" {
  users         = ["first.lastname@ibm.com"]
  access_groups = [ibm_iam_access_group.accgrp.id]
}