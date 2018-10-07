#!/bin/bash

#uncomment this if building an image
#docker build . --tag spruned:latest

#uncomment this if running first time
#docker volume create --name=spruned-data

docker run -v spruned-data:/spruned --name=spruned-node -d \
    -p 8333:8333 \
    -p 127.0.0.1:8332:8332 \
    spruned:latest 
