resource "aws_ecs_cluster" "main" {
  name = "${var.project}-cluster"
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/frontend-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "aesquerre"
  }
}

resource "aws_cloudwatch_log_group" "backend_log_group" {
  name = "/ecs/backend-container"
  tags = {
    "env"       = "dev"
    "createdBy" = "aesquerre"
  }
}
