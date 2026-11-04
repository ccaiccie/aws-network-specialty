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
resource "aws_vpc_route_server" "lab" {
  amazon_side_asn = 64512
}
resource "aws_vpc_route_server_vpc_association" "lab" {
  route_server_id = aws_vpc_route_server.lab.route_server_id
  vpc_id          = var.vpc_id
}
resource "aws_vpc_route_server_endpoint" "lab" {
  for_each        = var.peers
  route_server_id = aws_vpc_route_server.lab.route_server_id
  subnet_id       = each.value.subnet_id
}
resource "aws_vpc_route_server_peer" "lab" {
  for_each                 = var.peers
  route_server_endpoint_id = aws_vpc_route_server_endpoint.lab[each.key].route_server_endpoint_id
  peer_address             = each.value.peer_ip
  bgp_options {
    peer_asn                = each.value.asn
    peer_liveness_detection = "bgp-keepalive"
  }
}
resource "aws_vpc_route_server_propagation" "lab" {
  for_each        = var.route_table_ids
  route_server_id = aws_vpc_route_server.lab.route_server_id
  route_table_id  = each.value
  depends_on      = [aws_vpc_route_server_vpc_association.lab]
}
output "endpoints" {
  value = aws_vpc_route_server_endpoint.lab
}
