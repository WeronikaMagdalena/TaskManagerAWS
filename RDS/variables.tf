variable "aws_profile" {
  description = "AWS profile name"
  type        = string
}

variable "aws_region" {
  description = "AWS region"
  type        = string
}

# Web App
variable "cognito_user_pool" {
  description = "Authorization user pool"
  type        = string
}

variable "cognito_user_pool_client" {
  description = "Authorization user pool client"
  type        = string
}

variable "web_app_deployment_bucket" {
  description = "Deployment bucket for react web app"
  type        = string
}

variable "object_ownership" {
  default = "BucketOwnerPreferred"
  type    = string
}
