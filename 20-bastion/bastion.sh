#!/bin/bash

sudo yum install -y yum-utils 
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
sudo yum install terraform

REPO_URL=https://github.com/Anitha-git-coder/ansible-roboshop-roles-tf.git
REPO_DIR=/opt/roboshop/ansible/
ANSIBLE_DIR=ansible-roboshop-roles-tf

mkdir -P $REPO_DIR
mkdir -p /var/log/roboshop/
touch ansible.log

cd $REPO_DIR
# check if ansible already clone or not

if[ -d $ANSIBLE_DIR ]; then
 
 cd $ANSIBLE_DIR #open the dir
 git pull  
 else
 git clone $REPO_URL 
 cd $ANSIBLE_DIR 
 fi

 ansible-playbook -e component=$component main.yaml