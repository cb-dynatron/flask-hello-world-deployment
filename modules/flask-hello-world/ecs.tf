resource "aws_ecs_cluster" "cluster" {
  name = "${var.name_prefix}-cluster"
}

data "aws_iam_policy_document" "ecs_node" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "ecs_node" {
  name_prefix        = "${var.name_prefix}-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_node.json
}

resource "aws_iam_role_policy_attachment" "ecs_node" {
  role       = aws_iam_role.ecs_node.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ecs_node" {
  name_prefix = "${var.name_prefix}-instance-profile"
  path        = "/ecs/instance/"
  role        = aws_iam_role.ecs_node.name
}

resource "aws_security_group" "ecs_node" {
  name_prefix = "${var.name_prefix}-node-sg-"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_ssm_parameter" "ecs_node_ami" {
  name = "/aws/service/ecs/optimized-ami/amazon-linux-2023/recommended/image_id"
}

resource "aws_launch_template" "ecs_ec2" {
  name_prefix            = "${var.name_prefix}-ecs-node"
  image_id               = data.aws_ssm_parameter.ecs_node_ami.value
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.ecs_node.id]

  iam_instance_profile { arn = aws_iam_instance_profile.ecs_node.arn }

  user_data = base64encode(<<-EOF
      #!/bin/bash
      echo ECS_CLUSTER=${aws_ecs_cluster.cluster.name} >> /etc/ecs/ecs.config;
    EOF
  )

}

resource "aws_autoscaling_group" "ecs" {
  name_prefix               = "${var.name_prefix}-ecs-asg-"
  vpc_zone_identifier       = toset(data.aws_subnets.default.ids)
  min_size                  = 1
  max_size                  = 1
  health_check_grace_period = 0
  health_check_type         = "EC2"
  protect_from_scale_in     = false

  launch_template {
    id      = aws_launch_template.ecs_ec2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.name_prefix}"
    propagate_at_launch = true
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = ""
    propagate_at_launch = true
  }
}

resource "aws_ecs_capacity_provider" "ec2" {
  name = "${var.name_prefix}-ec2-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ec2" {
  cluster_name       = aws_ecs_cluster.cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ec2.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ec2.name
    base              = 1
    weight            = 100
  }
}
