import { FastifyReply } from 'fastify'
import { prisma } from '../helpers/utils'
import { handleServerError } from '../helpers/errors'
import { STANDARD, ERROR404 } from '../helpers/constants'
import { SessionRequest } from "supertokens-node/framework/fastify";
import { ICreatePaymentAccount, IPaymentAccount, ITopupPaymentAccount } from 'interfaces/payment-accounts'

export const listTransactionsByUser = async (request: SessionRequest, reply: FastifyReply) => {
  try {
    const userId = request.session!.getUserId();
    
    const transactions = await prisma.transactions.findMany({
      relationLoadStrategy: 'join',
      include: {
        payment_account: {
          include: {
            user: {
              select: {
                user_id: true
              }
            }
          }
        }
      },
      where: {
        payment_account: {
          user_id: {
            equals: userId
          }
        }
      }
    })
    const result = transactions.map(o => {
      return {
        id: o.id.toString(),
        amount: o.amount,
        payment_account_id: o.payment_account_id.toString(),
        status: o.status,
        timestamp: o.timestamp
      }
    })
    
    reply.code(STANDARD.SUCCESS).send({
      message: "Success",
      result
    })
  } catch (err) {
    handleServerError(reply, err)
  }
}

export const listPaymentAccounts = async (request: SessionRequest, reply: FastifyReply) => {
  try {
    const userId = request.session!.getUserId();
    
    const pa = await prisma.payment_accounts.findMany({
      relationLoadStrategy: 'join',
      include: {
        user: {
          select: {
            user_id: true
          }
        }
      },
      where: {
        user_id: {
          equals: userId
        }
      }
    });
    const paymentAccounts = pa.map(o => {
      const res =  {
        ...o,
        id: o.id.toString()
      };
      delete res.user;
      return res;
    })

    reply.code(STANDARD.SUCCESS).send({
      message: "Success",
      result: paymentAccounts
    })
  } catch (err) {
    handleServerError(reply, err)
  }
}

const getPaById = async(userId: string, id: string) => {
  const pa = await prisma.payment_accounts.findFirst({
    relationLoadStrategy: 'join',
    include: {
      user: {
        select: {
          user_id: true
        }
      }
    },
    where: {
      user_id: {
        equals: userId
      },
      id: BigInt(id)
    }
  });

  return pa
}

export const getPaymentAccountById = async (request: IPaymentAccount, reply: FastifyReply) => {
  try {
    const userId = request.session!.getUserId();
    const paymentAccountId = request.params.id;
    
    const pa = await getPaById(userId, paymentAccountId);
    if (!pa) {
      reply.code(ERROR404.statusCode).send({
        code: ERROR404.statusCode,
        message: ERROR404.message
      })
    }
    delete pa.user;


    reply.code(STANDARD.SUCCESS).send({
      message: "Success",
      result: {
        ...pa,
        id: pa.id.toString()
      }
    })
  } catch (err) {
    handleServerError(reply, err)
  }
}

export const createPaymentAccount = async (request: ICreatePaymentAccount, reply: FastifyReply) => {
  try {
    const userId = request.session!.getUserId();
    const body = request.body;

    const id = Math.round(new Date().getTime()/1000);
    const paymentAccount = await prisma.payment_accounts.create({
      data: {
        id,
        type: body.type,
        amount: 0,
        user_id: userId
      }
    });

    reply.code(STANDARD.SUCCESS).send({
      message: "Created payment account",
      result: {
        id: paymentAccount.id.toString()
      }
    })
  } catch (err) {
    handleServerError(reply, err)
  }
}

export const deletePaymentAccount = async (request: IPaymentAccount, reply: FastifyReply) => {
  try {
    const userId = request.session!.getUserId();
    const id = request.params.id;

    const pa = await getPaById(userId, id);
    if (!pa) {
      reply.code(ERROR404.statusCode).send({
        code: ERROR404.statusCode,
        message: ERROR404.message
      })
    }

    await prisma.payment_accounts.delete({
      where: {
        id: BigInt(id)
      }
    })

    reply.code(STANDARD.SUCCESS).send({
      message: "Payment account deleted"
    })
  } catch (err) {
    handleServerError(reply, err)
  }
}

export const listTransactionsByPaymentAccountId = async (request: IPaymentAccount, reply: FastifyReply) => {
  try {
    const userId = request.session!.getUserId();
    const id = request.params.id;

    const transactions = await prisma.transactions.findMany({
      relationLoadStrategy: 'join',
      include: {
        payment_account: {
          include: {
            user: {
              select: {
                user_id: true
              }
            }
          }
        }
      },
      where: {
        payment_account: {
          user_id: {
            equals: userId
          },
          id: BigInt(id)
        }
      }
    });
    const result = transactions.map(o => {
      return {
        id: o.id,
        amount: o.amount,
        payment_account_id: o.payment_account_id.toString(),
        status: o.status,
        timestamp: o.timestamp
      }
    })
    
    reply.code(STANDARD.SUCCESS).send({
      message: "Success",
      result
    })
  } catch (err) {
    handleServerError(reply, err)
  }
}
