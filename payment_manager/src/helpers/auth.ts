import { apiDomain } from 'config/index';
import jwksClient from 'jwks-rsa';
import jwt from "supertokens-node/recipe/jwt"
import JsonWebToken, { JwtHeader, SigningKeyCallback } from 'jsonwebtoken';

export const createJWT = async (payload: any) => {
    let jwtResponse = await jwt.createJWT({
        ...payload,
        source: "microservice"
    });
    if (jwtResponse.status === "OK") {
        // Send JWT as Authorization header to M2
        return jwtResponse.jwt;
    }
    throw new Error("Unable to create JWT. Should never come here.")
}

export class SupertokensJwt {
  private client: jwksClient.JwksClient;

  constructor() {
    this.client = jwksClient({
      jwksUri: `${apiDomain}/auth/jwt/jwks.json`
    })
  }

  getKey(header: JwtHeader, callback: SigningKeyCallback) {
    this.client.getSigningKey(header.kid, function (err, key) {
      let signingKey = key!.getPublicKey();
      callback(err, signingKey);
    });
  }
}