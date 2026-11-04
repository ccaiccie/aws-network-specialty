routes = {
  forward = { route_table_id = "rtb-REPLACE", destination = "10.20.1.0/24", endpoint_id = "vpce-REPLACE" }
  reverse = { route_table_id = "rtb-REPLACE2", destination = "0.0.0.0/0", endpoint_id = "vpce-REPLACE" }
}
# For ingress, provide a dedicated edge table and IGW association.
igw_id              = ""
edge_route_table_id = ""
