provider_vpc_id           = "vpc-PROVIDER"
provider_subnet_ids       = ["subnet-PROVIDER-A"]
appliance_instance_ids    = ["i-LICENSED-GENEVE-APPLIANCE"]
consumer_endpoint_subnets = { a = { vpc_id = "vpc-CONSUMER", subnet_id = "subnet-ENDPOINT-A" } }
