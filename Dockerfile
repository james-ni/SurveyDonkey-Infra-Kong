FROM jenkins/jenkins:lts
MAINTAINER 4oh4

# Derived from https://github.com/getintodevops/jenkins-withdocker (miiro@getintodevops.com)

USER root

# Install the latest Docker CE binaries and add user `jenkins` to the docker group
RUN apt-get update && \
  apt-get -y --no-install-recommends install apt-transport-https \
  ca-certificates \
  git \
  make \
  zip \
  curl \
  gnupg2 \
  software-properties-common && \
  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
  add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
  $(lsb_release -cs) \
  stable" && \
  apt-get update && \
  apt-get -y --no-install-recommends install docker-ce && \
  curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose && \
  chmod 755 /usr/local/bin/docker-compose && \
  apt-get clean && \
  usermod -aG docker jenkins

# drop back to the regular jenkins user - good practice
# Not yet figure out how to do this on Mac. use root instead
USER root