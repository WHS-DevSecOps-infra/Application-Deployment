# CI/CD Test
# WAF
resource "aws_wafv2_web_acl" "alb_waf" {
  name        = "${var.project_name}-alb-waf"
  description = "WAF for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-alb-metric"
    sampled_requests_enabled   = true
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 1
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        vendor_name = "AWS"
        name        = "AWSManagedRulesCommonRuleSet"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "AWSManagedRulesCommonRuleSet"
      sampled_requests_enabled   = true
    }
  }

    tags = {
        Name = "${var.project_name}-alb-waf"
    }
}

# ALB
resource "aws_lb" "alb" {
    name               = "${var.project_name}-alb"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.alb_security_group_id]
    subnets            = var.public_subnet_ids

    enable_deletion_protection = true

    tags = {
        Name = "${var.project_name}-alb"
    }
}

# Target Group
resource "aws_lb_target_group" "blue" {
    name     = "${var.project_name}-blue-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    target_type = "instance"
    health_check {
        path                = "/"
        protocol            = "HTTP"
        interval            = 30
        timeout             = 5
        healthy_threshold  = 2
        unhealthy_threshold = 2
    }
    tags = {
        Name = "${var.project_name}-blue-tg"
    }
}

resource "aws_lb_target_group" "green" {
    name     = "${var.project_name}-green-tg"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id
    target_type = "instance"
    health_check {
        path                = "/"
        protocol            = "HTTP"
        interval            = 30
        timeout             = 5
        healthy_threshold  = 2
        unhealthy_threshold = 2
    }
    tags = {
        Name = "${var.project_name}-green-tg"
    }
}

# ALB 리스너
resource "aws_lb_listener" "http" {
    load_balancer_arn = aws_lb.alb.arn
    port              = 80
    protocol          = "HTTP"
    default_action {
        type = "forward"
        target_group_arn = aws_lb_target_group.blue.arn
    }
}

# WAF와 ALB 연결
resource "aws_wafv2_web_acl_association" "alb_association" {
    resource_arn = aws_lb.alb.arn
    web_acl_arn  = aws_wafv2_web_acl.alb_waf.arn
    depends_on = [aws_lb.alb]
}