// Crear VPC
module "vpc" {
  source     = "./modules/vpc"
  name       = var.vpc_name
  cidr_block = var.vpc_cidr
}

module "ig" {
  source = "./modules/internet_gateway"
  vpc_id = module.vpc.id
  name   = "ig-redes"
}

module "nat_gw" {
  count     = length(local.availability_zones)
  source    = "./modules/nat_gateway"
  name      = "nat-gw-${count.index}"
  subnet_id = module.public-subnets[count.index].id
}

//Crear private subnets
module "private-subnets" {
  count             = length(local.availability_zones)
  source            = "./modules/subnet"
  availability_zone = local.availability_zones[count.index]
  name              = "private-subnet-${count.index}"
  vpc_id            = module.vpc.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index)
  ng_id             = module.nat_gw[count.index].id
}

// Crear public subnets
module "public-subnets" {
  count             = length(local.availability_zones)
  source            = "./modules/subnet"
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
  source = "./modules/ec2"

  providers = {
    aws = aws.aws
  }
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


# resource "aws_security_group" "alb" {
#     name = "alb"
#     description = "Allow inbound traffic"
#     vpc_id = aws_vpc.this.id
#     ingress {
#         from_port = 80
#         to_port = 80
#         protocol = "tcp"
#         cidr_blocks = [""]
#     }
#     ingress {
#         from_port = 443
#         to_port = 443
#         protocol = "tcp"
#         cidr_blocks = [""]
#     }
#     egress {
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = [""]
#     }
#     tags = {
#         Name = "alb"
#     }
# }

# // Crear ALB

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 8.0"
  name    = "redes-alb"

  load_balancer_type = "application"

  vpc_id  = module.vpc.id
  subnets = [for s in module.private-subnets : s.id]
  # security_groups    = ["sg-edcd9784", "sg-edcd9785"]

  access_logs = {
    bucket = "redes-alb-logs"
  }

  target_groups = [
    {
      name_prefix      = "api-"
      backend_protocol = "HTTP"
      backend_port     = 80
      target_type      = "instance"
      targets = {
        for idx, instance in module.ec2-api : "instance_${idx + 1}" => {
          target_id = instance.id
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

# module "alb" {
#   source  = "terraform-aws-modules/alb/aws"
#   version = "~> 6.0"

#   name = "api-alb"

#   load_balancer_type = "application"

#   vpc_id          = aws_vpc.this.id
#   subnets         = [aws_subnet.s1.id, aws_subnet.s2.id]
#   security_groups = [aws_security_group.alb.id]

#     // access logs (requiere un s3 bucket)

#   //dynamic block over ec2 instances for target groups

#   dynamic "target_group" {
#     for_each = module.ec2-api.instances
#     content {
#       name_prefix = "api-tg"
#       port        = 80
#       protocol    = "HTTP"
#       vpc_id      = aws_vpc.this.id

#       health_check {
#         healthy_threshold   = 2
#         unhealthy_threshold = 2
#         timeout             = 3
#         interval            = 30
#         path                = "/"
#         matcher             = "200"
#       }

#       target_type = "instance"

#       deregistration_delay = 300

#       stickiness {
#         type    = "lb_cookie"
#         enabled = true
#       }

#       tags = {
#         Name = "api-tg"
#       }

#       dynamic "target_group_attachment" {
#         for_each = module.ec2-api.instances
#         content {
#           target_group_arn = target_group.value.arn
#           target_id        = target_group_attachment.value.instance_id
#           port             = 80
#         }
#       }
#     }
#   }

# }