resource "aws_elastic_beanstalk_application" "task_manager" {
  name        = "task-manager"
  description = "Task Manager Application"
}

# resource "aws_s3_bucket_object" "dockerrun" {
#   bucket = "backend-bucket"
#   key    = "Dockerrun.aws.json"
#   source = "C:/Users/werka/Documents/cloud-project/backend/Dockerrun.aws.json"
# }

# resource "aws_elastic_beanstalk_application_version" "task_manager_version" {
#   name        = "v1"
#   application = aws_elastic_beanstalk_application.task_manager.name
#   bucket      = "backend-bucket"
#   key         = aws_s3_bucket_object.dockerrun.key
# }

resource "aws_elastic_beanstalk_environment" "task_manager_env" {
  name                = "task-manager-env"
  application         = aws_elastic_beanstalk_application.task_manager.name
  solution_stack_name = "64bit Amazon Linux 2 v4.0.5 running Docker"
  # version_label       = aws_elastic_beanstalk_application_version.task_manager_version.name

  setting {
    namespace = "aws:elasticbeanstalk:container:docker"
    name      = "ImageURI"
    value     = "454726657221.dkr.ecr.us-east-1.amazonaws.com/task-manager-repo:latest" # Replace with your ECR image URI
  }
}
