#!/bin/bash
set -e

echo "  ----- install Java -----  "
apt-get update
apt-get install default-jre -y
echo "  ----- install make -----   "
apt-get install make
echo "  ----- install lein -----   "
curl https://raw.githubusercontent.com/technomancy/leiningen/stable/bin/lein >>lein
sudo mv lein /bin
sudo chmod a+x /bin/lein
lein
echo "  ----- install docker -----"
apt-get install docker.io -y
echo "  ----- install docker-composer -----"
curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
