import { FastifyReply } from 'fastify'
import { prisma } from '../helpers/utils'
import { handleServerError } from '../helpers/errors'
import { STANDARD, ERROR404, ERROR500 } from '../helpers/constants'
import { ITransaction } from 'interfaces/transactions'
import { Prisma } from '@prisma/client';

const createNewId = () => {
  return Math.round(new Date().getTime()/1000);
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

const createTransaction = (
  paymentAccount: {
      id: bigint;
      type: string;
      amount: Prisma.Decimal;
      user_id: string;
  },
  transaction: { amount: number, operation: 'send' | 'withdraw', status: 'success' | 'failed' | 'pending' }) => {
    const { amount, operation, status } = transaction;
    const id = createNewId();

    return prisma.transactions.create({
      data: {
        id: BigInt(id),
        amount,
        status,
        timestamp: new Date(),
        payment_account_id: BigInt(paymentAccount.id),
        operation
      }
    })
  } 

const processTransaction = async(
  paymentAccount: {
      id: bigint;
      type: string;
      amount: Prisma.Decimal;
      user_id: string;
  },
  transaction: { amount: number, operation: 'send' | 'withdraw' }) : Promise<{ status: "TRANSACTION_SUCCESS" }> => {
  const { amount, operation } = transaction;
  return new Promise((resolve, reject) => {
    setTimeout(async () => {
      const id = createNewId();
      const currentAccountAmount = paymentAccount.amount.toNumber();
      if (operation === 'withdraw' && currentAccountAmount < amount) {
        return reject("Payment account number is less than amount to withdraw")
      }
      const totalAmount = operation === 'send' ? currentAccountAmount + amount : currentAccountAmount - amount;
      
      await prisma.$transaction([
        createTransaction(paymentAccount, { amount, operation, status: 'success' }),
        prisma.payment_accounts.update({
          data: {
            amount: totalAmount
          },
          where: {
            id: BigInt(paymentAccount.id)
          }
        })
      ]);
      resolve({ status: "TRANSACTION_SUCCESS" });
    }, 1000); // 30 seconds
  });
}

export const sendPaymentAccount = async (request: ITransaction, reply: FastifyReply) => {
  try {
    const userId = request.session!.getUserId();
    const id = request.params.id;
    const { amount } = request.body;

    const pa = await getPaById(userId, id);
    if (!pa) {
      reply.code(ERROR404.statusCode).send({
        code: ERROR404.statusCode,
        message: ERROR404.message
      })
    }

    try {
      await processTransaction(pa, { amount, operation: 'send' });
    } catch (e) {
      await createTransaction(pa, { amount, operation: 'send', status: 'failed' });
      throw new Error(e)
    }

    reply.code(STANDARD.SUCCESS).send({
      message: "Send Transaction Success"
    })
  } catch (err) {
    handleServerError(reply, err)
  }
}

export const withdrawPaymentAccount = async (request: ITransaction, reply: FastifyReply) => {
  try {
    const userId = request.session!.getUserId();
    const id = request.params.id;
    const { amount } = request.body;

    const pa = await getPaById(userId, id);
    if (!pa) {
      reply.code(ERROR404.statusCode).send({
        code: ERROR404.statusCode,
        message: ERROR404.message
      })
    }

    try {
      await processTransaction(pa, { amount, operation: 'withdraw' });
    } catch (e) {
      await createTransaction(pa, { amount, operation: 'withdraw', status: 'failed' });
    }

    reply.code(STANDARD.SUCCESS).send({
      message: "Withdraw Transaction Success"
    })
  } catch (err) {
    handleServerError(reply, err)
  }
}