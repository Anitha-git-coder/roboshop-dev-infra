resource "aws_instance" "mongodb" {  #Terraform creates the MongoDB EC2 instance.
    ami= local.ami_id
    instance_type="t3.micro"
    vpc_security_group_ids = [local.mongodb_sg_id]
    subnet_id = local.database_subnet_id
    tags = merge (
        local.common_tags,
        {
            Name="${local.common_name_suffix}-mongodb"  # roboshop-dev-mongodb
        }
    )
  
}

##Because of triggers_replace, the terraform_data.mongodb resource is tied to that EC2 instance.
resource "terraform_data" "mongodb" {
  triggers_replace = [
    aws_instance.mongodb.id   
  ]
 # Terraform connects to the MongoDB instance via SSH (connection block).
connection {
      type        = "ssh"      
      user        = "ec2-user"
      password = "DevOps321"
      host = aws_instance.mongodb.private_ip      
    }


# File provisioner copies bootstrap.sh from your local machine to /tmp/bootstrap.sh on the MongoDB server.
provisioner "file" {
source = "bootstrap.sh" # Local file path
destination = "/tmp/bootstrap.sh" # Destination on EC2
}
# Remote‑exec provisioner runs commands inside the MongoDB server:
  provisioner "remote-exec" {
    inline = [ 
         "chmod +x /tmp/bootstrap.sh",        
        "sudo sh /tmp/bootstrap.sh mongodb"
     ]
  }
}


#redis

resource "aws_instance" "redis" {
    ami= local.ami_id
    instance_type="t3.micro"
    vpc_security_group_ids = [local.redis_sg_id]
    subnet_id = local.database_subnet_id
    tags = merge (
        local.common_tags,
        {
            Name="${local.common_name_suffix}-redis"  # roboshop-dev-redis
        }
    )
  
}

resource "terraform_data" "redis" {
  triggers_replace = [
    aws_instance.redis.id
  ]

connection {
      type        = "ssh"      
      user        = "ec2-user"
      password = "DevOps321"
      host = aws_instance.redis.private_ip      
    }

#     # Terraform copies this file to redis server
provisioner "file" {
source = "bootstrap.sh" # Local file path
destination = "/tmp/bootstrap.sh" # Destination on EC2
}
  provisioner "remote-exec" {
    inline = [ 
         "chmod +x /tmp/bootstrap.sh",        
        "sudo sh /tmp/bootstrap.sh redis"
     ]
  }
}

# RabbitMQ

resource "aws_instance" "rabbitmq" {
    ami= local.ami_id
    instance_type="t3.micro"
    vpc_security_group_ids = [local.rabbitmq_sg_id]
    subnet_id = local.database_subnet_id
    tags = merge (
        local.common_tags,
        {
            Name="${local.common_name_suffix}-rabbitmq"  # roboshop-dev-rabbitmq
        }
    )
  
}

resource "terraform_data" "rabbitmq" {
  triggers_replace = [
    aws_instance.rabbitmq.id
  ]

connection {
      type        = "ssh"      
      user        = "ec2-user"
      password = "DevOps321"
      host = aws_instance.rabbitmq.private_ip      
    }

#     # Terraform copies this file to rabbitmq server
provisioner "file" {
source = "bootstrap.sh" # Local file path
destination = "/tmp/bootstrap.sh" # Destination on EC2
}
  provisioner "remote-exec" {
    inline = [ 
         "chmod +x /tmp/bootstrap.sh",        
        "sudo sh /tmp/bootstrap.sh rabbitmq"
     ]
  }
}

# MySql

resource "aws_instance" "mysql" {
    ami= local.ami_id
    instance_type="t3.micro"
    vpc_security_group_ids = [local.mysql_sg_id]
    subnet_id = local.database_subnet_id
    iam_instance_profile = aws_iam_instance_profile.mysql.name
    tags = merge (
        local.common_tags,
        {
            Name="${local.common_name_suffix}-mysql"  # roboshop-dev-mysql
        }
    )
  
}

resource "aws_iam_instance_profile" "mysql" {
  name = "mysql"
  role = "EC2SSMParameterRead"
}

resource "terraform_data" "mysql" {
  triggers_replace = [
    aws_instance.mysql.id
  ]

connection {
      type        = "ssh"      
      user        = "ec2-user"
      password = "DevOps321"
      host = aws_instance.mysql.private_ip      
    }

#     # Terraform copies this file to mysql server
provisioner "file" {
source = "bootstrap.sh" # Local file path
destination = "/tmp/bootstrap.sh" # Destination on EC2
}
  provisioner "remote-exec" {
    inline = [ 
         "chmod +x /tmp/bootstrap.sh",        
        "sudo sh /tmp/bootstrap.sh mysql dev"
     ]
  }
}


resource "aws_route53_record" "mongodb" {
  zone_id = var.zone_id
  name    = "mongodb-${var.environment}.${var.domain_name}" # mongodb.dev.anitha.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.mongodb.private_ip]
  allow_overwrite = true

}


resource "aws_route53_record" "redis" {
  zone_id = var.zone_id
  name    = "redis-${var.environment}.${var.domain_name}" # redis.dev.anitha.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.redis.private_ip]
  allow_overwrite = true
}


resource "aws_route53_record" "mysql" {
  zone_id = var.zone_id
  name    = "mysql-${var.environment}.${var.domain_name}" # mysql.dev.anitha.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.mysql.private_ip]
   allow_overwrite = true

}


resource "aws_route53_record" "rabbitmq" {
  zone_id = var.zone_id
  name    = "rabbitmq-${var.environment}.${var.domain_name}" # rabbitmq.dev.anitha.fun
  type    = "A"
  ttl     = 1
  records = [aws_instance.rabbitmq.private_ip]
  allow_overwrite = true
}








