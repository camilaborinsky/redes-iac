resource "aws_subnet" "this" {

  vpc_id = var.vpc_id
  cidr_block = var.cidr_block
  availability_zone = var.availability_zone
  tags={
    Name = var.name
  }
}
resource "aws_route_table" "this" {
  vpc_id = var.vpc_id
}

resource "aws_route" "default" {
  route_table_id = aws_route_table.this.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = var.ng_id
  gateway_id = var.ig_id
}

resource "aws_route_table_association" "this" {
  subnet_id = aws_subnet.this.id
  route_table_id = aws_route_table.this.id
}