#!/bin/bash
yum update -y
yum install git nodejs -y
cat > /tmp/startup.sh << EOF
# START
echo "Setting up NodeJS Environment"
curl https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash

echo 'export NVM_DIR="/home/ec2-user/.nvm"' >> /home/ec2-usr/.bashrc
echo '[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm' >> /home/ec2-user/.bashrc

# Dot source the files to ensure that variables are available within the current shell
. /home/ec2-user/.nvm/nvm.sh
. /home/ec2-user/.bashrc

# Install NVM, NPM, Node.JS & Grunt
nvm alias defaultv16.11.1
nvm install v16.11.1
nvm use v16.11.1

git clone https://github.com/camilaborinsky/redes-iac.git
cd redes-iac/express-api
npm install
nohup npm start > app.log 2>&1 &
EOF

chown ec2-user:ec2-user /tmp/startup.sh && chmod a+x /tmp/startup.sh
sleep 1; su - ec2-user -c "/tmp/startup.sh"