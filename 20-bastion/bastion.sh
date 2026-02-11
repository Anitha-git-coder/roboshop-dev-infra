#!/bin/bash

# growing the /home volume for terraform purpose
growpart /dev/nvme0n1 4
lvextend -L +30G /dev/mapper/RootVG-homeVol
xfs_growfs /home

sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# sudo lvreduce -r -L 6G /dev/mapper/RootVG-rootVol

# creating databases
cd /home/ec2-user
git clone https://github.com/Anitha-git-coder/roboshop-dev-infra.git
chown ec2-user:ec2-user -R roboshop-dev-infra
cd roboshop-dev-infra/40-databases
terraform init
terraform apply -auto-approve












# #!/bin/bash

# # growing the /home volume for terraform purpose
# growpart /dev/nvme0n1 4
# lvextend -L +30G /dev/mapper/RootVG-homeVol
# xfs_growfs /home

# sudo yum install -y yum-utils 
# sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
# sudo yum install terraform

# REPO_URL=https://github.com/Anitha-git-coder/ansible-roboshop-roles-tf.git
# REPO_DIR=/opt/roboshop/ansible/
# ANSIBLE_DIR=ansible-roboshop-roles-tf

# mkdir -p $REPO_DIR
# mkdir -p /var/log/roboshop/
# touch ansible.log

# cd $REPO_DIR
# # check if ansible already clone or not

# if [ -d $ANSIBLE_DIR ]; then
 
#  cd $ANSIBLE_DIR #open the dir
#  git pull  
#  else
#  git clone $REPO_URL 
#  cd $ANSIBLE_DIR 
#  fi

#  ansible-playbook -e component=$component main.yaml