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
data "aws_availability_zones" "available" {
  state = "available"
}
resource "aws_vpc" "lab" {
  cidr_block           = "10.10.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}
resource "aws_subnet" "lab" {
  for_each = {
    workload = "10.10.1.0/24", firewall = "10.10.2.0/24", nat = "10.10.3.0/24"
  }
  vpc_id            = aws_vpc.lab.id
  cidr_block        = each.value
  availability_zone = data.aws_availability_zones.available.names[0]
  tags = {
    Name = "${var.name}-${each.key}"
  }
}
resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id
}
resource "aws_eip" "nat" {
  domain = "vpc"
}
resource "aws_nat_gateway" "lab" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.lab["nat"].id
  depends_on    = [aws_internet_gateway.lab]
}
resource "aws_networkfirewall_rule_group" "lab" {
  name     = "${var.name}-rules"
  capacity = 100
  type     = "STATEFUL"
  rule_group {
    rules_source {
      rules_string = "pass tcp 10.10.0.0/16 any -> any 443 (sid:1001; rev:1;)\npass tcp 10.10.0.0/16 any -> any 80 (sid:1002; rev:1;)"
    }
    stateful_rule_options {
      rule_order = "STRICT_ORDER"
    }
  }
}
resource "aws_networkfirewall_firewall_policy" "lab" {
  name = "${var.name}-policy"
  firewall_policy {
    stateless_default_actions          = ["aws:forward_to_sfe"]
    stateless_fragment_default_actions = ["aws:forward_to_sfe"]
    stateful_default_actions           = ["aws:drop_established"]
    stateful_engine_options {
      rule_order = "STRICT_ORDER"
    }
    stateful_rule_group_reference {
      resource_arn = aws_networkfirewall_rule_group.lab.arn
      priority     = 100
    }
    tls_inspection_configuration_arn = var.tls_configuration_arn == "" ? null : var.tls_configuration_arn
  }
}
resource "aws_networkfirewall_firewall" "lab" {
  name                              = var.name
  vpc_id                            = aws_vpc.lab.id
  firewall_policy_arn               = aws_networkfirewall_firewall_policy.lab.arn
  delete_protection                 = false
  subnet_change_protection          = false
  firewall_policy_change_protection = false
  subnet_mapping {
    subnet_id = aws_subnet.lab["firewall"].id
  }
}
locals {
  endpoint = one([for s in aws_networkfirewall_firewall.lab.firewall_status[0].sync_states : s.attachment[0].endpoint_id])
}
resource "aws_route_table" "lab" {
  for_each = aws_subnet.lab
  vpc_id   = aws_vpc.lab.id
}
resource "aws_route_table_association" "lab" {
  for_each       = aws_subnet.lab
  subnet_id      = each.value.id
  route_table_id = aws_route_table.lab[each.key].id
}
resource "aws_route" "workload_default" {
  route_table_id         = aws_route_table.lab["workload"].id
  destination_cidr_block = "0.0.0.0/0"
  vpc_endpoint_id        = local.endpoint
}
resource "aws_route" "firewall_default" {
  route_table_id         = aws_route_table.lab["firewall"].id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.lab.id
}
resource "aws_route" "nat_default" {
  route_table_id         = aws_route_table.lab["nat"].id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.lab.id
}
resource "aws_route" "nat_return" {
  route_table_id         = aws_route_table.lab["nat"].id
  destination_cidr_block = "10.10.1.0/24"
  vpc_endpoint_id        = local.endpoint
}
resource "aws_cloudwatch_log_group" "lab" {
  name              = "/inspection/${var.name}"
  retention_in_days = 7
}
resource "aws_networkfirewall_logging_configuration" "lab" {
  firewall_arn = aws_networkfirewall_firewall.lab.arn
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.lab.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
    log_destination_config {
      log_destination = {
        logGroup = aws_cloudwatch_log_group.lab.name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }
  }
}
data "aws_ami" "linux" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_iam_role" "vm" {
  name_prefix = "inspection-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17", Statement = [{
      Effect = "Allow", Principal = {
        Service = "ec2.amazonaws.com"
      }, Action = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.vm.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
resource "aws_iam_instance_profile" "vm" {
  name_prefix = "inspection-"
  role        = aws_iam_role.vm.name
}
resource "aws_security_group" "vm" {
  name_prefix = "inspection-"
  vpc_id      = aws_vpc.lab.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_instance" "vm" {
  ami                    = data.aws_ami.linux.id
  instance_type          = "t3.micro"
  subnet_id              = aws_subnet.lab["workload"].id
  vpc_security_group_ids = [aws_security_group.vm.id]
  iam_instance_profile   = aws_iam_instance_profile.vm.name
  metadata_options {
    http_tokens = "required"
  }
  tags = {
    Name = var.name
  }
  depends_on = [aws_route.workload_default, aws_route.firewall_default, aws_route.nat_default, aws_route.nat_return]
}
output "instance_id" {
  value = aws_instance.vm.id
}
output "endpoint_id" {
  value = local.endpoint
}
output "public_egress_ip" {
  value = aws_eip.nat.public_ip
}
output "route_tables" {
  value = {
    for k, r in aws_route_table.lab : k => r.id
  }
}
output "firewall_policy_arn" {
  value = aws_networkfirewall_firewall_policy.lab.arn
}
