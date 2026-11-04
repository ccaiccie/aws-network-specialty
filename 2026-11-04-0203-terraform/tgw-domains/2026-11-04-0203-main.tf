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
resource "aws_ec2_transit_gateway_route_table" "pre" {
  transit_gateway_id = var.tgw_id
  tags = {
    Name = "inspection-pre"
  }
}
resource "aws_ec2_transit_gateway_route_table" "post" {
  transit_gateway_id = var.tgw_id
  tags = {
    Name = "inspection-post"
  }
}
resource "aws_ec2_transit_gateway_route_table_association" "source" {
  for_each                       = var.source_attachments
  transit_gateway_attachment_id  = each.value
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre.id
}
resource "aws_ec2_transit_gateway_route_table_association" "inspection" {
  transit_gateway_attachment_id  = var.inspection_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post.id
}
resource "aws_ec2_transit_gateway_route" "inspect" {
  for_each                       = var.destinations
  destination_cidr_block         = each.key
  transit_gateway_attachment_id  = var.inspection_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.pre.id
}
resource "aws_ec2_transit_gateway_route" "deliver" {
  for_each                       = var.destinations
  destination_cidr_block         = each.key
  transit_gateway_attachment_id  = each.value
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.post.id
}
output "pre_table" {
  value = aws_ec2_transit_gateway_route_table.pre.id
}
output "post_table" {
  value = aws_ec2_transit_gateway_route_table.post.id
}
