#!/bin/sh
##listofusers = Remy.Choupin@fr.ibm.com p.gervais@fr.ibm.com gpiedeloup@fr.ibm.com mh_genieyz@fr.ibm.com stephane.wacongne@fr.ibm.com sebastien.pomme@fr.ibm.com a.thalamot@fr.ibm.com nicolas.vigogne@fr.ibm.com HGRANGE@fr.ibm.com olivier.planson@fr.ibm.com bertrand.denoix@fr.ibm.com ntissar.draoui@fr.ibm.com francois_ribal@fr.ibm.com ekaterina.vicaire@fr.ibm.com benoit.durand1@fr.ibm.com cyril.collin@fr.ibm.com SAUTEREY@fr.ibm.com haraulte@fr.ibm.com mrabemananjara@fr.ibm.com DROINPY@fr.ibm.com sebastien.brun@fr.ibm.com marc-etienne.julien@fr.ibm.com bblancard@fr.ibm.com ETROJMAN@fr.ibm.com ba.cherif@fr.ibm.com patrick.bonvoisin@fr.ibm.com bernard.romy@fr.ibm.com dan.goga1@fr.ibm.com mighri.marouane@fr.ibm.com fabien.grillon@fr.ibm.com gerard_mandon@fr.ibm.com philippe_nottelet@fr.ibm.com scabarrus@fr.ibm.com yao_assou@fr.ibm.com desire.brival1@fr.ibm.com philippe.marembert@fr.ibm.com alexis.artus@fr.ibm.com benjamin.cotin@fr.ibm.com lianchen@fr.ibm.com salonzo@fr.ibm.com matthias.benda@ibm.com fanta.kromah@fr.ibm.com

# Formation interne Kubernetes
# for i in Remy.Choupin@fr.ibm.com p.gervais@fr.ibm.com gpiedeloup@fr.ibm.com mh_genieyz@fr.ibm.com stephane.wacongne@fr.ibm.com sebastien.pomme@fr.ibm.com a.thalamot@fr.ibm.com nicolas.vigogne@fr.ibm.com HGRANGE@fr.ibm.com olivier.planson@fr.ibm.com bertrand.denoix@fr.ibm.com ntissar.draoui@fr.ibm.com francois_ribal@fr.ibm.com ekaterina.vicaire@fr.ibm.com benoit.durand1@fr.ibm.com cyril.collin@fr.ibm.com SAUTEREY@fr.ibm.com haraulte@fr.ibm.com mrabemananjara@fr.ibm.com DROINPY@fr.ibm.com sebastien.brun@fr.ibm.com marc-etienne.julien@fr.ibm.com bblancard@fr.ibm.com ETROJMAN@fr.ibm.com ba.cherif@fr.ibm.com patrick.bonvoisin@fr.ibm.com bernard.romy@fr.ibm.com dan.goga1@fr.ibm.com mighri.marouane@fr.ibm.com fabien.grillon@fr.ibm.com gerard_mandon@fr.ibm.com philippe_nottelet@fr.ibm.com scabarrus@fr.ibm.com yao_assou@fr.ibm.com desire.brival1@fr.ibm.com philippe.marembert@fr.ibm.com alexis.artus@fr.ibm.com benjamin.cotin@fr.ibm.com lianchen@fr.ibm.com salonzo@fr.ibm.com matthias.benda@ibm.com fanta.kromah@fr.ibm.com
# Members of European paid account
# for user in alain.mitry@fr.ibm.com ahaliulov@ru.ibm.com ALEJANDRO.DELGADO@ES.IBM.COM enqvist@se.ibm.com entgelme@de.ibm.com andy.legge@uk.ibm.com arto.ahde@fi.ibm.com david.dacosta@pt.ibm.com eric_cattoir@be.ibm.com ferdinando_gorga@it.ibm.com Florian.Georg@ch.ibm.com fco_ramos@es.ibm.com rueckziegel@de.ibm.com UEBELE@de.ibm.com	 henning.sternkicker@de.ibm.com	jtpollard@uk.ibm.com johan.rodin@se.ibm.com	jonm@uk.ibm.com	ordax@es.ibm.com ipsen@dk.ibm.com laszlo.boa@hu.ibm.com	marcdarcy@uk.ibm.com marc.loos@nl.ibm.com marco_dragoni@it.ibm.com martin.ryden@se.ibm.com weidauer@de.ibm.com matt.turnbull@uk.ibm.com	nigel.thorley@uk.ibm.com robert.quinn@se.ibm.com roberto_pozzi@it.ibm.com sarah_brader@uk.ibm.com thomas.seidel@de.ibm.com thomas.suedbroecker@de.ibm.com till.koellmann@de.ibm.com	vann.lam@fr.ibm.com	dymaczewski@pl.ibm.com	yves_debeer@be.ibm.com	zivd@il.ibm.com
for user in alain.mitry@fr.ibm.com
do
	echo $user
    # Retrieve policies assigned to the user
    #policies=$(bx iam user-policies $user)
    #policies="OK Policy ID: 1bc955f2-f9c1-49be-a7de-3eb0ddd9c52f Roles: Viewer Resources: Service Name Service Instance Region Resource Type resource-group Resource c9dcb01f2b4a4ba79aab7bad93e326c3 Roles: Administrator Resources: Service Name containers-kubernetes Service Instance Region Resource Type Resource"
    #echo $policies
    # Regular expression to extract policies
    #echo "Match"
    #re="ID: (.*)\sRoles"
    #re="(account)"
    #if [[ $policies =~ $re ]]; then echo ${BASH_REMATCH[1]}; fi
    #echo ${BASH_REMATCH[1]};
    #while read policies  # For as many lines as the input file has ...
    #do
    #    echo "$line"   # Output the line itself.
    #done
    #PY
    # if output : bx iam user-policies $user
    # OK Policy ID: 1bc955f2-f9c1-49be-a7de-3eb0ddd9c52f Roles: Viewer Resources: Service Name Service Instance Region Resource Type resource-group Resource c9dcb01f2b4a4ba79aab7bad93e326c3 Roles: Administrator Resources: Service Name containers-kubernetes Service Instance Region Resource Type Resource 
    # OK Policy ID: 1bc955f2-f9c1-49be-a7de-3eb0ddd9c53f Roles: Viewer Resources: Service Name
    for $i in $(bx iam user-policies $user| awk -v FS="ID:" '{print $2}' | awk '{print $1}')
    do
	# Delete Policy
	bx iam user-policy-delete $i containers-kubernetes -f
	bx iam user-policy-delete $i monitoring -f
	bx iam user-policy-delete $i ibmcloud-log-analysis -f
    done
done
