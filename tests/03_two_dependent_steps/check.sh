#/bin/sh
#
echo checking pipeline run exists
kubectl get pr test-run
if [[ $? != 0 ]]
then
   exit 1
fi
echo waiting for step-b to exist
for (( i=0; i<10; ++i)); do
    kubectl get job/test-run-step-b
    if [[ $? != 0 ]]
    then
       echo Job for step-b does not exist yet
       sleep 5
    else
       echo Job for step-b exists
       break
    fi
done
echo waiting for step-b to complete
kubectl wait --for=condition=complete --timeout=60s job/test-run-step-b
if [[ $? != 0 ]]
then
   exit 1
fi
echo check step a is gone
kubectl get jobs test-run-step-a
if [[ $? == 0 ]]
then
   echo "Error: Step a is still running"
   exit 1
fi
echo "OK, step a is gone (as expected)"
echo wait for pipeline to succeed
kubectl wait --for=condition=Succeeded --timeout=500s pr/test-run
if [[ $? != 0 ]]
then
   exit 1
fi
