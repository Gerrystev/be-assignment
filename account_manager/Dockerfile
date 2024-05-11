# Stage 1: Build the application
FROM node:22 AS builder
ENV NODE_ENV="production"
WORKDIR /usr/src/app

COPY . .
RUN npm install --production -g typescript
RUN npm install --production
RUN npm run build

# Stage 2: Create the production image
FROM node:22-alpine3.19

WORKDIR /usr/src/app

# Copy only the necessary files from the previous stage
COPY --from=builder /usr/src/app/build /usr/src/app/build
COPY --from=builder /usr/src/app/node_modules /usr/src/app/node_modules
COPY --from=builder /usr/src/app/package.json /usr/src/app/package.json
COPY --from=builder /usr/src/app/prisma ./prisma

RUN apk update && apk add openssl

EXPOSE 8080

CMD [  "npm", "run", "start" ]
