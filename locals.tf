locals {
  public_subnet = {
    "us-east-1a" = {
      subnet_cidr       = "10.0.0.0/24"
      availability_zone = "us-east-1a"
      Name              = "public-subnet-us-east-1a"
    },
    "us-east-1b" = {
      subnet_cidr       = "10.0.1.0/24"
      availability_zone = "us-east-1b"
      Name              = "public-subnet-us-east-1b"
    },
    "us-east-1c" = {
      subnet_cidr       = "10.0.2.0/24"
      availability_zone = "us-east-1c"
      Name              = "public-subnet-us-east-1c"
    }
  }
}

locals {
  private_subnet = {
    "us-east-1a" = {
      subnet_cidr       = "10.0.4.0/24"
      availability_zone = "us-east-1a"
      Name              = "private-subnet-us-east-1a"
    },
    "us-east-1b" = {
      subnet_cidr       = "10.0.3.0/24"
      availability_zone = "us-east-1b"
      Name              = "private-subnet-us-east-1b"
    },
    "us-east-1c" = {
      subnet_cidr       = "10.0.5.0/24"
      availability_zone = "us-east-1c"
      Name              = "private-subnet-us-east-1c"
    }
  }
}

