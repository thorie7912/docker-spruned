Spruned for Docker
===================

This is based off kylemanna/docker-bitcoind (status below)

[![Docker Stars](https://img.shields.io/docker/stars/kylemanna/bitcoind.svg)](https://hub.docker.com/r/kylemanna/bitcoind/)
[![Docker Pulls](https://img.shields.io/docker/pulls/kylemanna/bitcoind.svg)](https://hub.docker.com/r/kylemanna/bitcoind/)
[![Build Status](https://travis-ci.org/kylemanna/docker-bitcoind.svg?branch=master)](https://travis-ci.org/kylemanna/docker-bitcoind/)
[![ImageLayers](https://images.microbadger.com/badges/image/kylemanna/bitcoind.svg)](https://microbadger.com/#/images/kylemanna/bitcoind)

Docker image that runs the Bitcoin spruned node in a container for easy deployment.


Requirements
------------

* Physical machine, cloud instance, or VPS that supports Docker (i.e. [Vultr](http://bit.ly/1HngXg0), [Digital Ocean](http://bit.ly/18AykdD), KVM or XEN based VMs) running Ubuntu 14.04 or later (*not OpenVZ containers!*)
* ~At least 100 GB to store the block chain files (and always growing!)~ 100 MEGAbytes or even less based on config
* At least 1 GB RAM + 2 GB swap file




Quick Start
-----------

1. Create a `spruned-data` volume to persist the spruned blockchain data, should exit immediately.  The `spruned-data` container will store the minimal blockchain when the node container is recreated (software upgrade, reboot, etc):

        docker volume create --name=spruned-data
        docker run -v spruned-data:/spruned --name=spruned-node -d \
            -p 8333:8333 \
            -p 127.0.0.1:8332:8332 \
            thorie7912/spruned

2. Verify that the container is running and spruned node is downloading the blockchain

        $ docker ps
        CONTAINER ID        IMAGE                         COMMAND             CREATED             STATUS              PORTS                                              NAMES
        d0e1076b2dca        thorie7912/spruned:latest     "btc_oneshot"       2 seconds ago       Up 1 seconds        127.0.0.1:8332->8332/tcp, 0.0.0.0:8333->8333/tcp   spruned-node

3. You can then access the daemon's output thanks to the [docker logs command]( https://docs.docker.com/reference/commandline/cli/#logs)

        docker logs -f spruned-node

4. Install optional init scripts for upstart and systemd are in the `init` directory.


Documentation
-------------

* Additional documentation in the [docs folder](docs).
