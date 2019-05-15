FROM node:lts-stretch

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install Ruby and Java
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y \
    git \
    bash \
    curl \
    wget \
    zip \
    unzip \
    ruby-full \
    g++ \
    make \
    libstdc++ \
    tzdata \
    bash \
    ca-certificates \
    default-jre-headless \
    p7zip-full \
    &&  echo 'gem: --no-document' > /etc/gemrc

# Install Fastlane
RUN gem install fastlane

# Extract the iTMSTransporter binary from the Windows installer
RUN curl https://itunesconnect.apple.com/transporter/1.9.8/iTMSTransporterToolInstaller_1.9.8.exe > installer.exe \
    && 7z x installer.exe -oitms \
    && chmod +x itms/bin/iTMSTransporter

# Set transporter path for fastlane
ENV FASTLANE_ITUNES_TRANSPORTER_PATH=/itms
ENV FASTLANE_ITUNES_TRANSPORTER_USE_SHELL_SCRIPT=1

# Cleanup GEMs to make image smaller
RUN gem cleanup

# Install Expo CLI
RUN yarn global add expo-cli
