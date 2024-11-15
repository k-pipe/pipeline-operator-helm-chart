#/bin/sh
#
echo checking pipeline run exists
kubectl get pr test-run
if [[ $? != 0 ]]
then
   exit 1
fi
#echo waiting for job to terminate
#kubectl wait --for=condition=complete --timeout=300s  job/test-run-step-a
#if [[ $? != 0 ]]
#then
#   exit 1
#fi
echo waiting for pipeline to succeed
kubectl wait --for=condition=Succeeded --timeout=500s pr/test-run
if [[ $? != 0 ]]
then
   echo "Pipeline did not succeed:"
   kubectl get pr test-run
   exit 1
fi
