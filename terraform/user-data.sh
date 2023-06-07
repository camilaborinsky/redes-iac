#!/bin/bash
sudo yum update
sudo yum install -y nodejs git
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
. ~/.nvm/nvm.sh
nvm install v16.11.1
git clone https://github.com/camilaborinsky/redes-iac.git
cd redes-iac/express-api
npm install
nohup npm start > app.log 2>&1 &
