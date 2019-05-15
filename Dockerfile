FROM node:lts-alpine

# ENV PATH $PATH:/usr/local/itms/bin

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

# Install JRE
RUN ZULU_PACK=zulu-8-azure-jre_8.38.0.13-8.0.212-linux_musl_x64.tar.gz && \
    INSTALL_DIR=/usr/lib/jvm && \
    BIN_DIR=/usr/bin && \
    MAN_DIR=/usr/share/man/man1 && \
    ZULU_DIR=$( basename ${ZULU_PACK} .tar.gz ) && \
    apk --no-cache add ca-certificates libgcc libstdc++ ttf-dejavu wget && \
    wget -q http://repos.azul.com/azure-only/zulu/packages/zulu-8/8u212/$ZULU_PACK && \
    mkdir -p ${INSTALL_DIR} && \
    tar -xf ./${ZULU_PACK} -C ${INSTALL_DIR} && rm -f ${ZULU_PACK} && \
    cd ${BIN_DIR} && \
    find ${INSTALL_DIR}/${ZULU_DIR}/bin -type f -perm -a=x -exec ln -s {} . \; && \
    mkdir -p ${MAN_DIR} && \
    cd ${MAN_DIR} && \
    find ${INSTALL_DIR}/${ZULU_DIR}/man/man1 -type f -name "*.1" -exec ln -s {} . \;

ENV JAVA_HOME=/usr/lib/jvm/${ZULU_DIR}

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
