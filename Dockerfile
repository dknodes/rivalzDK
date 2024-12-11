FROM node:18

RUN apt-get update && apt-get install -y python3 make g++ && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

COPY entrypoint.sh ./
RUN npm install -g rivalz-node-cli && npm install node-pty
RUN chmod +x ./entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
