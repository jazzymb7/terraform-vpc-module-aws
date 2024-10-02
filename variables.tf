variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR"
}

variable "subnet_cidr" {
  type = list(string)
}