#!/bin/bash -xu

if [ $# -ne 2 ];
then
        echo "syntax: $0 <openstack-model> <artifacts>"
        exit 1
fi

export OPENSTACK_MODEL=$1
export MODEL_NAME=$(echo $OPENSTACK_MODEL | cut -f 2 -d :)
export NEW_CLOUD=${MODEL_NAME}-openstack
export NEW_CONTROLLER=$NEW_CLOUD-RegionOne
ARTIFACTS_FOLDER=$2

mkdir -p $ARTIFACTS_FOLDER

error() {
  local parent_lineno="$1"
  local message="$2"
  local code="${3:-1}"
  if [[ -n "$message" ]] ; then
    echo "Error on or near line ${parent_lineno}: ${message}; waiting for debug"
  else
    echo "Error on or near line ${parent_lineno}; waiting for debug"
  fi
  sleep 1d
  exit "${code}"
}
trap 'error ${LINENO}' ERR

. novarc

./setup-quotas
./bootstrap-juju2
./test-ubuntu-deploy
juju destroy-controller ${NEW_CONTROLLER} --destroy-all-models --yes

cat <<EOF > $ARTIFACTS_FOLDER/juju_bootstrap_xunit.xml
<testsuite errors="0" failures="0" name="" tests="1">
<testcase classname="TestJujuBootstrap" name="Test Juju Bootstrap">
</testsuite>
EOF
