import { FastifyReply, FastifyRequest } from 'fastify'
import { prisma } from '../helpers/utils'
import { ERRORS, handleServerError } from '../helpers/errors'
import * as JWT from 'jsonwebtoken'
import { utils } from '../helpers/utils'
import { ERROR500, ERROR400, STANDARD, ERROR401 } from '../helpers/constants'
import { signIn, signUp } from 'supertokens-node/recipe/emailpassword'
import { createNewSession } from 'supertokens-node/recipe/session'

export const loginHandler = async (request: FastifyRequest, reply: FastifyReply) => {
  try {
    reply.code(STANDARD.SUCCESS).send({
      message: "wowow"
    })
  } catch (err) {
    handleServerError(reply, err)
  }
}