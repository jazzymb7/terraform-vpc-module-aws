module "vpc" {
  source = "./modules/vpc"
  vpc_config = [
    {
      vpc_cidr             = "10.0.0.0/16"
      public_subnet_cidr   = ["10.0.1.0/24", "10.0.2.0/24"]
      private_subnet_cidr  = ["10.0.3.0/24", "10.0.4.0/24"]
      public_subnet_names  = ["Public-Subnet1-VPC1", "Public-Subnet2-VPC1"]
      private_subnet_names = ["Private-Subnet1-VPC1", "Private-Subnet2-VPC1"]
      igwname              = "IGW1"
      public_routetablename = "public-rt1"
      private_routetablename = "private-rt1"
      vpcname              = "vpc1"
    },
    {
      vpc_cidr             = "10.1.0.0/16"
      public_subnet_cidr   = ["10.1.1.0/24", "10.1.2.0/24"]
      private_subnet_cidr  = ["10.1.3.0/24", "10.1.4.0/24"]
      public_subnet_names  = ["Public-Subnet1-VPC2", "Public-Subnet2-VPC2"]
      private_subnet_names = ["Private-Subnet1-VPC2", "Private-Subnet2-VPC2"]
      igwname              = "IGW2"
      public_routetablename = "public-rt2"
      private_routetablename = "private-rt2"
      vpcname              = "vpc2"
    }
  ]
}
