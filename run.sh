#!/bin/bash -xeu

if [ $# -ne 2 ];
then
        echo "syntax: $0 <openstack-model> <artifacts>"
        exit 1
fi

export OPENSTACK_MODEL=$1
export MODEL_NAME=$(echo $OPENSTACK_MODEL | cut -f 2 -d :)
export NEW_CLOUD=${MODEL_NAME}-openstack
export NEW_CONTROLLER=$NEW_CLOUD-RegionOne
. novarc

./setup-quotas
./bootstrap-juju2
./test-ubuntu-deploy
juju destroy-controller ${NEW_CONTROLLER} --destroy-all-models --yes