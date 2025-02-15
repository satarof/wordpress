module "wordpress" {
  source               = "../"
  vpc_cidr             = "10.0.0.0/16"
  availability_zone    = "us-east-1a"
  public_subnet_cidrs  = ["10.0.0.0/19", "10.0.32.0/19", "10.0.64.0/19"]
  private_subnet_cidrs = ["10.0.96.0/19", "10.0.128.0/19", "10.0.160.0/19"]
  open_ports           = [22, 80, 443, 3306]
  ami                  = "ami-04681163a08179f28"
  instance_type        = "t2.micro"
}

terraform {
  backend "s3" {
    bucket = "temirlans-bucket"
    key    = "wordpress/wordpress.tfstate"
    region = "us-east-1"
  }
}


# output pubsub2 {
#     value = module.public_subnet_cidrs.id
# }

# output pubsub3 {
#     value = module.public_subnet_cidrs.id
# }