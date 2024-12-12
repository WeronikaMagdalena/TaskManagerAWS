resource "aws_s3_bucket" "s3_bucket_task_manager_app" {
  bucket = "ww-task-manager-app-283726328"
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_task_manager_app_ownership_controls" {
  bucket = aws_s3_bucket.s3_bucket_task_manager_app.id
  rule {
    object_ownership = var.object_ownership
  }
}

resource "aws_s3_bucket_acl" "s3_bucket_task_manager_app_acl" {
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_task_manager_app_ownership_controls]
  bucket     = aws_s3_bucket.s3_bucket_task_manager_app.id
  acl        = "private"
}

resource "aws_s3_bucket_object" "dockerrun" {
  bucket = aws_s3_bucket.s3_bucket_task_manager_app.id
  key    = "Dockerrun.aws.json"
  source = "sources/Dockerrun.aws.json"
}

resource "aws_elastic_beanstalk_application" "beanstalk_task_manager" {
  name        = "ww-task-manager"
  description = "Task Manager Application"
}

resource "aws_elastic_beanstalk_application_version" "beanstalk_task_manager_version" {
  application = aws_elastic_beanstalk_application.beanstalk_task_manager.name
  bucket      = aws_s3_bucket.s3_bucket_task_manager_app.id
  key         = aws_s3_bucket_object.dockerrun.key
  name        = "task-manager-0.0.1"
}

resource "aws_elastic_beanstalk_environment" "beanstalk_task_manager_env" {
  name                = "ww-task-manager"
  application         = aws_elastic_beanstalk_application.beanstalk_task_manager.name
  solution_stack_name = "64bit Amazon Linux 2 v4.0.5 running Docker"
  version_label       = aws_elastic_beanstalk_application_version.beanstalk_task_manager_version.name

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "LabInstanceProfile"
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

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }
}

