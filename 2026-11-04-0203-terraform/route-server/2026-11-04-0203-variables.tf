variable "region" {
  type    = string
  default = "us-east-1"
}
variable "vpc_id" {
  type = string
}
variable "peers" {
  type = map(object({
    subnet_id = string, peer_ip = string, asn = number
  }))
}
variable "route_table_ids" {
  type = set(string)
}
