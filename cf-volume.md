## container Service Volume


1. Get detailed about container volument

  ```
  cf ic volume fs-inspect fc023c57-02ee-4ea8-bd06-ab473d7e42a6
  ```

  Below are the results:

  ```
  {
    "fs": {
        "capacity": 20,
        "created_date": "2017-01-20 17:57:34",
        "fsName": "fc023c57-02ee-4ea8-bd06-ab473d7e42a6",
        "hostPath": "/vol/fc023c57-02ee-4ea8-bd06-ab473d7e42a6",
        "iops": 4,
        "iopsTotal": 80,
        "orderId": 18882471,
        "provider": "ENDURANCE",
        "spaceGuid": "fc023c57-02ee-4ea8-bd06-ab473d7e42a6",
        "state": "READY",
        "updated_date": "2017-01-20 18:01:36"
    },
    "fsUsage": {
        "Error": "Filesystem /vol/fc023c57-02ee-4ea8-bd06-ab473d7e42a6 not found"
    },
    "volnames": [
        "jenkins"
    ]
  }
  ```
