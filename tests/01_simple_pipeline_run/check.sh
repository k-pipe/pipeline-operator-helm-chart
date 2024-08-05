#/bin/sh
#
echo checking pipeline definition exists
kubectl get pd test-0.0.1
if [[ $? != 0 ]]
then
   exit 1
fi
echo checking config map exists
kubectl get cm test-0.0.1
if [[ $? != 0 ]]
then
   exit 1
fi