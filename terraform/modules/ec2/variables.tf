
variable "instance_type" {
    type = string
    description = "Instance type"
    default = "t2.micro"
}

variable "public_ip_address" {
    type = bool
    description = "Public IP address"
    default = true
}

variable "root_volume_size" {
    type = number
    description = "Root volume size for EC2 instance"
}

variable "root_volume_type" {
    type = string
    description = "Root volume type for EC2 instance"
    default = "gp2"
}

variable "security_group_ids" {
    type = list(string)
    description = "Security group IDs"
}

variable "subnet_id" {
    type = string
    description = "Subnet ID"
}

# variable "iam_instance_profile" {
#     type = string
#     description = "IAM instance profile"
# }

# variable "data_volume_size" {
#     type = number
#     description = "Data volume size for EC2 instance"
# }

# variable "data_volume_type" {
#     type = string
#     description = "Data volume type for EC2 instance"
#     default = "gp2"
# }

variable "user_data_path" {
    type = string
    description = "Path to user data script file"
}

variable "tags" {
    type = map
    description = "Tags for EC2 instance"
}

variable "instance_name" {
    type = string
    description = "EC2 Instance name"
}


