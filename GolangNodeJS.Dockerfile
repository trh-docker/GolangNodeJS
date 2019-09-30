FROM quay.io/spivegin/tlmbasedebian


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
    
RUN apt-get update && apt-get install -y gcc gnupg2 tar git curl wget apt-transport-https ca-certificates build-essential
RUN curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | sudo apt-key add && echo 'deb https://deb.nodesource.com/node_10.x stretch main' > /etc/apt/sources.list.d/nodesource.list && echo 'deb-src https://deb.nodesource.com/node_10.x stretch main' >> /etc/apt/sources.list.d/nodesource.list &&\
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - &&\
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list &&\
    apt-get update && apt-get install -y nodejs yarn &&\
    apt-get autoclean && apt-get autoremove &&\
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*
