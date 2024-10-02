variable "vpc_config" {
  description = "List of VPC configurations"
  type = list(object({
    vpc_cidr     = string
    public_subnet_cidr  = list(string)
    private_subnet_cidr = list(string)
    public_subnet_names = list(string)
    private_subnet_names = list(string)
    vpcname = string
    public_routetablename = string
    private_routetablename = string
    igwname = string
  }))
}
