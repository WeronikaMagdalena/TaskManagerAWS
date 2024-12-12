# resource "aws_db_instance" "task_manager_db" {
#   identifier             = "task-manager-db"
#   allocated_storage      = 20
#   engine                 = "postgres"
#   engine_version         = "16.3"
#   instance_class         = "db.t3.micro"
#   username               = "wera"
#   password               = "password" # Ensure to use a secure method for passwords
#   db_subnet_group_name   = aws_db_subnet_group.task_manager_subnet_group.name
#   vpc_security_group_ids = [aws_security_group.rds_sg.id]
#   publicly_accessible    = true
# }

# resource "aws_db_subnet_group" "task_manager_subnet_group" {
#   name       = "task_manager_subnet_group"
#   subnet_ids = [aws_subnet.task_manager_subnet_a.id, aws_subnet.task_manager_subnet_b.id]
# }
