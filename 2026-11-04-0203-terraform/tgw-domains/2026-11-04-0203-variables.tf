variable "region" {
  type    = string
  default = "us-east-1"
}
variable "tgw_id" {
  type = string
}
variable "inspection_attachment_id" {
  type = string
}
variable "source_attachments" {
  type = map(string)
}
variable "destinations" {
  type = map(string)
}
