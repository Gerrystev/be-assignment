import path from 'path'
import envSchema from 'env-schema'
import S from 'fluent-json-schema'

import supertokens from "supertokens-node";
import Session from "supertokens-node/recipe/session";
import EmailPassword from "supertokens-node/recipe/emailpassword";
import jwt from "supertokens-node/recipe/jwt"

import { updateUserMetadata } from "supertokens-node/recipe/usermetadata"

const result = require('dotenv').config({
  path: path.join(__dirname, '..', '..', '.env'),
})

if (result.error) {
  throw new Error(result.error)
}

const supertokensAppName = process.env.SUPERTOKENS_APP_NAME;
const supertokensCoreUri = process.env.SUPERTOKENS_CORE_URI;
export const apiDomain = process.env.API_DOMAIN;

export default function loadConfig(): void {
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
      EmailPassword.init({
        signUpFeature: {
          formFields: [{
            id: "fullname",
          }]
        },
        override: {
          apis: (originalImplementation) => {
              return {
                  ...originalImplementation,
                  signUpPOST: async function (input) {

                      if (originalImplementation.signUpPOST === undefined) {
                          throw Error("Should never come here");
                      }

                      // First we call the original implementation of signUpPOST.
                      let response = await originalImplementation.signUpPOST(input);

                      // Post sign up response, we check if it was successful
                      if (response.status === "OK") {
                          // These are the input form fields values that the user used while signing up
                          const formFields = input.formFields;
                          const fullnameField = formFields.find(o => o.id === "fullname");
                          await updateUserMetadata(response.user.id, { fullname: fullnameField.value });
                      }
                      return response;
                  }
              }
          }
        }
      }), // initializes signin / sign up features
      Session.init(), // initializes session features
      jwt.init()      // initializes microservices auth jwt features
    ]
  });
}
