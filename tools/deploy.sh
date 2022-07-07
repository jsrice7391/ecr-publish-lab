#! /bin/sh



IMAGE_ID=$(docker images | grep "^$IMAGE_NAME" | awk '{print $3}')
REPOSITORY_NAME="cloud-hippie-ecr-repository"
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_ID"


if [ -z "$IMAGE_ID" ]; then
    echo "Image $IMAGE_NAME not found"
    exit 1
fi

# 1. Check if the AWS Cli is installed. You can read about the AWS cli here: https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html
if command -v aws >/dev/null 2>&1; then
  echo "AWS CLI is installed."
else
  echo "AWS CLI is not installed. Please install it and try again."
  exit 1
fi


# 3. Using the AWS Command line, publish your Docker container to ECR.
docker build -t ecr-repo-test .   
docker tag ecr-repo-test $URL
docker push $URL


# 5. Get the image URI from ECR.
OUTPUT=$(aws ecr describe-image --repository-name  --image-id $IMAGE_ID)


if [ $OUTPUT ]; then
  echo "Image $IMAGE_NAME succssfully verified in ECR"
else
  echo "Image $IMAGE_NAME not published to ECR"
  exit 1
fi