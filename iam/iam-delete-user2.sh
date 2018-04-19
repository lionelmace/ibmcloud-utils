#!/bin/sh
##listofusers = firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com

for i in firstname.lastname@fr.ibm.com xx.xxx@gmail.com xx.xxx@gmail.com
do
	echo $i
	# Alain's Account ID: b6236659cd0c6579ac89c8f2c59d945d
	bx account user-delete $i -c b6236659cd0c6579ac89c8f2c59d945d -f
done
