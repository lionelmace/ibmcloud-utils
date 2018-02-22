List local images
```docker image ls```

Create a new image based on Debian with Node.js runtime and our sample app
```docker build -t hellonode:1.0 -f hellonode.dockerfile .```

List local docker images
```docker images```

Point to Frankfurt Region
```bx api https://api.eu-de.bluemix.net```

Login into Bluemix
```bx login``` (or bx login -sso if your Bluemix user is federated with W3)

Login into Bluemix Container Repository
```bx cr login```

Check Bluemix Container Repository
```bx cr info```

List existing images
```bx cr images```

Tag local image to Bluemix Container Repository naming (update with your namespace and nginx version)
```docker tag hellonode:1.0 registry.eu-de.bluemix.net/chemi/hellonode:1.0```

Publish local image into Bluemix Container Repository (update with your namespace and nginx version)
```docker push registry.eu-de.bluemix.net/chemi/hellonode:1.0```

List existing images
```bx cr images```

Initialice Bluemix Container Service CLI
```bx cs init```

List existing Kubernetes clusters
```bx cs clusters```

Get mycluster config (update with your cluster name)
```bx cs cluster-config mycluster```

Export the config (update with your file)
```export KUBECONFIG=/home/osboxes/.bluemix/plugins/container-service/clusters/mycluster/kube-config-par01-mycluster.yml```

Get existing workers
```kubectl get nodes```

Check workers hw specs
```kubectl describe nodes```

Get existing pods
```kubectl get pods```

Deploy NGinx deployment file
```kubectl create -f hellonode-deployment.yml```

Get existing deployments
```kubectl get deployments```

Create the accessible service via NodePort (update the file with your external IP from existing node)
```kubectl create -f hellonode-service.yml```

Get existing services
```kubectl get services```

Check logs from your app (update with your pod name)
```kubectl logs -f hellonode-deployment-21317431-rxdt6```

Check pods status and verify how pod is restarted
```kubectl get pods```

Edit hellonode-deployment.yml file and change replicas from 1 to 3
Update deployment specs
```kubectl apply -f hellonode-deployment.yml```

Check pods status and show now there are three
```kubectl get pods```