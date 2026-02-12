variable "project_name" {
    default = "roboshop"  
}

variable "environment" {
    default = "dev"  
}

variable "component" {
  default = "catalogue" 
}

variable "rule_priority" {
  default = "10" 

}

variable "components" {
  default = {

catalogue = {
  rule_priority=10
}
user = {
  rule_priority=20
}
cart = {
  rule_priority = 30
}
shipping = {
  rule_priority = 40
}
payment = {
  rule_priority = 50
}
frontend = { #alb is different so we can give 10
  rule_priority =10
}
  }
   
}