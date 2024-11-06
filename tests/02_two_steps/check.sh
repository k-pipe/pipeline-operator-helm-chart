#/bin/sh
#
echo debug
echo "-----------"
echo "Pipeline runs:"
kubectl get pr
echo "-----------"
echo "Pipeline jobs:"
kubectl get pj
echo "-----------"
#kubectl logs deployment/k-pipe-operator -n k-pipe  | sed 's# *{.*$##'
#echo "-----------"
#exit 1
#kubectl get pr
#kubectl get pj
#sleep 1
#kubectl get pr
#kubectl get pj
#sleep 1
#kubectl get pr
#kubectl get pj
#sleep 1
#kubectl get pr
#kubectl get pj
#sleep 1
#kubectl get pr
#kubectl get pj
#sleep 1
#kubectl get pr -w
#kubectl get pods -w

echo waiting for step-b to complete
kubectl wait --for=condition=PVCDeleted-step-b --timeout=60s pr/test-run
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
