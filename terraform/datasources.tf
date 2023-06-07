// Datasources
// Get AWS available AZ
data "aws_availability_zones" "available" {
  state = "available"
}

