#!/bin/bash

echoerr() { echo "$@" 1>&2; }

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

sleep 5
echo Running checks
bash "$1"check.sh
if [[ $? != 0 ]]
then
  echoerr Checks failed
  exit 1
fi

echo deleting test resources
kubectl delete -f "$1"yaml/

