3 steps to migrate from Cloud Foundry DEA to DIEGO

## Migration Steps

1. Install the plugin from the CF Community repository

  ```
  $ cf add-plugin-repo CF-Community https://plugins.cloudfoundry.org/
  $ cf install-plugin Diego-Enabler -r CF-Community
  ```

1. Migrate an app to Diego

  ```
  $ cf enable-diego <app_name>
  ```
  or 
  ```sh
  $ cf push app <app_name> —no-start
  $ cf enable-diego <app_name>
  $ cf start <app_name>
  ```

1. SSH into an application container instance

  ```
  cf ssh <app_name>
  ```
  

## Resources

- [A CF CLI plugin to help you migrate apps from the DEA to Diego runtime](https://github.com/cloudfoundry-incubator/Diego-Enabler)
- [Migrating to Diego](https://github.com/cloudfoundry/diego-design-notes/blob/master/migrating-to-diego.md)
- [Diego Migration](https://github.ibm.com/Bluemix-Ops/diego-migration/wiki)
