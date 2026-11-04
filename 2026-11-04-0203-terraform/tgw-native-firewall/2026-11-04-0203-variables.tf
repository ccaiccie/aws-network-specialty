variable "region" {
  type    = string
  default = "us-east-1"
}
variable "name" {
  type    = string
  default = "tgw-inspection"
}
variable "tgw_id" {
  type = string
}
variable "firewall_policy_arn" {
  type = string
}
variable "availability_zone_ids" {
  type = set(string)
}
