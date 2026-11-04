variable "region" {
  type    = string
  default = "us-east-1"
}
variable "name" {
  type    = string
  default = "inspection-gwlb"
}
variable "provider_vpc_id" {
  type = string
}
variable "provider_subnet_ids" {
  type = set(string)
}
variable "appliance_instance_ids" {
  type = set(string)
}
variable "health_port" {
  type    = number
  default = 8008
}
variable "consumer_endpoint_subnets" {
  type = map(object({
    vpc_id = string, subnet_id = string
  }))
}
