resource "aws_db_instance" "task_manager_db" {
  identifier             = "task-manager-db-3"
  allocated_storage      = 20
  engine                 = "postgres"
  engine_version         = "16.3"
  instance_class         = "db.t3.micro"
  username               = "wera"     # Create variable for username and password
  password               = "password" # Secret Manager
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible    = true
  skip_final_snapshot    = true
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "rds_sg" {
  name   = "rds_security_group"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # set to my ip
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "db_instance_endpoint" {
  value = aws_db_instance.task_manager_db.address
}

resource "null_resource" "create_table" {
  depends_on = [aws_db_instance.task_manager_db] # depends on db_instance_endpoint ?

  provisioner "local-exec" {
    command = "create_table.sh" # move to source
  }
}