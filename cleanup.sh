#!/bin/bash -xv
set +e

# read the env config
. ./env.config

# Check that our AWS environment variables are defined
[ -n "${BUCKET_NAME}" ] || { echo "bucket variable not defined"; exit 1; }
[ -n "${AWS_DEFAULT_REGION}" ] || { echo "region variable not defined"; exit 1; }

# get account id
AWS_ACCOUNT=$(aws sts get-caller-identity --output text --query Account)
echo "ACCOUNT_ID=$AWS_ACCOUNT"

aws s3 rm s3://${BUCKET_NAME} --recursive
aws s3 rb s3://${BUCKET_NAME} --force

aws --region ${AWS_DEFAULT_REGION} cloudformation delete-stack \
  --stack-name ${stackname}-${AWS_DEFAULT_REGION}

aws --region ${AWS_DEFAULT_REGION} cloudformation wait stack-delete-complete \
  --stack-name ${stackname}-${AWS_DEFAULT_REGION}

aws --region ${AWS_DEFAULT_REGION} cloudformation delete-stack \
  --stack-name ${app_stackname}

aws --region ${AWS_DEFAULT_REGION} cloudformation wait stack-delete-complete \
  --stack-name ${app_stackname}
