import path from 'path'
import envSchema from 'env-schema'
import S from 'fluent-json-schema'

import supertokens from "supertokens-node";
import Session from "supertokens-node/recipe/session";
import jwt from "supertokens-node/recipe/jwt"

const result = require('dotenv').config({
  path: path.join(__dirname, '..', '..', '.env'),
})

if (process.env.NODE_ENV !== "production" && result.error) {
  throw new Error(result.error)
}

const supertokensAppName = process.env.SUPERTOKENS_APP_NAME;
const supertokensCoreUri = process.env.SUPERTOKENS_CORE_URI;
export const apiDomain = process.env.API_DOMAIN;

export default function loadConfig(): void {
  if (process.env.NODE_ENV !== "production") {
    // If .env not error can parse dotenv file
    envSchema({
      data: result.parsed,
      schema: S.object()
        .prop(
          'NODE_ENV',
          S.string().enum(['development', 'testing', 'production']).default("development"),
        )
        .prop('API_DOMAIN', S.string().required())
        .prop('API_PORT', S.string().required())
        .prop('DATABASE_URL', S.string().required())
        .prop('SUPERTOKENS_APP_NAME', S.string().required())
        .prop('SUPERTOKENS_CORE_URI', S.string().required())
    })
  }

  supertokens.init({
    framework: "fastify",
    supertokens: {
      connectionURI: supertokensCoreUri,
    },
    appInfo: {
      appName: supertokensAppName,
      apiDomain: apiDomain,
      websiteDomain: apiDomain,
      apiBasePath: "/api",
      websiteBasePath: "/auth",
    },
    recipeList: [
      Session.init(), // initializes session features
      jwt.init()      // initializes microservices auth jwt features
    ]
  });
}
