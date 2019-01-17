#!/bin/sh

## Create N clusters

for i in {1..3}

do
  ibmcloud ks cluster-create \
      --name academy-cluster-${i} \
      --kube-version 1.12.3  \
      --location fra02 \
      --workers 2 \
      --machine-type u2c.2x4 \
      --hardware shared \
      --public-vlan 2438031 \
      --private-vlan 2438033
done