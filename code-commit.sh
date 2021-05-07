#!/bin/bash

git pull

# Reading Config File
. ./env.config

# Zip the custom source lambda for publishing
zip -q -r9 learning-circle-app.zip aws-lambda-101/

# Publish the pipeline prereq objects
aws s3 cp learning-circle-app.zip s3://"$BUCKET_NAME"/

rm -rf *.zip