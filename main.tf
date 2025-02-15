### all the has been written with snakecase
### vpc
resource "aws_vpc" "wordpress_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "wordpress-vpc"
  }
}

### internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.wordpress_vpc.id

  tags = {
    Name = "wordpress_igw"
  }
}

### public subnets
resource "aws_subnet" "public_subnet" {
  for_each = local.public_subnet

  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = each.value["subnet_cidr"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = true

  tags = {
    Name = each.value["Name"]
  }
}

### private subnets
resource "aws_subnet" "private_subnet" {
  for_each = local.private_subnet

  vpc_id                  = aws_vpc.wordpress_vpc.id
  cidr_block              = each.value["subnet_cidr"]
  availability_zone       = each.value["availability_zone"]
  map_public_ip_on_launch = false

  tags = {
    Name = each.value["Name"]
  }
}

### route table
resource "aws_route_table" "wordpress-rt" {
  vpc_id = aws_vpc.wordpress_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }

  tags = {
    Name = "wordpress-rt"
  }
}

### route tables
resource "aws_route_table_association" "public_association" {
  for_each        = aws_subnet.public_subnet
  subnet_id       = each.value.id
  route_table_id = aws_route_table.wordpress-rt.id
}

### security_groups
resource "aws_security_group" "wordpress-sg" {
  name        = "wordpress-sg"
  description = "allows some ports"
  vpc_id      = aws_vpc.wordpress_vpc.id

  dynamic "ingress" {
    for_each = toset(var.open_ports)
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wordpress-sg"
  }
}

resource "aws_security_group" "rds-sg" {
  name        = "rds-sg"
  description = "Allow MySQL access from WordPress EC2"
  vpc_id      = aws_vpc.wordpress_vpc.id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    security_groups = [aws_security_group.wordpress-sg.id]
  }
  
  tags = {
    Name = "rds-sg"
  }
}


### ssh key
resource "aws_key_pair" "wordpress-sshkey" {
  key_name   = "wordpress-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINSgOlXaKs6C0tKjU6w6UwEgILWUpVNmqECqQNG+w1yD temirlansatarov@Temirlans-MacBook-Air.local"
}

### instances
resource "aws_instance" "wordpress-ec2" {
  instance_type   = var.instance_type
  ami             = var.ami
  vpc_security_group_ids = [aws_security_group.wordpress-sg.id]
  ###modify somelines here
  for_each      = aws_subnet.public_subnet
  subnet_id       = each.value.id
  key_name        = aws_key_pair.wordpress-sshkey.key_name

  tags = {
    Name = "wordpress-ec2"
  }
}



### mysql db 
resource "aws_db_instance" "mysql" {
  identifier             = "mysql"
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  username               = "admin"
  password               = "adminadmin"
  db_subnet_group_name   = aws_db_subnet_group.mysql_subnet_group.name
  vpc_security_group_ids = [aws_security_group.rds-sg.id]

  skip_final_snapshot = true # Set to `false` if you want backups before deletion

  tags = {
    Name = "mysql"
  }
}


resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "mysql_subnet_group"
  subnet_ids = [for subnet in aws_subnet.private_subnet : subnet.id]

  tags = {
    Name = "mysql_subnet_group"
  }
}