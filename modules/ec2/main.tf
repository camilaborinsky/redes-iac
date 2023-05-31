resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
# Create the Key Pair
resource "aws_key_pair" "key_pair" {
  key_name   = "${var.instance_name}_key_pair"  
  public_key = tls_private_key.key_pair.public_key_openssh
}
# Save file
resource "local_file" "ssh_key" {
  filename = "${aws_key_pair.key_pair.key_name}.pem"
  content  = tls_private_key.key_pair.private_key_pem
}


# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]  
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}



resource "aws_instance" "this"{
    ami = data.aws_ami.amazon-linux-2.id
    instance_type = var.instance_type
    subnet_id = var.subnet_id
    vpc_security_group_ids = var.security_group_ids
    source_dest_check = false
    key_name = aws_key_pair.key_pair.key_name
    iam_instance_profile = var.iam_instance_profile

    associate_public_ip_address = true

    user_data = file(var.user_data_path)

    root_block_device {
        volume_size = var.root_volume_size
        volume_type = var.root_volume_type
        delete_on_termination = true
        encrypted = true
    }

    tags = var.tags

    lifecycle {
      ignore_changes = [
        ami
      ]
    }
}




