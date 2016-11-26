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

## Resources

- [Cloud Foundry API](https://apidocs.cloudfoundry.org/235/#)