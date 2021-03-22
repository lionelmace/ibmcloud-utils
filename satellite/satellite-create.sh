#!/bin/bash

source satellite.env

ibmcloud target -g $RESOURCE_GROUP_NAME

# Create a new Satellite location
printf "\n## Creating new Satellite location \"$SAT_LOCATION_NAME\".\n"
ibmcloud sat location create --name $SAT_LOCATION_NAME \
                             --managed-from $SAT_MANAGED_FROM \
                             --ha-zone zone-1 --ha-zone zone-2 --ha-zone zone-3

# Retrieve the id of the newly created Satellite location
export SAT_LOCATION_ID=$(ibmcloud sat location get --location $SAT_LOCATION_NAME --json | jq ".id")

# Get the registration script to attach hosts to the Satellite location.
printf "\n## Retrieving the registration script.\n"
assign_host_script=$(ibmcloud sat host attach --location $SAT_LOCATION_NAME | grep register-host)
echo $assign_host_script

# Update the Assign Host script to refresh the Red Hat packages on those hosts.
printf "\n## Updating the Register host script.\n"
sed -i "" -e $'18 a\
subscription-manager refresh\\\n' $assign_host_script
sed -i "" -e $'19 a\
subscription-manager repos --enable=*\\\n' $assign_host_script

# Create VSIs for Control Plane
createHostsForControlPlane(){
  printf "\n############# VSI sat-$SAT_LOCATION_NAME-cp$i ##############\n"
  ibmcloud is instance-create sat-$SAT_LOCATION_NAME-cp$i \
                              $VPC_ID $VPC_ZONE $VSI_PROFILE \
                              $VPC_SUBNET_ID \
                              --image-id $VSI_IMAGE_ID \
                              --user-data @$assign_host_script
}

# Create VSIs for Worker Node
createHostsForWorkerNode(){
  printf "\n############# VSI sat-$SAT_LOCATION_NAME-wn$i ##############\n"
  ibmcloud is instance-create sat-$SAT_LOCATION_NAME-wn$i \
                              $VPC_ID $VPC_ZONE $VSI_PROFILE \
                              $VPC_SUBNET_ID \
                              --image-id $VSI_IMAGE_ID \
                              --user-data @$assign_host_script
}

# Assign hosts to the location
assignControlPlaneToLocation(){
  printf "\n############# Assign sat-$SAT_LOCATION_NAME-cp$i ##############\n"
    ibmcloud sat host assign --location $SAT_LOCATION_NAME \
                             --host sat-$SAT_LOCATION_NAME-cp$i \
                             --zone zone-$i
}

for i in $(seq -w $COUNT_START $COUNT_END)
do
  createHostsForControlPlane
  createHostsForWorkerNode
done

# Location creation takes few minutes and hosts to be visible in this location
cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep $SAT_LOCATION_NAME-cp | wc -l)
while [ $cp_count -lt $COUNT_END ]
do
  echo "Waiting 30 secs for $COUNT_END control plane hosts to be attached..."
  echo "Number of cp hosts currently attached : $cp_count"
  cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep $SAT_LOCATION_NAME-cp | wc -l)
  sleep 30
done

for i in $(seq -w $COUNT_START $COUNT_END)
do
   assignControlPlaneToLocation
done

printf "\n## ----------------------------------------------------\n"
