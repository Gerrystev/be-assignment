FROM node:22 AS builder
WORKDIR /usr/src/app

COPY . .
RUN npm install

CMD [  "npm", "run", "db:migrate" ]
