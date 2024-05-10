import { SessionRequest } from "supertokens-node/framework/fastify";

export interface ITransaction extends SessionRequest {
    body: {
        amount: number
    },
    params: {
        id: string
    }
}