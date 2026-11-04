terraform {
  required_version = ">= 1.9.0, < 2.0.0"
  required_providers {
    aws = {
      source = "hashicorp/aws", version = "6.71.0"
    }
  }
}
provider "aws" {
  region = var.region
}
resource "aws_wafv2_web_acl" "lab" {
  name  = var.name
  scope = "REGIONAL"
  default_action {
    allow {
    }
  }
  rule {
    name     = "managed-common"
    priority = 10
    override_action {
      none {
      }
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "inspection-common"
      sampled_requests_enabled   = true
    }
  }
  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "inspection-lab"
    sampled_requests_enabled   = true
  }
}
resource "aws_wafv2_web_acl_association" "lab" {
  resource_arn = var.alb_arn
  web_acl_arn  = aws_wafv2_web_acl.lab.arn
}
output "web_acl_arn" {
  value = aws_wafv2_web_acl.lab.arn
}
