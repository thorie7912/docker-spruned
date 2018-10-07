FROM ubuntu:bionic
MAINTAINER Takahiro Horie <tak@thorie.com>

ARG USER_ID
ARG GROUP_ID

ENV HOME /bitcoin

# add user with specified (or default) user/group ids
ENV USER_ID ${USER_ID:-1000}
ENV GROUP_ID ${GROUP_ID:-1000}

# add our user and group first to make sure their IDs get assigned consistently, regardless of whatever dependencies get added
RUN groupadd -g ${GROUP_ID} bitcoin \
	&& useradd -u ${USER_ID} -g bitcoin -s /bin/bash -m -d /bitcoin bitcoin

RUN apt-get update && apt-get install -y --no-install-recommends \
    unzip \
    libleveldb-dev \
    python3-dev \
    virtualenv \
    gcc \
    wget \
    g++ \
    python3-pip \
    git

RUN git clone https://github.com/gdassori/spruned.git spruned
RUN cd spruned && \
    git checkout 43e197693278fd551b165c6cfa5de78f853ef554 && \
    pip install -r requirements.txt

RUN wget https://github.com/gdassori/spruned/archive/master.zip
RUN unzip master.zip 
RUN cd spruned-master && \
    virtualenv -p python3.6 venv && \
    . venv/bin/activate && \
    pip3 install -r requirements.txt && \
    python setup.py install

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7

RUN apt-get install -y gnupg2

RUN set -x \
	&& apt-get install -y --no-install-recommends \
		ca-certificates \
		wget \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg2 --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg2 --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -r "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true \
	&& apt-get purge -y \
		ca-certificates \
		wget \
	&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN apt-get update && apt-get install -y iputils-ping

ADD ./bin /usr/local/bin

VOLUME ["/bitcoin"]

EXPOSE 8332 8333 18332 18333

WORKDIR /bitcoin

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

CMD ["btc_oneshot"]
