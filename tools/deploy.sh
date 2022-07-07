#! /bin/sh


IMAGE_NAME=$1
IMAGE_ID="$(docker images | grep "^$IMAGE_NAME" | awk '{print $3}')"
REPOSITORY_NAME="cloud-hippie-ecr-repository"
ECR_URL="$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/$REPOSITORY_NAME:$IMAGE_NAME"

echo "Logging in to AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

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
docker build -t $IMAGE_NAME .   
docker tag $IMAGE_NAME $ECR_URL
docker push $ECR_URL


# # 5. Get the image URI from ECR.
# OUTPUT=$(aws ecr describe-images --repository-name --image-id $IMAGE_ID)


# if [ $OUTPUT ]; then
#   echo "Image $IMAGE_NAME succssfully verified in ECR"
# else
#   echo "Image $IMAGE_NAME not published to ECR"
#   exit 1
# fi