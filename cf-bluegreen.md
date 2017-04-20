## Blue-Green deployment

  ```bash
  # Blue-Green Deployment
  # ---------------------
  MANIFEST=manifest.yml

  echo "Using manifest file: $MANIFEST"

  if ! cf app $CF_APP; then
    cf push $CF_APP -n $CF_APP -f $MANIFEST
  else
    OLD_CF_APP=${CF_APP}-OLD-$(date +"%s")
    rollback() {
      set +e
      if cf app $OLD_CF_APP; then
        cf logs $CF_APP --recent
        cf delete $CF_APP -f
        cf rename $OLD_CF_APP $CF_APP
      fi
      exit 1
    }
    set -e
    trap rollback ERR
    cf rename $CF_APP $OLD_CF_APP
    cf push $CF_APP -n $CF_APP -f $MANIFEST
    cf delete $OLD_CF_APP -f
  fi
  ```
