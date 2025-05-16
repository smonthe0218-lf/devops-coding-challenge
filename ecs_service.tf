resource "aws_ecs_service" "fe" {
  name                               = "${var.project}-fe-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.fe.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_fe.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.fe.arn
    container_name   = "${var.project}-frontend"
    container_port   = 3000
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  depends_on = [
    aws_ecs_task_definition.fe
  ]
}

resource "aws_ecs_service" "be" {
  name                               = "backend-service"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.be.arn
  desired_count                      = 1
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_be.id]
    subnets          = aws_subnet.private.*.id
    assign_public_ip = false
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.be.arn
    container_name   = "${var.project}-backend"
    container_port   = 8080
  }

  lifecycle {
    ignore_changes = [task_definition]
  }

  depends_on = [
    aws_ecs_task_definition.be
  ]
}
