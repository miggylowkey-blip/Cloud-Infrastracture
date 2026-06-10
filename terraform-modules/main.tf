module "test_network" {
    source = "./vpc"
    
    client_name = "test-corp"
    environment = "production"
    vpc_cidr = "10.0.0.0/16"
    availability_zones = ["ap-southeast-2a", "ap-southeast-2b"]
    
}

output "resulting_vpc_id" {
    value = module.test_network.vpc_id

}


output "resulting_public_subnet_ids" {
    value = module.test_network.public_subnet_ids
}

output "resulting_private_subnet_ids" {
    value = module.test_network.private_subnet_ids
}


output "resulting_public_availability_zones" {
  value = module.test_network.public_subnet_availability_zones
}


output "resulting_private_availability_zones" {
  value = module.test_network.private_subnet_availability_zones
}

module "compute" {
  source = "./compute"

  # Pass the outputs from the VPC module straight into the Compute module!
  subnet_id         = module.vpc.public_subnet_ids[0] # Put it in the first public subnet
  security_group_id = module.vpc.web_security_group_id
}