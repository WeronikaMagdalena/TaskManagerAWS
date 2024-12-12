# resource "aws_vpc" "task_manager_vpc" {
#   cidr_block           = "10.0.0.0/16"
#   enable_dns_support   = true
#   enable_dns_hostnames = true
# }

# resource "aws_subnet" "task_manager_subnet_a" {
#   vpc_id            = aws_vpc.task_manager_vpc.id
#   cidr_block        = "10.0.1.0/24"
#   availability_zone = "us-east-1a"
# }

# resource "aws_subnet" "task_manager_subnet_b" {
#   vpc_id            = aws_vpc.task_manager_vpc.id
#   cidr_block        = "10.0.2.0/24"
#   availability_zone = "us-east-1b"
# }

# resource "aws_security_group" "rds_sg" {
#   name   = "rds_security_group"
#   vpc_id = aws_vpc.task_manager_vpc.id

#   ingress {
#     from_port   = 5432
#     to_port     = 5432
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }

# resource "aws_security_group" "beanstalk_sg" {
#   name        = "beanstalk_sg"
#   description = "Security group for Elastic Beanstalk instances"
#   vpc_id      = aws_vpc.task_manager_vpc.id

#   ingress {
#     from_port   = 8080
#     to_port     = 8080
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   ingress {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# }


# resource "aws_internet_gateway" "task_manager_internet_gateway" {
#   vpc_id = aws_vpc.task_manager_vpc.id
# }

# resource "aws_route_table" "public_route_table" {
#   vpc_id = aws_vpc.task_manager_vpc.id

#   route {
#     cidr_block = "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.task_manager_internet_gateway.id
#   }
# }

# resource "aws_route_table_association" "public_subnet_a" {
#   subnet_id      = aws_subnet.task_manager_subnet_a.id
#   route_table_id = aws_route_table.public_route_table.id
# }

# resource "aws_route_table_association" "public_subnet_b" {
#   subnet_id      = aws_subnet.task_manager_subnet_b.id
#   route_table_id = aws_route_table.public_route_table.id
# }
