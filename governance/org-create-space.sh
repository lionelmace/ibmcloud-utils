#!/bin/sh
##listofusers = firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com


# lentini@fr.ibm.com, courtinb@fr.ibm.com, cmanghini@fr.ibm.com, wachs@fr.ibm.com, schimowski@fr.ibm.com, zoric@fr.ibm.com, decroos@fr.ibm.com, genard@fr.ibm.com, theuwiss@fr.ibm.com, mermet@fr.ibm.com, berthajm@fr.ibm.com, drascek@fr.ibm.com, peluttiero@fr.ibm.com, sauvanet@fr.ibm.com, gaultier@fr.ibm.com, rubiram@fr.ibm.com, casile@fr.ibm.com, o_vanbaelinghem@fr.ibm.com, favre@fr.ibm.com, ransanp@fr.ibm.com, droinpy@fr.ibm.com, vaniets@fr.ibm.com, outters@fr.ibm.com
# fx.drouet@fr.ibm.com, gaetan.podda@fr.ibm.com, isabelle.drid@fr.ibm.com, sylvain.desnoes@fr.ibm.com, stephane.valette@fr.ibm.com, ludovic.hazard@fr.ibm.com, lionel.balmain@fr.ibm.com

# Formation interne Kubernetes
for i in firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com
do
	echo $i
	# Create Policy
	ibmcloud account space-create NOM-DE-FAMILLE

done
