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
resource "aws_networkfirewall_tls_inspection_configuration" "lab" {
  name = var.name
  tls_inspection_configuration {
    server_certificate_configuration {
      certificate_authority_arn = var.ca_arn
      scope {
        protocols = [6]
        source {
          address_definition = var.source_cidr
        }
        destination {
          address_definition = "0.0.0.0/0"
        }
        source_ports {
          from_port = 0
          to_port   = 65535
        }
        destination_ports {
          from_port = 443
          to_port   = 443
        }
      }
    }
  }
}
output "tls_configuration_arn" {
  value = aws_networkfirewall_tls_inspection_configuration.lab.arn
}
