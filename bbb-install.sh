#!/bin/bash

apt install ttf-mscorefonts-installer
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -v xenial-220 -s raion.praweb.ru -e himinec@praweb.ru -t -g

cd ~/greenlight
docker-compose down
cd ..
mv greenlight/ greenlight-old/
git clone https://github.com/MihailHiminec/greenlight.git
cd greenlight
git status
git remote add upstream https://github.com/bigbluebutton/greenlight.git
git fetch upstream
git checkout -b custom-changes upstream/v2
cp ~/greenlight-old/.env ~/greenlight/.env
sudo cp -r ~/greenlight-old/db ~/greenlight/
docker run --rm --env-file .env bigbluebutton/greenlight:v2 bundle exec rake conf:check
cd ~/greenlight
./scripts/image_build.sh bigbluebutton/greenlight release-v2
docker-compose up -d
