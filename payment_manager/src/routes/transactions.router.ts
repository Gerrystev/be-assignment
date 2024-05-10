import { FastifyInstance } from 'fastify'
import { transactionSchema } from '../schema'
import * as controllers from '../controllers'
import { verifySession } from "supertokens-node/recipe/session/framework/fastify";

async function transactionRouter(fastify: FastifyInstance) {
  fastify.route({
    method: 'POST',
    url: '/payment-account/:id/send',
    schema: transactionSchema,
    preHandler: verifySession(),
    handler: controllers.sendPaymentAccount,
  })
  
  fastify.route({
    method: 'POST',
    url: '/payment-account/:id/withdraw',
    schema: transactionSchema,
    preHandler: verifySession(),
    handler: controllers.withdrawPaymentAccount,
  })
}

export default transactionRouter
