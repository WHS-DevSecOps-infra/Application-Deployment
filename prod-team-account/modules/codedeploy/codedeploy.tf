# CodeDeploy
resource "aws_codedeploy_app" "ecs_app" {
  name = "${var.project_name}-ecs-app"
  compute_platform = "ECS"
}

resource "aws_codedeploy_deployment_group" "ecs_deployment_group" {
  app_name = aws_codedeploy_app.ecs_app.name
  deployment_group_name = "${var.project_name}-ecs-deployment-group"
  service_role_arn = var.codedeploy_service_role_arn

  deployment_config_name = "CodeDeployDefault.ECSAllAtOnce"
  
  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  deployment_style {
    deployment_type = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  blue_green_deployment_config {
    deployment_ready_option {
        action_on_timeout = "CONTINUE_DEPLOYMENT"
    }
    terminate_blue_instances_on_deployment_success {
        action = "TERMINATE"
        termination_wait_time_in_minutes = 5
    }
  }
  load_balancer_info {
    target_group_pair_info {
      target_group {
        name = var.blue_target_group_name
      }
      target_group {
        name = var.green_target_group_name
      }
      prod_traffic_route {
        listener_arns = [var.alb_listener_arn]
      }
    }
  }
  auto_rollback_configuration {
    enabled = true
    events = ["DEPLOYMENT_FAILURE"]
  }

}