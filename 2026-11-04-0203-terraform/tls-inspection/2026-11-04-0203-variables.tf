variable "region" {
  type    = string
  default = "us-east-1"
}
variable "name" {
  type    = string
  default = "inspection-tls"
}
variable "ca_arn" {
  type = string
}
variable "source_cidr" {
  type    = string
  default = "10.10.0.0/16"
}
