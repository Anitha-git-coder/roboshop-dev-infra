# #!/bin/bash

# dnf install ansible -y
# ansible pull -U https://github.com/Anitha-git-coder/ansible-roboshop-roles-terraform.git -e component = mongodb main.yaml

#!/bin/bash

component=$1
dnf install ansible -y
ansible-pull -U https://github.com/Anitha-git-coder/ansible-roboshop-roles-terraform.git main.yaml -e component=$component
