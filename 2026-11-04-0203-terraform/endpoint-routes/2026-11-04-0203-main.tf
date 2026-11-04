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
resource "aws_route" "lab" {
  for_each               = var.routes
  route_table_id         = each.value.route_table_id
  destination_cidr_block = each.value.destination
  vpc_endpoint_id        = each.value.endpoint_id
}
resource "aws_route_table_association" "edge" {
  count          = var.igw_id == "" ? 0 : 1
  gateway_id     = var.igw_id
  route_table_id = var.edge_route_table_id
}
output "routes" {
  value = {
    for k, r in aws_route.lab : k => r.id
  }
}
