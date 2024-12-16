#!/bin/bash

REGION="us-east-1"
IMAGE_NAME="task-manager-backend"
ECR_URL=$1

# aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin 454726657221.dkr.ecr.us-east-1.amazonaws.com

# # Step 1: Get the ECR authentication token and store it in a variable
AUTH_TOKEN=$(aws ecr get-login-password --region $REGION)

# # Step 2: Log in to ECR using the token
docker login --username AWS --password $AUTH_TOKEN 454726657221.dkr.ecr.us-east-1.amazonaws.com

docker build -t $IMAGE_NAME .

docker tag $IMAGE_NAME:latest $ECR_URL:latest

docker push $ECR_URL:latest
