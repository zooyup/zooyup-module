module "vpc" {
  source = "./modules/vpc"

  vpc_name      = var.project_name
  cidr_block    = "10.0.0.0/16"  # VPC: 10.0.0.0/16
  igw           = true
  nat           = true
  nat_count     = 1

  public_cidr   = ["10.0.1.0/24", "10.0.2.0/24"]  # 10.0.1.x, 10.0.2.x
  private_cidr  = ["10.0.11.0/24", "10.0.12.0/24"] # 10.0.11.x, 10.0.12.x
  db_cidr      = ["10.0.21.0/24", "10.0.22.0/24"] # 10.0.21.x, 10.0.22.x
  azs           = ["ap-northeast-2a", "ap-northeast-2c"]

  vpc_tags = {
    Owner = var.project_name
    Make  = "terraform"
  }

  subnet_tags = {
    Env = var.project_name
  }
}
