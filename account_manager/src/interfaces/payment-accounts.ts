import { SessionRequest } from "supertokens-node/framework/fastify";

export interface ICreatePaymentAccount extends SessionRequest {
    body: {
        type: string,
        currency: string
    }
}

export interface IPaymentAccount extends IListQuery {
    params: {
        id: string
    }
}

export interface IListQuery extends SessionRequest {
    query: {
        offset?: string,
        limit?: string
    }
}