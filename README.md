# AWS codepipeline

This project contains the needed resources for provisioning AWS codepipleine
which build and deploy SAM application (runtime: java8, maven) into AWS account

## Useful links

### SAM
- https://aws.amazon.com/serverless/sam/
- https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html

### Cloudformation
- https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/template-reference.html

### Codepipeline
- Intro: https://docs.aws.amazon.com/codepipeline/latest/userguide/welcome.html
- Concept: https://docs.aws.amazon.com/codepipeline/latest/userguide/concepts.html 
- Actions and providers: https://docs.aws.amazon.com/codepipeline/latest/userguide/reference-pipeline-structure.html
- Cloudformation resource: https://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-codepipeline-pipeline.html
- Pricing: https://aws.amazon.com/codepipeline/pricing/ 

### Codebuild
- https://docs.aws.amazon.com/codebuild/latest/userguide/welcome.html
- Build environment: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref.html
- Docker images: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html 
- Build environment compute types: https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-compute-types.html
-  Buildspec: https://docs.aws.amazon.com/codebuild/latest/userguide/build-spec-ref.html

### Cloudshell
- https://docs.aws.amazon.com/cloudshell/latest/userguide/welcome.html 

## Useful commands
**sam cli:**
- `sam init ...`
- `sam package ...`
- `sam deploy ...`

**aws cli:**
- `aws s3 ...`
- `aws s3api ...`
- `aws cloudformation ...`

## Notes
Use the following scripts to iterate through the creation and deletion of the resources required for the pipeline:
- `cleanup.sh` - Delete all resources from previous iteration for a clean start
- `prepare.sh` - Provision resources needed by the pipeline, such: S3, source-code as zip file, IAM serviceroles
- `deploy.sh`  - Provision the pipeline stack
