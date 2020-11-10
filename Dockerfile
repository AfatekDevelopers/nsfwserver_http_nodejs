FROM ubuntu:16.04
LABEL maintainer="Afatek Developers <developer@afatek.com.tr>"
# Create app directory
RUN apt-get update && apt-get install -y --fix-missing --no-install-recommends \
        build-essential \
        curl \
        git-core \
        iputils-ping \
        pkg-config \
        rsync \
        software-properties-common \
        unzip \
        wget

ENV TZ=Europe/Istanbul
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package*.json ./

# Install NodeJS
RUN curl --silent --location https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install --yes nodejs

RUN npm set audit false
RUN npm install --save express
RUN npm install --save nsfwjs
RUN npm install --save @tensorflow/tfjs-node
RUN npm install 

# Clean up commands
RUN apt-get autoremove -y && apt-get clean && \
    rm -rf /usr/local/src/*

RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Bundle app source
COPY . .

RUN chmod +x /usr/src/app/start.sh

ENV CAM_DATA=/cam_data

VOLUME /usr/src/app/src/cam_data

EXPOSE 30000
CMD ["/usr/src/app/start.sh"]