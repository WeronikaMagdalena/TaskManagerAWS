provider "docker" {
  host = "tcp://localhost:2375"
}

resource "aws_cognito_user_pool" "pool" {
  name                     = "my_user_pool"
  auto_verified_attributes = ["email"]
}

resource "aws_cognito_user_pool_client" "client" {
  name         = "my_user_pool_client"
  user_pool_id = aws_cognito_user_pool.pool.id
}

data "template_file" "example" {
  template = file(".env.tpl")

  # Variables to replace in the template
  vars = {
    reactRegion           = var.aws_region
    reactUserPoolId       = aws_cognito_user_pool.pool.id
    reactUserPoolClientId = aws_cognito_user_pool_client.client.id
    reactApiGateway       = "Test"
  }
}

resource "local_file" "generated_file" {
  content  = data.template_file.example.rendered
  filename = "./sources/.env"
}

locals {
  docker_image = "miczarne/repo:latest" # TODO
}

resource "aws_ecr_repository" "my_repository" {
  name         = "miczarne/repo" # TODO
  force_delete = true
}

resource "null_resource" "docker_build" {
  provisioner "local-exec" {
    command = "docker build -t miczarne/repo:latest ${path.module}/sources" # TODO
  }

  provisioner "local-exec" {
    command = "aws ecr get-login-password --region ${var.aws_region} --profile terraform | docker login --username AWS --password-stdin ${aws_ecr_repository.my_repository.repository_url}"
  }

  provisioner "local-exec" {
    command = " docker tag ${local.docker_image} ${aws_ecr_repository.my_repository.repository_url}:latest"
  }

  provisioner "local-exec" {
    command = "docker push ${aws_ecr_repository.my_repository.repository_url}:latest"
  }
}

resource "aws_s3_bucket" "s3_bucket_task_manager_app" {
  bucket = "ww-test-app-5343429"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_task_manager_app_ownership_controls" {
  bucket = aws_s3_bucket.s3_bucket_task_manager_app.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_task_manager_app_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_task_manager_app_ownership_controls]
  bucket     = aws_s3_bucket.s3_bucket_task_manager_app.id
  acl        = "private"
}

data "template_file" "dockerrun" {
  depends_on = [null_resource.docker_build]
  template   = file("dockerrun.aws.json.tpl")

  vars = {
    aws_repo = "${aws_ecr_repository.my_repository.repository_url}:latest"
  }
}

resource "aws_s3_bucket_object" "dockerrun" {
  depends_on = [data.template_file.dockerrun]
  bucket     = aws_s3_bucket.s3_bucket_task_manager_app.id
  key        = "Dockerrun.aws.json"
  content    = data.template_file.dockerrun.rendered
}

resource "aws_elastic_beanstalk_application" "my_app" {
  name        = "my-docker-app"
  description = "Elastic Beanstalk application for Docker"
}

resource "aws_elastic_beanstalk_application" "beanstalk_task_manager" {
  name        = "miczarne-test-app"
  description = "Task Manager Application"
}

resource "aws_elastic_beanstalk_application_version" "beanstalk_task_manager_version" {
  depends_on  = [aws_s3_bucket_object.dockerrun]
  application = aws_elastic_beanstalk_application.beanstalk_task_manager.name
  bucket      = aws_s3_bucket.s3_bucket_task_manager_app.id
  key         = aws_s3_bucket_object.dockerrun.key
  name        = "miczarne-test-app-0.0.1"
}

resource "aws_elastic_beanstalk_environment" "beanstalk_task_manager_env" {
  depends_on          = [aws_elastic_beanstalk_application_version.beanstalk_task_manager_version]
  name                = "ww-task-manager-app"
  application         = aws_elastic_beanstalk_application.beanstalk_task_manager.name
  solution_stack_name = "64bit Amazon Linux 2 v4.0.5 running Docker"
  version_label       = aws_elastic_beanstalk_application_version.beanstalk_task_manager_version.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "aws-elasticbeanstalk-ec2-role"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "DisableIMDSv1"
    value     = "true"
  }

  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "t2.micro"
  }
}
