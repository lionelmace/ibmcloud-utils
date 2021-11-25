#!/bin/bash
echo "Please choose a target:"
select target in "Prod EU" "Prod US" "Prod AU" "Stage1 EU" "Stage1 US" "CIO DYS0 Dedicated" "CIO W3IBM Dedicated" "Exit"; do
  case $target in
  "Prod US" )
    export BMX_TARGET=ng
    break;;
  "Prod EU" )
    export BMX_TARGET=eu-gb
    break;;
  "Prod AU" )
    export BMX_TARGET=au-syd
    break;;
  "Stage1 US" )
    export BMX_TARGET=stage1.ng
    break;;
  "Stage1 EU" )
    export BMX_TARGET=stage1.eu-gb
    break;;
  "CIO DYS0 Dedicated" )
    export BMX_TARGET=dys0
    break;;
  "CIO W3IBM Dedicated" )
    export BMX_TARGET=w3ibm
    break;;
  "Exit" )
    exit;;
  esac
done

export CF_API=https://api.$BMX_TARGET.bluemix.net
export CF_HOME="$HOME/.cf-bmx/$BMX_TARGET"

# if cf_home does not exist do a login
if [ ! -d $CF_HOME ]; then
  mkdir -p "$CF_HOME"
  cf login -a $CF_API
else
  cf target
fi

rm -f $HOME/.cf
ln -s $CF_HOME/.cf $HOME/.cf
# ls -la $HOME/.cf
