import { SessionRequest } from "supertokens-node/framework/fastify";

export interface ITransaction extends SessionRequest {
    body: {
        amount: number,
        currency: string
    },
    params: {
        id: string
    }
}