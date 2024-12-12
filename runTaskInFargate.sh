aws ecs run-task \
  --cluster my-simple-cluster \
  --launch-type FARGATE \
  --network-configuration "awsvpcConfiguration={subnets=[subnet-05a5f1bf0bd26bf5f],securityGroups=[sg-0aa677c8015d318b9],assignPublicIp=ENABLED}" \
  --task-definition springboot-task
