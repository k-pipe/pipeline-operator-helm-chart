#!/bin/bash

init() {
   echo "=========="
   echo "Setting up"
   echo "=========="
   kind create cluster
   #helm repo add k-pipe https://k-pipe.github.io/pipeline-operator/
   kubectl create namespace k-pipe
   #helm install k-pipe k-pipe/pipeline-controller -n k-pipe
   helm install k-pipe ./charts/pipeline -n k-pipe
   echo Waiting for deployment to get available
   kubectl wait deployment -n k-pipe k-pipe-pipeline-controller --for condition=Available=True --timeout=300s
   if [[ $? != 0 ]]
   then
     echoerr Deployment of operator did not get available
     shutdown
     exit 1
   fi
}

shutdown() {
   echo "============="
   echo "Shutting down"
   echo "============="
   helm uninstall k-pipe -n k-pipe
   echo remove repo
   #helm repo remove k-pipe
   kind delete cluster
}

echoerr() { echo "$@" 1>&2; }

init
for dir in tests/*/
do
   echo "==========================="
   echo "Running test $dir"
   echo "==========================="
   bash tests/runTest.sh $dir
#  exit
   if [ $? != 0 ]
   then
       echoerr "==========================="
       echoerr "Test $dir failed"
       echoerr "==========================="
       shutdown
       exit 1
   fi
done
echo "==========================="
echo "All tests passed"
echo "==========================="
shutdown

