# Backend Assignment Concrete AI
Banking application with features:
- Create various payment account on a user
- Withdraw and Transfer from payment account securely from various currencies
- Get transactions:
  - Get all transaction within a user
  - Get all transaction within a payment account in a user
- Get all payment account in a user
- Get a payment account from payment account id

Read apis for these features in:
- [Openapi Swagger for Account Manager](/account_manager/openapi.yaml)
- [Openapi Swagger for Payment Manager](/payment_manager/openapi.yaml)

**Note**
To authorise, you need to:
- Request `/api/signin` or `/api/session/refresh` in account manager
- Get its access token and refresh token from `st-access-token` and `st-refresh-token` header
- Apply at swagger authorize `accessTokenBearer` and `refreshTokenBearer`


## About this project
This repository has these following directories:
- account_manager: account manager service source code
- payment_manager: payment manager service source code
- db_migrate: prisma directory to migrate database

## Tech Stack
- NodeJS: Already experienced with NodeJS
- Fastify: Chosen due recommendation and its speed
- Docker: For containerization
- Prisma: For type ORM
- PostgreSQL
- Supertokens: For authentication purpose, and its ability to self hosted

## Database Structure
![ERD](/docs/ERD.jpg)

## Prerequisites
- Make sure to installed docker compose
- Make sure to there are no conflicting ports on these ports:
    - `5432`: for PostgreSQL service
    - `3567`: for Supertokens service
    - `8080`: for Account Manager service
    - `8081`: for Payment Manager service

## Setup
Run this command to setup:
```
    # To run setup
    npm run setup

    # To run with priviledge
    npm run setup:sudo
```

## Run Services
To run services, run docker compose file:
```
    docker compose up
```

## Additional Infos
- If you want to use postman, you can use postman collection at [./postman directory](/postman)