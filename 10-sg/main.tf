module "catalogue" {
  source = "terraform-aws-modules/security-group/aws"
 
  name = "${local.common_name_suffix} -catalogue" 
  use_name_prefix   = false 
  description = "security group for catalogue with custom ports open within vpc, egress all traffic"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
}


