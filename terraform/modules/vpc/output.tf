output "name" {
    description = "The name of the vpc"
    value = aws_vpc.this.tags["Name"]
}

output "id" {
    description = "The id of the vpc"
    value = aws_vpc.this.id
}