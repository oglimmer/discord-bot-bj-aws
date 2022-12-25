

# ECS

data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "cluster-discord-bot" {
  name = "cluster-discord-bot"
}

resource "aws_security_group" "ecs_sg" {
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/task-def-discord-bot"
}

resource "aws_ecs_task_definition" "task-def-discord-bot" {
  family                    = "task-def-discord-bot"
  cpu                       = 512
  memory                    = 1024
  requires_compatibilities  = ["FARGATE"]
  network_mode              = "awsvpc"
  container_definitions     = templatefile("${path.module}/container_definitions.tmpl", { 
    region = var.project_region,
    clientId = var.clientId,
    token = var.token,
    image = var.image
  })
  execution_role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/ecsTaskExecutionRole"
}

resource "aws_ecs_service" "ecs-service-discord-bot" {
  name            = "discord-bot-app"
  cluster         = aws_ecs_cluster.cluster-discord-bot.id
  task_definition = aws_ecs_task_definition.task-def-discord-bot.arn
  desired_count   = 1
  launch_type     = "FARGATE"
  deployment_maximum_percent = 100
  deployment_minimum_healthy_percent = 0

  network_configuration {
    subnets = [var.subnet_private1_id, var.subnet_private2_id]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = false
  }

}
