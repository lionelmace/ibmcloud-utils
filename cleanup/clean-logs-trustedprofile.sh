#!/bin/bash

# Remove the Trusted Profiles for Logs Agent and Workload Protection

source ../local.env

count=0

for i in `ibmcloud iam tps | grep logs-agent | awk '{ print $1}' `
do
  # Delete Trusted Profile
  ibmcloud iam tp-delete $i -f
  count=count+1
  
done

echo $countwp 'logs trusted profiles deleted'

for wp in `ibmcloud iam tps | grep workload-protection | awk '{ print $1}' `
do
  # Delete Trusted Profile for Workload Protection
  ibmcloud iam tp-delete $wp -f
  countwp=countwp+1
  
done

echo $countwp 'workload protection trusted profiles deleted'
