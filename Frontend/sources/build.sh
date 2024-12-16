#!/bin/bash

REGION="us-east-1"
IMAGE_NAME="task-manager-frontend"
ECR_URL=$1

docker build -t $IMAGE_NAME .

docker tag $IMAGE_NAME:latest $ECR_URL:latest

docker push $ECR_URL:latest
