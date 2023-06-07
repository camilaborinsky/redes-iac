

resource "aws_eip" "nat" {
  vpc = true
  tags = {
    Name = "nat-${var.name}"
  }
}

resource "aws_nat_gateway" "this"{
    subnet_id = var.subnet_id
    allocation_id = aws_eip.nat.id
    tags = {
        Name = var.name
    }
}