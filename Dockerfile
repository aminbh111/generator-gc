FROM ubuntu:trusty

ENV JAVA_VERSION 8
ENV JAVA_HOME /usr/lib/jvm/java-${JAVA_VERSION}-oracle

RUN \
  # configure the "greencode" user
  groupadd greencode && \
  useradd greencode -s /bin/bash -m -g greencode -G sudo && \
  echo 'greencode:greencode' |chpasswd && \
  mkdir /home/greencode/app && \

  # install oracle jdk 8
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" >> /etc/apt/sources.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys C2518248EEA14886 && \
  apt-get update && \
  echo oracle-java${JAVA_VERSION}-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && \
  apt-get install -y --force-yes --no-install-recommends \
    oracle-java${JAVA_VERSION}-installer \
    oracle-java${JAVA_VERSION}-set-default && \

  # install utilities
  apt-get install -y \
     wget \
     curl \
     vim \
     git \
     zip \
     bzip2 \
     fontconfig \
     python \
     g++ \
     build-essential && \

  # install node.js
  curl -sL https://deb.nodesource.com/setup_4.x | sudo bash - && \
  apt-get install -y nodejs && \

  # upgrade npm
  npm install -g npm && \

  # install yeoman bower gulp
  npm install -g \
    yo \
    bower \
    gulp-cli

# copy sources
COPY . /home/greencode/generator-greencode

RUN \
  # install greencode
  npm install -g /home/greencode/generator-greencode && \

  # fix greencode user permissions
  chown -R greencode:greencode \
    /home/greencode \
    /usr/lib/node_modules && \

  # cleanup
  apt-get clean && \
  rm -rf \
    /var/lib/apt/lists/* \
    /tmp/* \
    /var/tmp/*

# expose the working directory, the Tomcat port, the BrowserSync ports
USER greencode
WORKDIR "/home/greencode/app"
VOLUME ["/home/greencode/app"]
EXPOSE 8080 3000 3001
CMD ["tail", "-f", "/home/greencode/generator-greencode/generators/server/templates/src/main/resources/banner-no-color.txt"]
