#!/bin/sh
# Uncommment to verbose
# set -x 

export RG_NAME="mytodo"

echo "Enter the Resource Group name: "
read rg_name

ibmcloud target -g $rg_name

# List all resource reclamations under account 0b5a00334eaf9eb9339d2ab48f7326b4 as lionel.mace@fr.ibm.com...
# OK

# ID                                     Resource Instance ID                   Entity CRN                                                                                                             State            Target Time
# 283fc4d2-55ab-4476-baaf-db977fb9d1c3   2f64e0a8-7711-4f5a-9705-5ae4f5f26e7b   crn:v1:bluemix:public:sysdig-monitor:eu-de:a/0b5a00334eaf9eb9339d2ab48f7326b4:2f64e0a8-7711-4f5a-9705-5ae4f5f26e7b::   RECLAIM_FAILED   2022-02-10T09:43:41Z
# 29264108-474f-4699-ac01-792f85d1f022   2db25486-5f4f-45c3-920e-3025ab8a3422   crn:v1:bluemix:public:sysdig-monitor:eu-de:a/0b5a00334eaf9eb9339d2ab48f7326b4:2db25486-5f4f-45c3-920e-3025ab8a3422::   RECLAIM_FAILED   2022-02-08T17:24:53Z
# 21efc4ae-334f-40e4-960f-7f791bef1d0c   b506d098-45ec-422d-b5c3-48eb76e96c41   crn:v1:bluemix:public:sysdig-monitor:eu-de:a/0b5a00334eaf9eb9339d2ab48f7326b4:b506d098-45ec-422d-b5c3-48eb76e96c41::   RECLAIM_FAILED   2022-02-09T15:59:39Z

# Start reading at 4th line to extract the first string of each line
for rr in $(ibmcloud resource reclamations | awk '(NR>4) {print $1}')
do
  #echo $rr
  ibmcloud resource reclamation-delete $rr -f
done