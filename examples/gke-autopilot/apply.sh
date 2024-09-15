#!/bin/sh
#
# Shell script to ensure state bucket exists and to run terraform
#
# USAGE: apply.sh [gcp-project-id] [gcp-zone]
#
# if no first command line argument is specified, use the current default project
if [[ $1 ]]
then
  PROJECT_ID=$1
else
  PROJECT_ID=`gcloud config list --format 'value(core.project)'`
fi
# if no second command line argument is specified, use the current default ZONE
if [[ $2 ]]
then
  ZONE=$2
else
  ZONE=`gcloud config list --format 'value(compute.zone)'`
fi
REGION=`echo $ZONE | sed 's#-[^-]$##'`
echo "Running terraform with PROJECT_ID=$PROJECT_ID and ZONE=$ZONE, REGION=$REGION"
#
# if bucket to store terraform state does not exist, create it
BUCKET_NAME="$PROJECT_ID-terraform-state"
if gcloud storage buckets describe "gs://${BUCKET_NAME}" &> /dev/null ; then
  echo "The bucket for the terraform state ${BUCKET_NAME} already exists"
else
  echo "Creating bucket for the terraform state: ${BUCKET_NAME}"
  gcloud storage buckets create "gs://${BUCKET_NAME}" --project=$PROJECT_ID --location=$REGION
fi

# terraform init
echo "Initializing terraform"
terraform init -backend-config="bucket=${BUCKET_NAME}"

# terraform apply
echo "Running terraform apply"
terraform apply -var project_id=$PROJECT_ID -var region=$REGION -var zone=$ZONE

echo "Done"