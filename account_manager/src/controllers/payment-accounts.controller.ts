import { FastifyReply } from 'fastify'
import { prisma } from '../helpers/utils'
import { BadRequestError, NotFoundError } from '../helpers/errors'
import { STANDARD, ERROR404 } from '../helpers/constants'
import { ICreatePaymentAccount, IListQuery, IPaymentAccount } from 'interfaces/payment-accounts'
import validateCurrencyCode from 'validate-currency-code';

export const listTransactionsByUser = async (request: IListQuery, reply: FastifyReply) => {
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

  let result = {};
  transactions.forEach(o => {
    const paymentAccountId = o.payment_account_id.toString();
    const parsed = {
      id: o.id.toString(),
      amount: o.amount.toNumber(),
      status: o.status,
      timestamp: o.timestamp,
      currency: o.currency
    };
    if (!result[paymentAccountId]) {
      result[paymentAccountId] = [parsed];
    } else {
      result[paymentAccountId].push(parsed);
    }
  })
  
  reply.code(STANDARD.SUCCESS).send({
    message: "Success",
    result
  })
}

export const listPaymentAccounts = async (request: IListQuery, reply: FastifyReply) => {
  const userId = request.session!.getUserId();
  const limit = request.query.limit? parseInt(request.query.limit) : undefined;
  const offset = request.query.offset? parseInt(request.query.offset) : undefined;
    
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
    },
    skip: offset,
    take: limit
  });
  const paymentAccounts = pa.map(o => {
    const res =  {
      ...o,
      id: o.id.toString(),
      amount: o.amount.toNumber()
    };
    delete res.user_id;
    delete res.user;
    return res;
  })

  reply.code(STANDARD.SUCCESS).send({
    message: "Success",
    result: paymentAccounts
  })
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

  if (!pa) {
    throw new NotFoundError("Payment account not found")
  }

  return pa
}

export const getPaymentAccountById = async (request: IPaymentAccount, reply: FastifyReply) => {
  const userId = request.session!.getUserId();
  const paymentAccountId = request.params.id;
  
  const pa = await getPaById(userId, paymentAccountId);
  delete pa.user;

  const result = {
    ...pa,
    id: pa.id.toString(),
    amount: pa.amount.toNumber()
  };
  delete result.user_id;

  reply.code(STANDARD.SUCCESS).send({
    message: "Success",
    result
  })
}

export const createPaymentAccount = async (request: ICreatePaymentAccount, reply: FastifyReply) => {
  const userId = request.session!.getUserId();
  const body = request.body;

  if(!validateCurrencyCode(body.currency)) {
    throw new BadRequestError("Invalid currency code")
  }

  const id = Math.round(new Date().getTime()/1000);
  const paymentAccount = await prisma.payment_accounts.create({
    data: {
      id,
      type: body.type,
      amount: 0,
      user_id: userId,
      currency: body.currency
    }
  });

  reply.code(STANDARD.SUCCESS).send({
    message: "Created payment account",
    result: {
      id: paymentAccount.id.toString()
    }
  })
}

export const deletePaymentAccount = async (request: IPaymentAccount, reply: FastifyReply) => {
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
}

export const listTransactionsByPaymentAccountId = async (request: IPaymentAccount, reply: FastifyReply) => {
  const userId = request.session!.getUserId();
  const id = request.params.id;
  const limit = request.query.limit? parseInt(request.query.limit) : undefined;
  const offset = request.query.offset? parseInt(request.query.offset) : undefined;

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
    },
    skip: offset,
    take: limit
  });
  const result = transactions.map(o => {
    return {
      id: o.id.toString(),
      amount: o.amount,
      payment_account_id: o.payment_account_id.toString(),
      status: o.status,
      timestamp: o.timestamp,
      currency: o.currency
    }
  })
  
  reply.code(STANDARD.SUCCESS).send({
    message: "Success",
    result
  })
}
