#!/bin/sh
##listofusers = firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com


# courtinb@fr.ibm.com, cmanghini@fr.ibm.com, wachs@fr.ibm.com, schimowski@fr.ibm.com, zoric@fr.ibm.com, decroos@fr.ibm.com, genard@fr.ibm.com, theuwiss@fr.ibm.com, mermet@fr.ibm.com, berthajm@fr.ibm.com, drascek@fr.ibm.com, peluttiero@fr.ibm.com, sauvanet@fr.ibm.com, gaultier@fr.ibm.com, rubiram@fr.ibm.com, casile@fr.ibm.com, o_vanbaelinghem@fr.ibm.com, favre@fr.ibm.com, ransanp@fr.ibm.com, droinpy@fr.ibm.com, vaniets@fr.ibm.com, outters@fr.ibm.com
# fx.drouet@fr.ibm.com, gaetan.podda@fr.ibm.com, isabelle.drid@fr.ibm.com, sylvain.desnoes@fr.ibm.com, stephane.valette@fr.ibm.com, ludovic.hazard@fr.ibm.com, lionel.balmain@fr.ibm.com

# Formation interne Kubernetes
#for email in cmanghini@fr.ibm.com wachs@fr.ibm.com schimowski@fr.ibm.com zoric@fr.ibm.com decroos@fr.ibm.com genard@fr.ibm.com theuwiss@fr.ibm.com mermet@fr.ibm.com berthajm@fr.ibm.com drascek@fr.ibm.com peluttiero@fr.ibm.com sauvanet@fr.ibm.com gaultier@fr.ibm.com rubiram@fr.ibm.com casile@fr.ibm.com o_vanbaelinghem@fr.ibm.com favre@fr.ibm.com ransanp@fr.ibm.com droinpy@fr.ibm.com vaniets@fr.ibm.com outters@fr.ibm.com fx.drouet@fr.ibm.com gaetan.podda@fr.ibm.com isabelle.drid@fr.ibm.com sylvain.desnoes@fr.ibm.com stephane.valette@fr.ibm.com ludovic.hazard@fr.ibm.com lionel.balmain@fr.ibm.com
# for email in franck_descollonges@fr.ibm.com lentini@fr.ibm.com courtinb@fr.ibm.com 
#for email in slebrun@fr.ibm.com
#for email in bidard@fr.ibm.com
#for email in gpiedeloup@fr.ibm.com
for email in courtinb@fr.ibm.com

do
	## Extract last name from email
	lastname=$(echo $email | awk -F'@' '{print $1}' | sed 's?.*\.??g' | sed 's?.*\_??g' )

	## Create a Cloud Foundry space with the last name
	echo $lastname
	#ibmcloud account space-create $lastname

	## Invite user and assign role developer to this space
	#ibmcloud account user-invite $email -o cloud-europe -s $lastname --space-role SpaceDeveloper

    ## Assign Policy
	ibmcloud iam user-policy-create $email --roles Administrator --service-name containers-kubernetes
	ibmcloud iam user-policy-create $email --roles Administrator --service-name monitoring
	ibmcloud iam user-policy-create $email --roles Administrator --service-name ibmcloud-log-analysis 

done
