import { SessionRequest } from "supertokens-node/framework/fastify";

export interface ICreatePaymentAccount extends SessionRequest {
    body: {
        type: string,
    }
}

export interface IPaymentAccount extends SessionRequest {
    params: {
        id: string
    }
}

export interface ITopupPaymentAccount extends SessionRequest {
    body: {
        amount: number
    },
    params: {
        id: string
    }
}