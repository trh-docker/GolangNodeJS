FROM quay.io/spivegin/tlmbasedebian:latest as base

RUN rm /bin/sh && cp /bin/bash /bin/sh

FROM base

RUN mkdir /opt/tmp /opt/src
ENV GOPATH=/opt/src/ \
    GOBIN=/opt/go/bin \
    PATH=/opt/go/bin:$PATH \
    GO_VERSION=1.13

ADD https://storage.googleapis.com/golang/go${GO_VERSION}.linux-amd64.tar.gz /opt/tmp/
ADD ./files/dep-linux-amd64 /opt/tmp/dep

RUN apt-get update && apt-get install -y unzip curl sudo git &&\
    tar -C /opt/ -xzf /opt/tmp/go${GO_VERSION}.linux-amd64.tar.gz &&\
    mv /opt/tmp/dep /opt/go/bin/dep &&\
    chmod +x /opt/go/bin/* &&\
    ln -s /opt/go/bin/* /bin/ &&\
    rm /opt/tmp/go${GO_VERSION}.linux-amd64.tar.gz &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
    
RUN apt-get update && apt-get install -y gcc gnupg2 tar git curl wget apt-transport-https ca-certificates build-essential &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add &&\
    echo 'deb https://deb.nodesource.com/node_12.x stretch main' > /etc/apt/sources.list.d/nodesource.list &&\
    echo 'deb-src https://deb.nodesource.com/node_12.x stretch main' >> /etc/apt/sources.list.d/nodesource.list &&\
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update && apt-get install -y nodejs yarn &&\
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.34.0/install.sh | bash &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*

ENV NVM_DIR /opt/nvm
ENV NODE_VERSION 10.11

# Install nvm with node and npm
ADD files/nvm_install.sh /opt/tmp/
RUN chmod +x /opt/tmp/nvm_install.sh \
    && /opt/tmp/nvm_install.sh | bash \
    && source $NVM_DIR/nvm.sh \
    && nvm install $NODE_VERSION \
    && nvm alias default $NODE_VERSION \
    && nvm use default

ENV NODE_PATH $NVM_DIR/v$NODE_VERSION/lib/node_modules
ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH


#CMD {"/bin/bash"}
