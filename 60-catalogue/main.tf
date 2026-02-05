# create EC2 instance 

resource "aws_instance" "catalogue" {  #Terraform creates the MongoDB EC2 instance.
    ami= local.ami_id
    instance_type="t3.micro"
    vpc_security_group_ids = [local.catalogue_sg_id]
    subnet_id = local.private_subnet_id
    tags = merge (
        local.common_tags,
        {
            Name="${local.common_name_suffix}-catalogue"  # roboshop-dev-catalogue
        }
    )
  
}

# connect to instance using remote-exec provisioner through terraform_data

##Because of triggers_replace, the terraform_data.catalogue resource is tied to that EC2 instance.
resource "terraform_data" "catalogue" {
  triggers_replace = [
    aws_instance.catalogue.id   
  ]
 # Terraform connects to the catalogue instance via SSH (connection block).
connection {
      type        = "ssh"      
      user        = "ec2-user"
      password = "DevOps321"
      host = aws_instance.catalogue.private_ip      
    }


# File provisioner copies catalogue.sh from your local machine to /tmp/catalogue.sh on the catalogue server.
provisioner "file" {
source = "catalogue.sh" # Local file path
destination = "/tmp/catalogue.sh" # Destination on EC2
}
# Remote‑exec provisioner runs commands inside the catalogue server:
  provisioner "remote-exec" {
    inline = [ 
         "chmod +x /tmp/catalogue.sh",        
        "sudo sh /tmp/catalogue.sh catalogue ${var.environment}"
     ]
  }
}

# stop the instance to take the image
resource "aws_ec2_instance_state" "catalogue" {
  instance_id = aws_instance.catalogue.id
  state       = "stopped"
  depends_on = [ terraform_data.catalogue ]
}

resource "aws_ami_from_instance" "catalogue" {
  name               = "${local.common_name_suffix}-catalogue-ami"
  source_instance_id = aws_instance.catalogue.id
  depends_on = [ aws_ec2_instance_state.catalogue ]

      tags = merge (
        local.common_tags,
        {
            Name="${local.common_name_suffix}-catalogue-ami"  # roboshop-dev-catalogue
        }
    )
}