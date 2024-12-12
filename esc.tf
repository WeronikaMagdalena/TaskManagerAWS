resource "aws_ecs_service" "task_manager_service" {
  name            = "task-manager-service"
  cluster         = "my-simple-cluster"
  task_definition = "arn:aws:ecs:us-east-1:454726657221:task-definition/springboot-task:3"
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = [aws_subnet.task_manager_subnet_a.id, aws_subnet.task_manager_subnet_b.id]
    security_groups  = [aws_security_group.fargate_sg.id]
    assign_public_ip = true
  }
}
