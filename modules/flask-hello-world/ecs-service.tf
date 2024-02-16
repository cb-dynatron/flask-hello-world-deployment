data "aws_iam_policy_document" "ecs_task" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_task" {
  name_prefix        = "${var.name_prefix}-ecs-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json
}

resource "aws_iam_role" "ecs_execution" {
  name_prefix        = "${var.name_prefix}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task.json
}

resource "aws_iam_role_policy_attachment" "ecs_execution" {
  role       = aws_iam_role.ecs_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_cloudwatch_log_group" "ecs" {
  name              = "/ecs/${var.name_prefix}-logs"
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "task" {
  family             = "${var.name_prefix}-task"
  task_role_arn      = aws_iam_role.ecs_task.arn
  execution_role_arn = aws_iam_role.ecs_execution.arn
  network_mode       = "awsvpc"
  cpu                = 256
  memory             = 256

  container_definitions = jsonencode([{
    name         = "${var.name_prefix}-container",
    image        = "${var.image_name}:${var.image_tag}",
    essential    = true,
    portMappings = [{ containerPort = 8888, hostPort = 8888 }],
    "environment": [
      {"name": "FLASK_RUN_PORT", "value": "8888"}
    ],

    logConfiguration = {
      logDriver = "awslogs",
      options = {
        "awslogs-region"        = var.aws_region,
        "awslogs-group"         = aws_cloudwatch_log_group.ecs.name,
        "awslogs-stream-prefix" = "${var.name_prefix}"
      }
    }
  }])
}

resource "aws_security_group" "ecs_task" {
  name_prefix = "${var.name_prefix}-ecs-task-sg"
  description = "Allow ingress traffic to 8888 and access to internet"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 8888
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_service" "svc" {
  name            = "${var.name_prefix}-svc"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  network_configuration {
    security_groups = [aws_security_group.ecs_task.id]
    subnets         = toset(data.aws_subnets.default.ids)
  }

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2.name
    base              = 1
    weight            = 100
  }

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
 
  load_balancer {
    target_group_arn = aws_lb_target_group.ecs_svc.arn
    container_name   = "${var.name_prefix}-container"
    container_port   = 8888
  }

  lifecycle {
    ignore_changes = [desired_count]
  }
}
