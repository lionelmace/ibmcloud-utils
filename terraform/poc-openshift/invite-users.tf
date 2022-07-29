resource "ibm_iam_user_invite" "invite_user" {
  users         = ["aurelien.gravier@phenisys.com","frederic.barlet@eovi-mcd.fr","jean.blanc@phenisys.com","julien.egron@phenisys.com"]
  access_groups = [ibm_iam_access_group.accgrp.id]
}