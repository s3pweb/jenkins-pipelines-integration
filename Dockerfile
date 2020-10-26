FROM node:12.18-alpine

COPY package*.json ./

RUN npm install --production

ENV NODE_ENV production

COPY . .

CMD [ "npm", "run", "start" ]
