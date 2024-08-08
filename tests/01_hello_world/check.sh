#/bin/sh
#
echo checking pipeline definition exists
kubectl get pd hello-world-0.0.1
if [[ $? != 0 ]]
then
   exit 1
fi
