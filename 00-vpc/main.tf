module "vpc" {    
      source  = "git::https://github.com/Anitha-git-coder/terraform-aws-vpc.git?ref=main"  
  vpc_cidr = var.vpc_cidr
  project_name = var.project_name
  environment = var.environment
  vpc_tags = var.vpc_tags

  #subnet_id = local.public_subnet_id
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
  is_peering_required = true
}


