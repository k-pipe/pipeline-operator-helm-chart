#!/bin/bash

echoerr() { echo "$@" 1>&2; }

bash tests/ensureKindExists.sh
kubectl delete deployment k-pipe-operator -n k-pipe
for dir in tests/*/
do
   echo "==========================="
   echo "Running test $dir"
   echo "==========================="
   bash tests/runTestLocally.sh $dir
#  exit
   if [ $? != 0 ]
   then
       echoerr "==========================="
       echoerr "Test $dir failed"
       echoerr "==========================="
       exit 1
   fi
done
echo "==========================="
echo "All tests passed"
echo "==========================="
