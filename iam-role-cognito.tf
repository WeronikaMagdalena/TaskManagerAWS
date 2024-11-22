# # Authenticated users need permissions to access resources after logging in.

# resource "aws_iam_role" "cognito_authenticated_role" {
#   name = "cognito_authenticated_role"
#   assume_role_policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [{
#       Effect    = "Allow",
#       Principal = { Federated = "cognito-identity.amazonaws.com" },
#       Action    = "sts:AssumeRoleWithWebIdentity",
#       Condition = {
#         StringEquals = {
#           "cognito-identity.amazonaws.com:aud" : "IDENTITY_POOL_ID" # 
#         },
#         "ForAnyValue:StringLike" : {
#           "cognito-identity.amazonaws.com:amr" : "authenticated"
#         }
#       }
#     }]
#   })
# }

# resource "aws_iam_policy" "authenticated_policy" {
#   name = "authenticated_policy"
#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect   = "Allow",
#         Action   = ["s3:PutObject", "s3:GetObject"],
#         Resource = "arn:aws:s3:::task-manager-files/*"
#       },
#       {
#         Effect   = "Allow",
#         Action   = ["execute-api:Invoke"],
#         Resource = "arn:aws:execute-api:REGION:ACCOUNT_ID:API_ID/*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "authenticated_policy_attachment" {
#   role       = aws_iam_role.cognito_authenticated_role.name
#   policy_arn = aws_iam_policy.authenticated_policy.arn
# }
