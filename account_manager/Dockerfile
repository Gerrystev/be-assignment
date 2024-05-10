# Stage 1: Build the application
FROM node:latest AS builder

WORKDIR /usr/src/app

COPY . .
RUN npm install --production
RUN npm run build

# Stage 2: Create the production image
FROM node:current-alpine

WORKDIR /usr/src/app

# Copy only the necessary files from the previous stage
COPY --from=builder /usr/src/app/lib /usr/src/app/lib
COPY --from=builder /usr/src/app/node_modules /usr/src/app/node_modules
COPY --from=builder /usr/src/app/package.json /usr/src/app/package.json

EXPOSE 8080

CMD [ "node", "lib/index.js" ]
