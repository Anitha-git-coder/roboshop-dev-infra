locals {
  common_name_suffix = "${var.project_name}-${var.environment}" #--roboshop-dev 
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  frontend_alb_sg_id = data.aws_ssm_parameter.frontend_alb_sg_id.value
  frontend_alb_certificate_arn = data.aws_ssm_parameter.frontend_alb_certificate_arn.value
  
   public_subnet_ids = [
  for s in split(",", data.aws_ssm_parameter.public_subnet_ids.value) : trimspace(s)
   ]
  common_tags = {
    project_name= var.project_name
    environment= var.environment
    terraform = true
  }
  }
  