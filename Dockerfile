FROM node:lts-alpine

ENV PATH $PATH:/usr/local/itms/bin

# Install Ruby
RUN apk update && apk upgrade && apk --update add --no-cache \
    git \
    bash \
    curl \
    wget \
    zip \
    unzip \
    ruby \
    ruby-rdoc \
    ruby-irb \
    ruby-dev \
    openssh \
    g++ \
    make \
    ruby-rake \
    ruby-io-console \
    ruby-bigdecimal \
    ruby-json \
    ruby-bundler \
    libstdc++ \
    tzdata \
    bash \
    ca-certificates \
    p7zip \
    &&  echo 'gem: --no-document' > /etc/gemrc

# Java Version and other ENV
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV JAVA_HOME /opt/openjdk-13
ENV PATH $JAVA_HOME/bin:$PATH

# Install Java (openjdk)
# https://jdk.java.net/
ENV JAVA_VERSION 13-ea+19
ENV JAVA_URL https://download.java.net/java/early_access/alpine/19/binaries/openjdk-13-ea+19_linux-x64-musl_bin.tar.gz
ENV JAVA_SHA256 010ea985fba7e3d89a9170545c4e697da983cffc442b84e65dba3baa771299a5
# "For Alpine Linux, builds are produced on a reduced schedule and may not be in sync with the other platforms."

RUN set -eux; \
    \
    wget -O /openjdk.tgz "$JAVA_URL"; \
    echo "$JAVA_SHA256 */openjdk.tgz" | sha256sum -c -; \
    mkdir -p "$JAVA_HOME"; \
    tar --extract --file /openjdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
    rm /openjdk.tgz; \
    \
  # https://github.com/docker-library/openjdk/issues/212#issuecomment-420979840
  # https://openjdk.java.net/jeps/341
    java -Xshare:dump; \
    \
  # basic smoke test
    java --version; \
    javac --version

# Extract the iTMSTransporter binary from the Windows installer
RUN curl https://itunesconnect.apple.com/transporter/1.9.8/iTMSTransporterToolInstaller_1.9.8.exe > installer.exe \
    && 7z x installer.exe -oitms \
    && chmod +x itms/bin/iTMSTransporter

# Set transporter path for fastlane
ENV FASTLANE_ITUNES_TRANSPORTER_PATH=/itms
ENV FASTLANE_ITUNES_TRANSPORTER_USE_SHELL_SCRIPT=1

# Install Fastlane
RUN gem install fastlane

# Cleanup GEMs to make image smaller
RUN gem cleanup 

# Install Expo CLI
RUN yarn global add expo-cli
