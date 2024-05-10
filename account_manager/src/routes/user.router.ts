import { FastifyInstance } from 'fastify'
import { createPaymentAccountSchema, topupSchema } from '../schema'
import * as controllers from '../controllers'
import { verifySession } from "supertokens-node/recipe/session/framework/fastify";

async function userRouter(fastify: FastifyInstance) {
  fastify.route({
    method: 'GET',
    url: '/transactions',
    preHandler: verifySession(),
    handler: controllers.listTransactionsByUser,
  })
  
  fastify.route({
    method: 'GET',
    url: '/payment-account',
    preHandler: verifySession(),
    handler: controllers.listPaymentAccounts,
  })

  fastify.route({
    method: 'GET',
    url: '/payment-account/:id',
    preHandler: verifySession(),
    handler: controllers.getPaymentAccountById,
  })

  fastify.route({
    method: 'POST',
    url: '/payment-account',
    schema: createPaymentAccountSchema,
    preHandler: verifySession(),
    handler: controllers.createPaymentAccount,
  })

  fastify.route({
    method: 'PUT',
    url: '/payment-account/:id/topup',
    schema: topupSchema,
    preHandler: verifySession(),
    handler: controllers.topupPaymentAccount,
  })

  fastify.route({
    method: 'DELETE',
    url: '/payment-account/:id',
    preHandler: verifySession(),
    handler: controllers.deletePaymentAccount,
  })

  fastify.route({
    method: 'GET',
    url: '/payment-account/:id/transactions',
    preHandler: verifySession(),
    handler: controllers.listTransactionsByPaymentAccountId,
  })
}

export default userRouter
