#! /bin/sh

# 1. Check if the AWS Cli is installed. You can read about the AWS cli here: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
if command -v aws >/dev/null 2>&1; then
  echo "AWS CLI is installed."
else
  echo "AWS CLI is not installed. Please install it and try again."
  exit 1
fi

# 2. Install if it is not there

# 3. Using the AWS Command line, publish your Docker container to ECR.
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

# 4. Use that same command line to verify that your container is published.
docker tag ecr-repo-test $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/cloud-hippie-ecr-repository:ecr-repo-test

docker push $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/cloud-hippie-ecr-repository:ecr-repo-test