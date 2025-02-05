FROM jenkins/jenkins:lts-jdk11

USER root

# Reference install gradle: https://medium.com/@migueldoctor/how-to-create-a-custom-docker-image-with-jdk8-maven-and-gradle-ddc90f41cee4
RUN apt update

# Gradle version
ARG GRADLE_VERSION=6.6.1

# Define the URL where gradle can be downloaded
ARG GRADLE_BASE_URL=https://services.gradle.org/distributions

# Define the SHA key to validate the gradle download
ARG GRADLE_SHA=7873ed5287f47ca03549ab8dcb6dc877ac7f0e3d7b1eb12685161d10080910ac

# Create the directories, download gradle, validate the download
# install it remove download file and set links
RUN mkdir -p /usr/share/gradle /usr/share/gradle/ref \
  && echo "Downloading gradle hash" \
  && curl -fsSL -o /tmp/gradle.zip ${GRADLE_BASE_URL}/gradle-${GRADLE_VERSION}-bin.zip \
  && echo "Checking download hash" \
  && echo "${GRADLE_SHA} /tmp/gradle.zip" | sha256sum -c - \
  && echo "Unziping gradle" && unzip -d /usr/share/gradle /tmp/gradle.zip \
  && echo "Clenaing and setting links" && rm -f /tmp/gradle.zip \
  && ln -s /usr/share/gradle/gradle-${GRADLE_VERSION} /usr/bin/gradle

ENV GRADLE_VERSION 6.6.1
ENV GRADLE_HOME /usr/bin/gradle
ENV PATH $PATH:$GRADLE_HOME/bin


# Agregado para usar dockerindocker con los plugins de Docker y Docker Pipeline

# install docker-cli
RUN apt-get update && apt-get install -y lsb-release
RUN curl -fsSLo /usr/share/keyrings/docker-archive-keyring.asc \
  https://download.docker.com/linux/debian/gpg
RUN echo "deb [arch=$(dpkg --print-architecture) \
  signed-by=/usr/share/keyrings/docker-archive-keyring.asc] \
  https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" > /etc/apt/sources.list.d/docker.list
RUN apt-get update && apt-get install -y docker-ce-cli

# Install docker-compose
RUN curl --fail -sL https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4 | tee /tmp/compose-version \
  && mkdir -p /usr/lib/docker/cli-plugins \
  && curl --fail -sL -o /usr/lib/docker/cli-plugins/docker-compose https://github.com/docker/compose/releases/download/$(cat /tmp/compose-version)/docker-compose-$(uname -s)-$(uname -m) \
  && chmod +x /usr/lib/docker/cli-plugins/docker-compose \
  && ln -s /usr/lib/docker/cli-plugins/docker-compose /usr/bin/docker-compose \
  && rm /tmp/compose-version

USER jenkins
