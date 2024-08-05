#!/bin/bash

echoerr() { echo "$@" 1>&2; }

echo ""
cat "$1"description.txt
echo ""
echo Applying yamls
kubectl apply -f "$1"yaml/*.yaml
if [[ $? != 0 ]]
then
  echoerr Kubectl apply failed
  exit 1
fi
kubectl logs deployment/k-pipe-pipeline-controller -n k-pipe  | grep -v 'INFO' | grep -v 'DEBUG' | grep -v '^I' | grep -v '^Trace.*END$' > errlogs.txt
if [[ `grep -c '' errlogs.txt` != 0 ]]
then
  echoerr "Detected errors in controller logs"
  cat errlogs.txt
  exit 1
fi
echo No problems in controller logs detected
echo Running checks
bash "$1"check.sh
if [[ $? != 0 ]]
then
  echoerr Checks failed
  exit 1
fi



