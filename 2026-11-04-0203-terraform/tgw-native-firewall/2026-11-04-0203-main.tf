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
resource "aws_networkfirewall_firewall" "lab" {
  name                = var.name
  transit_gateway_id  = var.tgw_id
  firewall_policy_arn = var.firewall_policy_arn
  delete_protection   = false
  dynamic "availability_zone_mapping" {
    for_each = var.availability_zone_ids
    content {
      availability_zone_id = availability_zone_mapping.value
    }
  }
}
output "firewall_arn" {
  value = aws_networkfirewall_firewall.lab.arn
}
output "firewall_status" {
  value = aws_networkfirewall_firewall.lab.firewall_status
}
