data "aws_ami" "app_ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["bitnami-nginx-*-x86_64-hvm-ebs-nami"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["979382823631"] # Bitnami
}


# Get default values, for curiosity.
data "aws_vpc" "default" {
  default =true
}

data "aws_availability_zones" "available" {}

resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  enable_dns_hostnames = "true"
  tags = {
    Name = "tf-example"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-west-2a"

  #Only the default VPC sets this automatically
  map_public_ip_on_launch = "true"


  tags = {
    Name = "tf-example"
  }
}

# Creating Internet Gateway 
resource "aws_internet_gateway" "mygateway" {
  vpc_id = aws_vpc.my_vpc.id
}

# Creating Route Table for Public Subnet
resource "aws_route_table" "rt" {
    vpc_id = aws_vpc.my_vpc.id

    tags = {
            Name = "Public Subnet Route Table"
        }
}

# Add route to route table. Cant do it in one or get Inappropriate value for attribute "route": set of object required.
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route
resource "aws_route" "my_route" {
        destination_cidr_block = "0.0.0.0/0"
        route_table_id  = aws_route_table.rt.id
        gateway_id = aws_internet_gateway.mygateway.id
}

resource "aws_route_table_association" "rt_associate_public" {
    subnet_id = aws_subnet.my_subnet.id
    route_table_id = aws_route_table.rt.id
}


resource "aws_security_group" "my" {
  name = "my_sg"
  description = "allow http"
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_vpc_security_group_ingress_rule" "http_in" {
# Start to end port range
  from_port  = "80"
  to_port    = "80"
  ip_protocol   = "tcp"
  cidr_ipv4  = "0.0.0.0/0"
  security_group_id =aws_security_group.my.id
}


resource "aws_vpc_security_group_ingress_rule" "https_in" {
  from_port  = "443"
  to_port    = "443"
  ip_protocol   = "tcp"
  cidr_ipv4  = "0.0.0.0/0"
  security_group_id =aws_security_group.my.id
}

resource "aws_vpc_security_group_egress_rule" "http_out" {
  from_port   = 0
  to_port     = 0
  ip_protocol    = "tcp"
  cidr_ipv4   = "0.0.0.0/0"
  security_group_id = aws_security_group.my.id
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.app_ami.id
  instance_type = "t3.nano"
  subnet_id     = aws_subnet.my_subnet.id

  vpc_security_group_ids = [aws_security_group.my.id]

  tags = {
    Name = "HelloWorld"
  }
}
