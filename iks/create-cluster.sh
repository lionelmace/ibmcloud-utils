#!/bin/sh

## Create N clusters

for i in {1..16}

do
  ibmcloud ks cluster-create \
      --name lab-cluster-${i} \
      --kube-version 1.13.6  \
      --zone fra02 \
      --workers 2 \
      --machine-type u2c.2x4 \
      --hardware shared \
      --public-vlan 2438031 \
      --private-vlan 2438033
  
  # for i in {31..50}
  # ibmcloud ks cluster-create \
  #     --name lab-cluster-${i} \
  #     --kube-version 1.10.12  \
  #     --zone fra04 \
  #     --workers 2 \
  #     --machine-type u2c.2x4 \
  #     --hardware shared \
  #     --public-vlan 2361303 \
  #     --private-vlan 2361307
done