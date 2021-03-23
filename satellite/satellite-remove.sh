#!/bin/bash

source satellite.env

ibmcloud target -g $RG_NAME

# Create VSIs for Control Plane
deleteHostsForControlPlane(){
  printf "\n############# VSI sat-$SAT_LOCATION_NAME-cp$i ##############\n"
  ibmcloud is instance-delete --force $(ibmcloud is instances | grep sat-$SAT_LOCATION_NAME-cp$i  | awk '{print $1}') 
}

# Create VSIs for Worker Node
deleteHostsForWorkerNode(){
  printf "\n############# VSI sat-$SAT_LOCATION_NAME-wn$i ##############\n"
  ibmcloud is instance-delete --force $(ibmcloud is instances | grep sat-$SAT_LOCATION_NAME-wn$i  | awk '{print $1}')
}

# Assign hosts to the location
detachControlPlaneFromLocation(){
  printf "\n############# Detach Controlplane host sat-$SAT_LOCATION_NAME-cp$i ##############\n"
    ibmcloud sat host rm -f --location $SAT_LOCATION_NAME \
                        --host sat-$SAT_LOCATION_NAME-cp$i
}

detachWokerNodeFromLocation(){
  printf "\n############# Detach Worker host sat-$SAT_LOCATION_NAME-cp$i ##############\n"
    ibmcloud sat host rm -f --location $SAT_LOCATION_NAME \
                        --host sat-$SAT_LOCATION_NAME-wn$i
}

for i in $(seq -w $COUNT_START $COUNT_END)
do
  detachControlPlaneFromLocation
  detachWokerNodeFromLocation
done

# # Location creation takes few minutes and hosts to be visible in this location
cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep "assigned" | wc -l)
while [ $cp_count -gt 0 ]
do
  echo "Waiting for $COUNT_END control plane hosts to be dettached"
  echo "Number of cp hosts currently attached : $cp_count"
  cp_count=$(ibmcloud sat host ls --location $SAT_LOCATION_NAME | grep "assigned" | wc -l)
  sleep 30
done

# Delete Satellite location
printf "\n## Delete new Satellite location \"$SAT_LOCATION_NAME\".\n"
ibmcloud sat location rm -f --location $SAT_LOCATION_NAME

loc_count=$(ibmcloud sat location ls | grep $SAT_LOCATION_NAME-cp | wc -l)
while [ $cp_count -gt 0 ]
do
  echo "Waiting for $COUNT_END control plane hosts to be attached"
  echo "Number of cp hosts currently attached : $cp_count"
  loc_count=$(ibmcloud sat location ls | grep $SAT_LOCATION_NAME-cp | wc -l)
  sleep 30
done

for i in $(seq -w $COUNT_START $COUNT_END)
do
  echo "Deleting cp and wn $i"
  deleteHostsForControlPlane
  deleteHostsForWorkerNode
done



printf "\n## ----------------------------------------------------\n"
