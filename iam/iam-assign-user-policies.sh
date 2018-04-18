#!/bin/sh
##listofusers = Remy.Choupin@fr.ibm.com p.gervais@fr.ibm.com gpiedeloup@fr.ibm.com mh_genieyz@fr.ibm.com stephane.wacongne@fr.ibm.com sebastien.pomme@fr.ibm.com a.thalamot@fr.ibm.com nicolas.vigogne@fr.ibm.com HGRANGE@fr.ibm.com olivier.planson@fr.ibm.com bertrand.denoix@fr.ibm.com ntissar.draoui@fr.ibm.com francois_ribal@fr.ibm.com ekaterina.vicaire@fr.ibm.com benoit.durand1@fr.ibm.com cyril.collin@fr.ibm.com SAUTEREY@fr.ibm.com haraulte@fr.ibm.com mrabemananjara@fr.ibm.com DROINPY@fr.ibm.com sebastien.brun@fr.ibm.com marc-etienne.julien@fr.ibm.com bblancard@fr.ibm.com ETROJMAN@fr.ibm.com ba.cherif@fr.ibm.com patrick.bonvoisin@fr.ibm.com bernard.romy@fr.ibm.com dan.goga1@fr.ibm.com mighri.marouane@fr.ibm.com fabien.grillon@fr.ibm.com gerard_mandon@fr.ibm.com philippe_nottelet@fr.ibm.com scabarrus@fr.ibm.com yao_assou@fr.ibm.com desire.brival1@fr.ibm.com philippe.marembert@fr.ibm.com alexis.artus@fr.ibm.com benjamin.cotin@fr.ibm.com lianchen@fr.ibm.com salonzo@fr.ibm.com matthias.benda@ibm.com fanta.kromah@fr.ibm.com

# Formation interne Kubernetes
for i in Remy.Choupin@fr.ibm.com p.gervais@fr.ibm.com gpiedeloup@fr.ibm.com mh_genieyz@fr.ibm.com stephane.wacongne@fr.ibm.com sebastien.pomme@fr.ibm.com a.thalamot@fr.ibm.com nicolas.vigogne@fr.ibm.com HGRANGE@fr.ibm.com olivier.planson@fr.ibm.com bertrand.denoix@fr.ibm.com ntissar.draoui@fr.ibm.com francois_ribal@fr.ibm.com ekaterina.vicaire@fr.ibm.com benoit.durand1@fr.ibm.com cyril.collin@fr.ibm.com SAUTEREY@fr.ibm.com haraulte@fr.ibm.com mrabemananjara@fr.ibm.com DROINPY@fr.ibm.com sebastien.brun@fr.ibm.com marc-etienne.julien@fr.ibm.com bblancard@fr.ibm.com ETROJMAN@fr.ibm.com ba.cherif@fr.ibm.com patrick.bonvoisin@fr.ibm.com bernard.romy@fr.ibm.com dan.goga1@fr.ibm.com mighri.marouane@fr.ibm.com fabien.grillon@fr.ibm.com gerard_mandon@fr.ibm.com philippe_nottelet@fr.ibm.com scabarrus@fr.ibm.com yao_assou@fr.ibm.com desire.brival1@fr.ibm.com philippe.marembert@fr.ibm.com alexis.artus@fr.ibm.com benjamin.cotin@fr.ibm.com lianchen@fr.ibm.com salonzo@fr.ibm.com matthias.benda@ibm.com fanta.kromah@fr.ibm.com
do
	echo $i
	# Create Policy
	bx iam user-policy-create $i --roles Administrator --service-name containers-kubernetes
	bx iam user-policy-create $i --roles Administrator --service-name monitoring
	bx iam user-policy-create $i --roles Administrator --service-name ibmcloud-log-analysis 

done
