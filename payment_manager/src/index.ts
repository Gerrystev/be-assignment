import { utils } from './helpers/utils';
import fastify from 'fastify';
import cors from "@fastify/cors";
import supertokens from "supertokens-node";
import { errorHandler } from "supertokens-node/framework/fastify";
import formDataPlugin from "@fastify/formbody";
import pino from 'pino';
import transactionRouter from './routes/transactions.router'
import loadConfig, { apiDomain } from './config'
import fastifyListRoutes from 'fastify-list-routes';
import { FastifyError } from './helpers/errors';

loadConfig()

const port = parseInt(process.env.API_PORT) || 5000;

const startServer = async () => {
  try {
    const server = fastify({
      logger: pino({ level: 'info' }),
    })
    await server.register(fastifyListRoutes, { colors: true });
    await server.register(formDataPlugin);
    
    server.setErrorHandler(errorHandler());
    
    server.register(transactionRouter, { prefix: '/api/transactions' })
    server.setErrorHandler((error, request, reply) => {
      server.log.error(error);
      if (error instanceof FastifyError) {
        reply.status(error.replyCode).send({
          code: error.replyCode,
          message: error.message
        })
      } else {
        reply.send(error)
      }
    })
    server.get('/', (request, reply) => {
      reply.send({ name: 'fastify-typescript' })
    })
    server.get('/health-check', async (request, reply) => {
      try {
        await utils.healthCheck()
        reply.status(200).send()
      } catch (e) {
        reply.status(500).send()
      }
    })
    server.register(cors, {
        origin: apiDomain,
        allowedHeaders: ['Content-Type', ...supertokens.getAllCORSHeaders()],
        credentials: true,
    });

    if (process.env.NODE_ENV === 'production') {
      for (const signal of ['SIGINT', 'SIGTERM']) {
        process.on(signal, () =>
          server.close().then((err) => {
            console.log(`close application on ${signal}`)
            process.exit(err ? 1 : 0)
          }),
        )
      }
    }
    
    await server.listen({ host: "0.0.0.0", port })
  } catch (e) {
    console.error(e)
  }
}

process.on('unhandledRejection', (e) => {
  console.error(e)
  process.exit(1)
})

startServer()

