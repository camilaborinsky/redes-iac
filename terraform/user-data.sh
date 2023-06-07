#!/bin/bash
sudo apt-get update
sudo apt-get install -y nodejs npm git
git clone https://github.com/camilaborinsky/redes-iac.git
cd redes-iac/express-api
npm install
nohup npm start > app.log 2>&1 &
