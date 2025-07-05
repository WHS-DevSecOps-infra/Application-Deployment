# iam에서 생성한 ARN 변수 전달
variable "ecs_task_execution_role_arn" {
  type        = string
  description = "The ARN of the ECS Task Execution Role"
}

# ECS 클러스터 생성
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.project_name}-ecs-cluster"
}

# ECS Launch Template
resource "aws_launch_template" "ecs_launch_template" {
  name_prefix   = "${var.project_name}-ecs-launch-template-"
  image_id      = "ami-0bc365768d185847c"
  instance_type = "t2.micro"
  
  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }
  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [aws_security_group.ecs_sg.id]
  }

    user_data = base64encode(<<-EOF
        #!/bin/bash
        echo ECS_CLUSTER=${aws_ecs_cluster.ecs_cluster.name} >> /etc/ecs/ecs.config
        EOF
    )

    tags = {
        Name = "${var.project_name}-ecs-launch-template"
    }
}

# ECS Auto Scaling Group
resource "aws_autoscaling_group" "ecs_auto_scaling_group" {
  launch_template {
    id      = aws_launch_template.ecs_launch_template.id
    version = "$Latest"
  }
  
  min_size                  = 1
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier      = [aws_subnet.private1.id, aws_subnet.private2.id]
  health_check_type        = "EC2"
  force_delete              = true
  protect_from_scale_in   = true
  
  tag {
      key                 = "ECS_Manage"
      value               = "${var.project_name}-ecs-auto-scaling-group"
      propagate_at_launch = true
    }

}

# ECS capacity provider
resource "aws_ecs_capacity_provider" "ecs_capacity_provider" {
    name = "${var.project_name}-ecs-capacity-provider"
    auto_scaling_group_provider {
        auto_scaling_group_arn = aws_autoscaling_group.ecs_auto_scaling_group.arn
        managed_termination_protection = "ENABLED"
        managed_scaling {
            status = "ENABLED"
            target_capacity = 100
        }
    }
}

# Capacity provider association
resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers" {
    cluster_name = aws_ecs_cluster.ecs_cluster.name
    capacity_providers = [aws_ecs_capacity_provider.ecs_capacity_provider.name]
    default_capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
        weight            = 100
        base              = 1
    }
}

# ECS Task Definition
resource "aws_ecs_task_definition" "ecs_task_definition" {
    family                   = "${var.project_name}-ecs-task"
    network_mode             = "bridge"
    requires_compatibilities = ["EC2"]
    execution_role_arn       = var.ecs_task_execution_role_arn

    container_definitions = jsonencode([
        {
            name      = "${var.project_name}-container"
            image     = "${data.terraform_remote_state.operation_account.outputs.ecr_repository_url}:latest"
            cpu       = 256
            memory    = 512
            essential = true
            portMappings = [
                {
                    containerPort = 80
                    hostPort      = 80
                    protocol      = "tcp"
                }
            ]
        }
    ])
}

# ECS Service
resource "aws_ecs_service" "ecs_service" {
    name            = "${var.project_name}-ecs-service"
    cluster         = aws_ecs_cluster.ecs_cluster.id
    task_definition = aws_ecs_task_definition.ecs_task_definition.arn
    desired_count   = 2
 

    capacity_provider_strategy {
        capacity_provider = aws_ecs_capacity_provider.ecs_capacity_provider.name
        weight            = 100
    }

    load_balancer {
        target_group_arn = aws_lb_target_group.blue.arn
        container_name   = "${var.project_name}-container"
        container_port   = 80
    }

    deployment_controller {
        type = "CODE_DEPLOY"
    }

    lifecycle {
        ignore_changes = [task_definition, desired_count]
    }

    health_check_grace_period_seconds = 60

    tags = {
        Name = "${var.project_name}-ecs-service"
    }
}
  