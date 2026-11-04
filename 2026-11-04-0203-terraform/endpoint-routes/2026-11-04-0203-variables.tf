variable "region" {
  type    = string
  default = "us-east-1"
}
variable "routes" {
  type = map(object({
    route_table_id = string, destination = string, endpoint_id = string
  }))
}
variable "igw_id" {
  type    = string
  default = ""
}
variable "edge_route_table_id" {
  type    = string
  default = ""
}
