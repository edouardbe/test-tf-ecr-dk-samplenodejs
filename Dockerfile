FROM node:18-alpine

WORKDIR /usr/src/app

COPY package.json .

RUN npm install

# Bundle app source
COPY . .

EXPOSE 80
CMD [ "npm", "run","start" ]

