routes = {
  forward = { route_table_id = "rtb-SOURCE", destination = "10.20.0.0/16", eni_id = "eni-FIREWALL-TRUST" }
  reverse = { route_table_id = "rtb-DESTINATION", destination = "10.10.0.0/16", eni_id = "eni-FIREWALL-TRUST" }
}
