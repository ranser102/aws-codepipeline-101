#!/bin/bash -e
set +e

ACCOUNT_ID=$(aws sts get-caller-identity)
echo "ACCOUNT_ID=$ACCOUNT_ID"

# Reading Config File
. ./env.config

# Check that our AWS environment variables are defined
[ -n "${BUCKET_NAME}" ] || { echo "bucket variable not defined"; exit 1; }
[ -n "${AWS_DEFAULT_REGION}" ] || { echo "region variable not defined"; exit 1; }

function createCommonDependencies {
    #Checking and creating S3 bucket
    if aws s3 ls $BUCKET_NAME 2>&1 | grep -q 'NoSuchBucket'; then
        echo "Creating S3 bucket."
        if [ "$AWS_DEFAULT_REGION" != "us-east-1" ]; then
            aws s3api create-bucket --bucket $BUCKET_NAME --create-bucket-configuration LocationConstraint="${AWS_DEFAULT_REGION}"
        else
            aws s3api create-bucket --bucket $BUCKET_NAME
        fi
    else
        echo "Bucket already exists..."
    fi
    echo
}

function codepipeline-iam {
    aws cloudformation validate-template --template-body file://cft/codepipeline_codebuild_serviceroles.yaml
    aws cloudformation deploy \
        --region ${AWS_DEFAULT_REGION} \
        --stack-name codepipeline-iam \
        --template-file cft/codepipeline_codebuild_serviceroles.yaml \
        --capabilities CAPABILITY_NAMED_IAM \
        --no-fail-on-empty-changeset
}

# Run the Central S3 bucket
createCommonDependencies

echo "Enable versioning for pipeline bucket"
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled
    
# Zip the custom source lambda for publishing
zip -q -r9 learning-circle-app.zip aws-lambda-101/

# Publish the pipeline prereq objects
aws s3 cp learning-circle-app.zip s3://"$BUCKET_NAME"/

rm -rf *.zip

codepipeline-iam

