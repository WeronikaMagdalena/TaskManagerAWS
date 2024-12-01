resource "aws_cognito_user_pool" "user_pool" {
  name                     = "task-manager-user-pool"
  auto_verified_attributes = ["email"]
  mfa_configuration        = "OFF" # Adjust based on security needs

  password_policy {
    minimum_length    = 8
    require_uppercase = true
    require_numbers   = true
  }
}

resource "aws_cognito_user_pool_client" "user_pool_client" {
  name            = "task-manager-client"
  user_pool_id    = aws_cognito_user_pool.user_pool.id
  generate_secret = false
  explicit_auth_flows = [
    "ADMIN_NO_SRP_AUTH"
  ]
  allowed_oauth_flows  = ["implicit"]                   # Enabling Implicit Flow
  allowed_oauth_scopes = ["openid", "email", "profile"] # Required Scopes
  callback_urls        = ["http://localhost:3000/callback"]
  logout_urls          = ["http://localhost:3000/logout"]
  default_redirect_uri = "http://localhost:3000/callback"
}

resource "aws_cognito_user_pool_domain" "user_pool_domain" {
  domain       = "task-manager-app" # Replace with your desired subdomain
  user_pool_id = aws_cognito_user_pool.user_pool.id
}
