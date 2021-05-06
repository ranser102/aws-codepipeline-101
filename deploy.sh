#!/bin/bash
set +e

# read the env config
. ./env.config

[ -n "${AWS_DEFAULT_REGION}" ] || { echo "region variable not defined"; exit 1; }

# get account id
AWS_ACCOUNT=$(aws sts get-caller-identity --output text --query Account)
echo "ACCOUNT_ID=$AWS_ACCOUNT"

if ! aws cloudformation describe-stacks --stack-name ${stackname}-${AWS_DEFAULT_REGION} --region ${AWS_DEFAULT_REGION} >/dev/null 2>&1; then
   echo "stack does not exist, creating"
   aws --region ${AWS_DEFAULT_REGION} cloudformation deploy \
   --stack-name ${stackname}-${AWS_DEFAULT_REGION} \
   --template-file cft/pipeline_lambda.yaml \
   --capabilities CAPABILITY_NAMED_IAM \
   --no-fail-on-empty-changeset
fi
