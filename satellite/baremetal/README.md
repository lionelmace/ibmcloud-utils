
ic is images | grep ibm-redhat-8-8 | grep -v "deprecated"

r010-857d6027-1add-4350-baac-e44ca9921ec8   ibm-redhat-8-8-minimal-amd64-2

ibmcloud is bare-metal-server-create \
--name bm-fra-3 \
--pnic-subnet eu-de-subnet-2 \
--zone eu-de-2 \
--profile bx2-metal-96x384 \
--image r010-857d6027-1add-4350-baac-e44ca9921ec8 \
--keys r010-c2c6f4a2-dd52-4697-97b2-19b8173734e2,r010-7bfe0de2-4bad-4934-a557-81513de8ed26