#/bin/sh
#
echo checking pipeline definition exists
kubectl get pd smoke-test-0.0.1
if [[ $? != 0 ]]
then
   exit 1
fi
echo checking config map does not exist
kubectl get cm smoke-test-0.0.1
if [[ $? == 0 ]]
then
   exit 1
fi
echo "config map does not exist (as expected)"