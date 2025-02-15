variable "vpc_cidr" {
  type        = string
  description = "vpc cidr block of wordpress"
}

variable "public_subnet_cidrs" {
  type        = list(string)
  description = "subnets cidr blocks for each cidr"
}

variable "availability_zone" {
  type        = string
  description = "description"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "subnets cidr blocks for each cidr"
}

variable "open_ports" {
  type        = list(number)
  description = "ports for wordpress"
}

variable "instance_type" {
  type        = string
  description = "type for instance "
}

variable "ami" {
  type        = string
  description = "ami version for instance"
}
