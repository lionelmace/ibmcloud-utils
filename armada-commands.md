## List of common Armada commands

1. New sizes are coming per datacenter.

  You will need to use a flavor available in your datacenter for the --size parameter.

  ```
  $ bx cs datacenters
  Getting data center list...
  OK
  Data Center
  mex01


  $ bx cs flavors mex01
  Getting flavor list...
  OK
  Flavors
  large
  medium
  small
  xlarge
  xxlarge
  free
  ```


## Resources

- [Creating an Armada Cluster in Stage](https://github.ibm.com/alchemy-containers/armada/blob/master/create-cluster-dev.md)
