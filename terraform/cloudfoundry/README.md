
Terraform sample to deploy a Cloud Foundry app either using Terraform or Schematics on IBM Cloud.

1. Run `terraform apply`
2. Fill out the values: application hostname, API Key, CF Org, CF Dev

The CF app being deployed was downloaded as a zip from this repo https://github.com/IBM-Cloud/get-started-node

To make sure CF was able to deploy it, it was unzipped and zipped again without a root folder. See below.

```
~/get-started-node-master  $  zip ../get.zip *
  adding: Dockerfile (deflated 22%)
  adding: LICENSE (deflated 65%)
  adding: README-kubernetes.md (deflated 59%)
  adding: README.md (deflated 55%)
  adding: README_MONGO.md (deflated 52%)
  adding: kubernetes/ (stored 0%)
  adding: manifest.yml (deflated 4%)
  adding: package-lock.json (deflated 73%)
  adding: package.json (deflated 47%)
  adding: server.js (deflated 66%)
  adding: vcap-local.MongoDBexample.json (deflated 38%)
  adding: vcap-local.example.json (deflated 38%)
  adding: views/ (stored 0%)

 ~/get-started-node-master  $  unzip -l ../get
Archive:  ../get.zip
  Length      Date    Time    Name
---------  ---------- -----   ----
      197  09-23-2019 09:54   Dockerfile
    11323  09-23-2019 09:54   LICENSE
     3064  09-23-2019 09:54   README-kubernetes.md
     2637  09-23-2019 09:54   README.md
     2192  09-23-2019 09:54   README_MONGO.md
        0  09-23-2019 09:54   kubernetes/
       80  09-23-2019 09:54   manifest.yml
    39184  09-23-2019 09:54   package-lock.json
      617  09-23-2019 09:54   package.json
     5360  09-23-2019 09:54   server.js
      189  09-23-2019 09:54   vcap-local.MongoDBexample.json
      182  09-23-2019 09:54   vcap-local.example.json
        0  09-23-2019 09:54   views/
---------                     -------
    65025                     13 files
```