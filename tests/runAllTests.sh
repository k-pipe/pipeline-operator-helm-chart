#!/bin/bash

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

