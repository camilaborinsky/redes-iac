
data "aws_region" "current" {}

// Crear VPC
module "vpc" {
  source     = "../vpc"
  name       = var.vpc_name
  cidr_block = var.vpc_cidr
}

module "ig" {
  source = "../internet_gateway"
  vpc_id = module.vpc.id
  name   = "ig-redes"
}

module "nat_gw" {
  count     = length(local.availability_zones)
  source    = "../nat_gateway"
  name      = "nat-gw-${count.index}"
  subnet_id = module.public-subnets[count.index].id
}

//Crear private subnets
module "private-subnets" {
  count             = length(local.availability_zones)
  source            = "../subnet"
  availability_zone = local.availability_zones[count.index]
  name              = "private-subnet-${count.index}"
  vpc_id            = module.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  ng_id             = module.nat_gw[count.index].id
}

// Crear public subnets
module "public-subnets" {
  count             = length(local.availability_zones)
  source            = "../subnet"
  availability_zone = local.availability_zones[count.index]
  name              = "public-subnet-${count.index}"
  vpc_id            = module.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, length(local.availability_zones) + count.index)
  ig_id             = module.ig.id
}


// Crear EC2

resource "aws_security_group" "ec2" {
    name = "ec2"
    description = "Allow inbound traffic"
    vpc_id = module.vpc.id

    ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    # ingress {
    #     from_port = 80
    #     to_port = 80
    #     protocol = "tcp"
    #     security_groups = [aws_security_group.alb.id]
    # }
    # ingress {
    #     from_port = 443
    #     to_port = 443
    #     protocol = "tcp"
    #     security_groups = [aws_security_group.alb.id]
    # }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "ec2"
    }
}

module "ec2-api" {
    count = length(local.availability_zones)
  source = "../ec2"

  //iam_instance_profile = aws_iam_instance_profile.this.name
  security_group_ids = [
    aws_security_group.ec2.id
  ]
  subnet_id         = module.private-subnets[count.index].id
  instance_name     = "express-api-${count.index}"
  instance_type     = "t2.micro"
  public_ip_address = true
  root_volume_size  = 30
  root_volume_type  = "gp2"
  user_data_path    = "user-data.sh"
  tags = {
    Name = "express-api-${count.index}"
    CreatedBy = "terraform"
  }
}


resource "aws_security_group" "alb" {
    name = "alb"
    description = "Allow inbound traffic"
    vpc_id = module.vpc.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "alb-sg"
    }
}

# // Crear ALB

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"
  name    = "redes-alb-${data.aws_region.current.name}"

  load_balancer_type = "application"

  vpc_id  = module.vpc.id
  subnets = [for s in module.public-subnets : s.id]
  security_groups    = [aws_security_group.alb.id]

  # access_logs = {
  #   bucket = "redes-alb-logs"
  # }

  target_groups = [
    {
      name_prefix      = "api-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        for idx, instance in module.ec2-api : "instance_${idx + 1}" => {
          target_id = instance.instance_id
          port      = var.ec2_api_port
        }
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  tags = {
    Name = "redes-alb"
  }
}