variable "region" {
  type    = string
  default = "us-east-1"
}
variable "routes" {
  type = map(object({
    route_table_id = string, destination = string, eni_id = string
  }))
}
