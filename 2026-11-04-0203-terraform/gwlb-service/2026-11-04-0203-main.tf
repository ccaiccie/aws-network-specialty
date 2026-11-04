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
resource "aws_lb" "gwlb" {
  name               = var.name
  load_balancer_type = "gateway"
  subnets            = var.provider_subnet_ids
}
resource "aws_lb_target_group" "nva" {
  name        = var.name
  port        = 6081
  protocol    = "GENEVE"
  vpc_id      = var.provider_vpc_id
  target_type = "instance"
  health_check {
    protocol = "TCP"
    port     = tostring(var.health_port)
  }
}
resource "aws_lb_target_group_attachment" "nva" {
  for_each         = var.appliance_instance_ids
  target_group_arn = aws_lb_target_group.nva.arn
  target_id        = each.value
}
resource "aws_lb_listener" "gwlb" {
  load_balancer_arn = aws_lb.gwlb.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nva.arn
  }
}
resource "aws_vpc_endpoint_service" "lab" {
  acceptance_required        = false
  gateway_load_balancer_arns = [aws_lb.gwlb.arn]
}
resource "aws_vpc_endpoint" "consumer" {
  for_each          = var.consumer_endpoint_subnets
  vpc_id            = each.value.vpc_id
  subnet_ids        = [each.value.subnet_id]
  service_name      = aws_vpc_endpoint_service.lab.service_name
  vpc_endpoint_type = "GatewayLoadBalancer"
}
output "endpoint_ids" {
  value = {
    for k, e in aws_vpc_endpoint.consumer : k => e.id
  }
}
output "service_name" {
  value = aws_vpc_endpoint_service.lab.service_name
}
