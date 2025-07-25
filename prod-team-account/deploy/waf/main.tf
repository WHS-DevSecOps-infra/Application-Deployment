terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

}

provider "aws" {
  region = "ap-northeast-2"
}

# rule 목록 정의
locals {
  managed_rules = {
    # 규칙이름 = { 우선순위, AWS 관리형 규칙 이름 }
    "CommonRuleSet"      = { priority = 10, name = "AWSManagedRulesCommonRuleSet" }
    "KnownBadInputs"     = { priority = 20, name = "AWSManagedRulesKnownBadInputsRuleSet" }
    "SQLiRuleSet"        = { priority = 30, name = "AWSManagedRulesSQLiRuleSet" }
    "AmazonIpReputation" = { priority = 40, name = "AWSManagedRulesAmazonIpReputationList" }
  }
}

# IP 기반 요청 제한 규칙 생성
resource "aws_wafv2_rule_group" "rate_limit_rule" {
  name     = "${var.project_name}-rate-limit-rule"
  scope    = "REGIONAL"
  capacity = 50
  rule {
    name     = "RateLimit5Min2000"
    priority = 10

    action {
      block {}
    }

    statement {
      rate_based_statement {
        limit              = 2000
        aggregate_key_type = "IP"
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "${var.project_name}-rate-limit-metric"
    sampled_requests_enabled   = true
  }
}

# WAF
resource "aws_wafv2_web_acl" "alb_waf" {
  name        = "${var.project_name}-alb-waf"
  description = "WAF for ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  dynamic "rule" {
    for_each = local.managed_rules
    content {
      name     = "AWS-${rule.value.name}"
      priority = rule.value.priority

      override_action {
        none {}
      }

      statement {
        managed_rule_group_statement {
          vendor_name = "AWS"
          name        = rule.value.name
        }
      }

      visibility_config {
        cloudwatch_metrics_enabled = true
        metric_name                = "waf-${rule.value.name}-metric"
        sampled_requests_enabled   = true
      }
    }
  }

  # 생성된 규칙을 사용하여 요청 제한 규칙 추가
  rule {
    name     = "RateLimitRule"
    priority = 50

    statement {
      rule_group_reference_statement {
        arn = aws_wafv2_rule_group.rate_limit_rule.arn
      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "RateLimitRuleMetric"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-alb-metric"
    sampled_requests_enabled   = true
  }

  tags = {
    Name = "${var.project_name}-alb-waf"
  }
}

# S3로 로그 전송하도록 설정
resource "aws_wafv2_web_acl_logging_configuration" "waf_logging" {
  resource_arn            = aws_wafv2_web_acl.alb_waf.arn
  log_destination_configs = ["arn:aws:s3:::${var.bucket_name}"]

  logging_filter {
    default_behavior = "DROP"
    filter {
      behavior = "KEEP"
      condition {
        action_condition {
          action = "BLOCK"
        }
      }
    }
  }
}

