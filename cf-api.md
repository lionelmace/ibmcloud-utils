To find out which version of Cloud Foundry is deployed on IBM Cloud, got ot
[http://api.ng.bluemix.net/v2/info](http://api.ng.bluemix.net/v2/info)

This page should return something like this:
```json
{
"name": "Bluemix",
"build": "270019",
"support": "http://ibm.biz/bluemix-supportinfo",
"version": 0,
"description": "IBM Bluemix",
"authorization_endpoint": "https://login.ng.bluemix.net/UAALoginServerWAR",
"token_endpoint": "https://uaa.ng.bluemix.net",
"min_cli_version": null,
"min_recommended_cli_version": null,
"api_version": "2.92.0",
"app_ssh_endpoint": "ssh.ng.bluemix.net:2222",
"app_ssh_host_key_fingerprint": "c7:1f:89:2a:62:3b:78:a9:08:c9:33:81:fb:39:26:da",
"app_ssh_oauth_client": "ssh-proxy",
"doppler_logging_endpoint": "wss://doppler.ng.bluemix.net:443"
}
```
Based on the above you can go to the Cloud Foundry CF API and select both the CF Version (270 in this case) and the CF API Version (2.92.00).

The Cloud Foundry is available at [https://apidocs.cloudfoundry.org/270/](https://apidocs.cloudfoundry.org/270/)


## Leverage the cloud foundry api

1. Get the ID of your app

  The cf cli is going to the api - i.e. cloud controller - all the time.

  ```
  cf app <mycfapp> --guid
  ```

  Copy the guid: 5c33a489-9fcd-4961-b3bc-22957ea4be19

1. Get detailed stats for a STARTED App using CF API

  ```
  cf curl /v2/apps/<guid>/stats

  cf curl /v2/apps/5c33a489-9fcd-4961-b3bc-22957ea4be19/stats
  ```

  `cf curl` convenient because it injects your bearer token from the login automatically.

1. Below are the results:

  ```
  {
     "0": {
        "state": "RUNNING",
        "stats": {
           "name": "go",
           "uris": [
              "mycfapp.eu-gb.mybluemix.net"
           ],
           "host": "159.122.193.182",
           "port": 60792,
           "uptime": 241,
           "mem_quota": 134217728,
           "disk_quota": 1073741824,
           "fds_quota": 16384,
           "usage": {
              "time": "2016-11-25T09:00:55.401829563Z",
              "cpu": 0,
              "mem": 3530752,
              "disk": 8769536
           }
        }
     }
  }
  ```

## Get instance/memory usage per organization

1. Get the ID of your org

  ```
  cf org lionel.mace@fr.ibm.com --guid
  ```

1. Get the instance usage

  ```
  $ cf curl /v2/organizations/<org-guid>/instance_usage
  ```

  Output:
  {
     "instance_usage": 25
  }

2. Get the memory usage

  ```
  $ cf curl /v2/organizations/<org-guid>/memory_usage
  ```

  Output:
  {
     "memory_usage_in_mb": 11008
  }


## Resources

- [Cloud Foundry API](https://apidocs.cloudfoundry.org/270/#)
