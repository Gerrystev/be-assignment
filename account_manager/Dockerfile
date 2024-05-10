# Stage 1: Build the application
FROM node:latest AS builder

WORKDIR /usr/src/app

COPY . .
RUN npm install -g typescript
RUN npm install --production
RUN npm run build

# Stage 2: Create the production image
FROM node:current-alpine

WORKDIR /usr/src/app

# Copy only the necessary files from the previous stage
COPY --from=builder /usr/src/app/build /usr/src/app/build
COPY --from=builder /usr/src/app/node_modules /usr/src/app/node_modules
COPY --from=builder /usr/src/app/package.json /usr/src/app/package.json

EXPOSE 8080

CMD [ "node", "build/index.js" ]
