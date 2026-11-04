vpc_id          = "vpc-REPLACE"
peers           = { a = { subnet_id = "subnet-A", peer_ip = "10.0.2.4", asn = 65010 } }
route_table_ids = ["rtb-DEDICATED-LAB"]
