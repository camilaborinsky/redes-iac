// Crear VPC

resource "aws_vpc" "this" {
    cidr_block = "10.0.0.0/16"
    tags = {
    Name = "vpc"
 }
}

//Crear Subnets

resource "aws_subnet" "this" {
    count = length(local.availability_zones)
    vpc_id = aws_vpc.this.id
    cidr_block = "10.0.${count.index}.0/24"
    availability_zone = local.availability_zones[count.index]
    tags = {
    Name = "subnet"
    }
}


// Crear EC2

resource "aws_security_group" "ec2" {
    name = "ec2"
    description = "Allow inbound traffic"
    vpc_id = aws_vpc.this.id
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        security_groups = [aws_security_group.alb.id]
    }
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
  iam_instance_profile = aws_iam_instance_profile.this.name
  security_group_ids = [
    aws_security_group.ec2.id
  ]
  subnet_id         = aws_subnet.this[count.index].id
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
    vpc_id = aws_vpc.this.id
    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [""]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = [""]
    }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = [""]
    }
    tags = {
        Name = "alb"
    }
}

// Crear ALB

module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 6.0"

  name = "api-alb"

  load_balancer_type = "application"

  vpc_id          = aws_vpc.this.id
  subnets         = [aws_subnet.s1.id, aws_subnet.s2.id]
  security_groups = [aws_security_group.alb.id]

    // access logs (requiere un s3 bucket)

  //dynamic block over ec2 instances for target groups

  dynamic "target_group" {
    for_each = module.ec2-api.instances
    content {
      name_prefix = "api-tg"
      port        = 80
      protocol    = "HTTP"
      vpc_id      = aws_vpc.this.id

      health_check {
        healthy_threshold   = 2
        unhealthy_threshold = 2
        timeout             = 3
        interval            = 30
        path                = "/"
        matcher             = "200"
      }

      target_type = "instance"

      deregistration_delay = 300

      stickiness {
        type    = "lb_cookie"
        enabled = true
      }

      tags = {
        Name = "api-tg"
      }

      dynamic "target_group_attachment" {
        for_each = module.ec2-api.instances
        content {
          target_group_arn = target_group.value.arn
          target_id        = target_group_attachment.value.instance_id
          port             = 80
        }
      }
    }
  }

}