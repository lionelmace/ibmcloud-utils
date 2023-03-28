

Test the connection to the 
docker login registry.redhat.io

oc create secret docker-registry threescale-registry-auth \
  --docker-server=registry.redhat.io \
  --docker-username="" \
  --docker-password="XXXX" \
  --docker-email=""