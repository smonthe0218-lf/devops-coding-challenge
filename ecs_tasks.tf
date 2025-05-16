resource "aws_ecs_task_definition" "fe" {
  family                   = "frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions = jsonencode([
    {
      name      = "${var.project}-frontend"
      image     = "${var.frontend_repo}:fe-2.0.0"
      essential = true
      environment = [
        {
          name  = "REACT_APP_API_URL",
          value = "http://${aws_lb.main.dns_name}:8080"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/frontend-container"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "awslogs-fe"
        }
      }
      #    environment = var.container_environment
      portMappings = [{

        protocol      = "tcp"
        containerPort = 3000
        hostPort      = 3000
      }]
    }
  ])
}

resource "aws_ecs_task_definition" "be" {
  family                   = "backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "${var.project}-backend"
      image     = "${var.backend_repo}:be-2.0.0"
      essential = true
      environment = [
        {
          name  = "FRONT_URL",
          value = "http://${aws_lb.main.dns_name}"
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/backend-container"
          awslogs-region        = "us-east-1"
          awslogs-stream-prefix = "awslogs-be"
        }
      }
      #    environment = var.container_environment
      portMappings = [{
        name          = "http-port"
        protocol      = "tcp"
        containerPort = 8080
        hostPort      = 8080
      }]
    }

  ])
}
