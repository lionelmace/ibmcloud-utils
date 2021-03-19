#!/bin/bash

source satellite.env

ibmcloud target -g $RESOURCE_GROUP_NAME

# Delete a new Satellite location
printf "\n## Deleting the Satellite location \"$SAT_LOCATION_NAME\".\n"
# ibmcloud sat location rm --location $SAT_LOCATION_NAME -f

deleteHosts_CP(){
  printf "\n## Deleting the VSI instance sat-$SAT_LOCATION_NAME-cp$i...\n"
  # Retrieve instance id
  export VSI_INSTANCE_ID=$(ibmcloud is instances | grep sat-$SAT_LOCATION_NAME-cp$i | awk '{ print $1 }')
  ibmcloud is instance-delete $VSI_INSTANCE_ID -f
}

deleteHosts_WN(){
  printf "\n## Deleting the VSI instance sat-$SAT_LOCATION_NAME-cp$i...\n"
  # Retrieve instance id
  export VSI_INSTANCE_ID=$(ibmcloud is instances | grep sat-$SAT_LOCATION_NAME-wn$i | awk '{ print $1 }')
  ibmcloud is instance-delete $VSI_INSTANCE_ID -f
}

for i in $(seq -w $COUNT_START $COUNT_END)
do
  deleteHosts_CP
  deleteHosts_WN
done

printf "\n## ----------------------------------------------------\n"
