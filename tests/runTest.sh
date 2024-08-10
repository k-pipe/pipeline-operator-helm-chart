#!/bin/bash

echoerr() { echo "$@" 1>&2; }

sh tests/ensureKindExists.sh
echo ""
cat "$1"description.txt
echo ""
echo Applying yamls
kubectl apply -f "$1"yaml/
if [[ $? != 0 ]]
then
  echoerr Kubectl apply failed
  exit 1
fi

echo Running checks
bash "$1"check.sh
if [[ $? != 0 ]]
then
  echoerr Checks failed
  exit 1
fi

echo Checking logs
kubectl logs deployment/k-pipe-operator -n k-pipe  | grep -v 'INFO' | grep -v 'DEBUG' | grep -v '^I' | grep -v '^Trace.*END$' > errlogs.txt
if [[ $? != 0 ]]
then
  echoerr Checks failed
  exit 1
fi
if [[ `grep -c '' errlogs.txt` != 0 ]]
then
  echoerr "Detected errors in operator logs"
  cat errlogs.txt
  exit 1
fi
echo No problems in operator logs detected

echo deleting test resources
kubectl delete -f "$1"yaml/

