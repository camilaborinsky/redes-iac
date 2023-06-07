output id {
  value = "${aws_subnet.this.id}"
}

output name {
  value = aws_subnet.this.tags["Name"]
}

output cidr_block {
  value = "${aws_subnet.this.cidr_block}"
}