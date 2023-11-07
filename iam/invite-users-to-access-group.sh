#!/bin/sh

## Access Group Name
AG="workshop"

for email in $EMAIL

do
  ibmcloud iam access-group-user-add $AG $email
done
