#! /bin/bash
set -e
echo "  ----- clone git repo -----"
cd && git clone https://github.com/ThoughtWorksInc/infra-problem.git
echo "  ----- Building Application -----"
cd /home/developer/infra-problem && make libs
make clean all && cd -
echo "  ----- Staring  Docker Composer -----"
dir=/home/developer/infra-problem/build
cd /home/developer/deploy && cp quoteDockerfile $dir
cp frontendDockerfile $dir
cp newsfeedDockerfile $dir
cp docker-compose.yml $dir
cd $dir && sudo docker-compose up -d
