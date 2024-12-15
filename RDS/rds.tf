resource "aws_db_instance" "task_manager_db" {
  identifier             = "task-manager-db-2"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  username               = "wera"     # Create variable for username and password
  password               = "password" # Secret Manager
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = true
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "rds_sg" {
  name   = "rds_security_group"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 5432 # PostgreSQL default port
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Adjust to your needs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# resource "null_resource" "create_table" {
#   depends_on = [aws_db_instance.task_manager_db]

#   provisioner "local-exec" {
#     command = "set PGPASSWORD=password && psql -h ${aws_db_instance.task_manager_db.endpoint} -U admin -d postgres -c \"CREATE TABLE task (id SERIAL PRIMARY KEY, title VARCHAR(255) NOT NULL, description TEXT, deadline DATE, completed BOOLEAN DEFAULT FALSE);\""
#   }
# }
