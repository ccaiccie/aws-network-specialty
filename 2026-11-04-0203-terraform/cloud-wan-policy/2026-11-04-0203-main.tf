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
resource "aws_networkmanager_core_network_policy_attachment" "lab" {
  core_network_id = var.core_network_id
  policy_document = file(var.policy_file)
}
output "core_network_id" {
  value = var.core_network_id
}
