# Connect to IBM Cloud
ibmcloud login --sso
 
# Show plugin and update
ibmcloud plugin repo-plugins
#ibmcloud install infrastructure-service
ibmcloud plugin update
 
# Connect to IaaS
ibmcloud sl init -c 1433073
ibmcloud sl init -c 1439823
ibmcloud sl vs list
 
# Show commands
ibmcloud is help
 
# Create VPC
ibmcloud is vpcs
ibmcloud is vpc-create vpc-sey
ibmcloud is vpcs
$vpc="9ffa38c7-c59c-4a38-94bb-615b35f58012"
 
# Show regions and zones
ibmcloud is regions
ibmcloud is zones us-south
ibmcloud is zone us-south us-south-2
 
# Create subnets
ibmcloud is subnet-create Z2-S1-P $vpc us-south-2 --ipv4_cidr_block 10.1.1.0/24
ibmcloud is subnet-create Z2-S2-A $vpc us-south-2 --ipv4_cidr_block 10.1.2.0/24
ibmcloud is subnet-create Z2-S3-D $vpc us-south-2 --ipv4_cidr_block 10.1.3.0/24
ibmcloud is subnets
ibmcloud is subnets --vpc $vpc
$p="487df7a9-38aa-45c1-b301-a415b3c59402"
$a="6c7dc57c-15a9-46f8-8364-a28956c321e6"
$d="0c8a095c-9c40-4622-91fa-0449e03d0c79"
 
# Create public gateway
ibmcloud is public-gateway-create Gateway-Z2-S2-A $vpc us-south-2
ibmcloud is pubgws
$gateway="7749299f-7503-4fe7-a177-6fbbef95b9a6"
ibmcloud is subnet-update $a --gw $gateway
ibmcloud is subnets
 
# Add key
ibmcloud is key-create --name Eychenne-Steven-IBM --key "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEAht/ujDr180
ejC3uItul59tX6MvlIPvbYqHm9BvhmSDBTK6X0ZGfEBWVq7lRMmHbdj6sluRl09YjmrqqOo5em73wn46OGSWivuDilAKO5MBsgNEtdavaDNAhUZj7MVgpRm6
ATV4HAIDYzk8AIaVUvddDZGIIkVbWL1dXMQ1w2CzoHHlmDIsnwhqxga4xg2yrTCUwgRB6fBTw8T9w8YGH8xNp2V1lVpgph54WHKfgeilPIScxsjLX/6J3qiU
SmicyQY2mmBF7lFYzz1gVxXEeZWYZusydXO1HThA/sMS3+hlVvm60euo2bDDVPtRfwYJuUJFI0zCR4eORYF6i0+pvPzQ==" --rg 1
ibmcloud is keys
$key="8cda4a00-946c-47ad-8044-bbc3bb09fbd1"
 
# Show images & profiles
ibmcloud is images
$image="cc8debe0-1b30-6e37-2e13-744bfb2a0c11"
ibmcloud is instance-profiles
$profile="c-1x1"
 
# Create VMs
ibmcloud is instance-create P1 $vpc us-south-2 $profile $p 1000 --image $image --keys $key
ibmcloud is instance-create A1 $vpc us-south-2 $profile $a 1000 --image $image --keys $key
ibmcloud is instance-create D1 $vpc us-south-2 $profile $d 1000 --image $image --keys $key
ibmcloud is instances
 
#Create floating IP
ibmcloud is instance 66f31a3d-09d1-44a9-b7fe-e6b716737273
$nic="53f8d4e4-5531-4cf5-8388-157ce65ffac6"
ibmcloud is floating-ip-reserve VIP-P1 --nic $nic