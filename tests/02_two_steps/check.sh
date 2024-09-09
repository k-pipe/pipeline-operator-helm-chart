#/bin/sh
#
echo checking pipeline run exists
#kubectl get pr test-run
if [[ $? != 0 ]]
then
   exit 1
fi
sleep 2
echo waiting for step-b to complete
kubectl wait --for=condition=Succeeded --timeout=60s pj/test-run-step-b
if [[ $? != 0 ]]
then
   exit 1
fi
echo step b completed
echo check step a is still running
STATUS=`kubectl get jobs test-run-step-a -o jsonpath='{.status.active}'`
if [[ $? != 0 ]]
then
   exit 1
fi
echo Got status $STATUS
if [[ $STATUS != 1 ]]
then
   exit 1
fi
echo wait for pipeline to succeed
kubectl wait --for=condition=Succeeded --timeout=500s pr/test-run
if [[ $? != 0 ]]
then
   exit 1
fi
