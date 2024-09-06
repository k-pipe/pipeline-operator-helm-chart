#!/bin/bash

echoerr() { echo "$@" 1>&2; }

init_cluster() {
   echo "=========="
   echo "Setting up"
   echo "=========="
   kind create cluster
   kubectl create namespace k-pipe
   helm install k-pipe ./charts/pipeline -n k-pipe
   if [[ $1 == local ]]
   then
     echo Waiting for deployment to get available
     kubectl wait deployment -n k-pipe k-pipe-operator --for condition=Available=True --timeout=300s
     if [[ $? != 0 ]]
     then
       echoerr Deployment of operator did not get available
       shutdown
       exit 1
     fi
    fi
}

if [[ `kind get clusters | grep -c ""` == 0 ]]
then
   echo "Start kind"
   init_cluster
else
  echo "Kind cluster is already running"
fi