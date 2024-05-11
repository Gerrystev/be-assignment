import { FastifyReply } from 'fastify'
import { prisma } from '../helpers/utils'
import { BadRequestError, NotFoundError } from '../helpers/errors'
import { STANDARD } from '../helpers/constants'
import { ITransaction } from 'interfaces/transactions'
import { Prisma } from '@prisma/client';
import validateCurrencyCode from 'validate-currency-code'
import CC from 'currency-converter-lt';

interface PaymentAccount {
  id: bigint,
  type: string,
  amount: Prisma.Decimal,
  currency: string,
  user_id: string,
}

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

  if (!pa) {
    throw new NotFoundError("Payment account not found")
  }

  return pa
}

const createTransaction = (
  paymentAccount: PaymentAccount,
  transaction: { amount: number, currency: string, operation: 'send' | 'withdraw', status: 'success' | 'failed' | 'pending' }) => {
    const { amount, currency, operation, status } = transaction;
    const id = createNewId();

    console.log(amount);
    return prisma.transactions.create({
      data: {
        id: BigInt(id),
        amount,
        status,
        timestamp: new Date(),
        payment_account_id: BigInt(paymentAccount.id),
        operation,
        currency,
      }
    })
  } 

const processTransaction = async(
  paymentAccount: PaymentAccount,
  transaction: { amount: number,  currency: string, operation: 'send' | 'withdraw' }) : Promise<{ status: "TRANSACTION_SUCCESS" }> => {
  const { amount, operation, currency } = transaction;
  return new Promise((resolve, reject) => {
    setTimeout(async () => {
      // Simulate transactions process

      const currentAccountAmount = paymentAccount.amount.toNumber();
      const currenctAccountCurrency = paymentAccount.currency;

      if (operation === 'withdraw' && currentAccountAmount < amount) {
        throw new BadRequestError("Payment account number is less than amount to withdraw")
      }

      // Calculate currency
      const currencyConverter = new CC({ from: currency, to: currenctAccountCurrency, amount, isDecimalComma: true });
      const convertedAmount = await currencyConverter.convert();
      const totalAmount = operation === 'send' ? currentAccountAmount + convertedAmount : currentAccountAmount - convertedAmount;
      
      await prisma.$transaction([
        createTransaction(paymentAccount, { amount, currency, operation, status: 'success' }),
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
    }, 30000); // 30 seconds
  });
}

export const sendPaymentAccount = async (request: ITransaction, reply: FastifyReply) => {
  const userId = request.session!.getUserId();
  const id = request.params.id;
  const { amount, currency } = request.body;

  if(!validateCurrencyCode(currency)) {
    throw new BadRequestError("Invalid currency code")
  }

  const pa = await getPaById(userId, id);

  try {
    await processTransaction(pa, { amount, currency, operation: 'send' });
  } catch (e) {
    await createTransaction(pa, { amount, currency, operation: 'send', status: 'failed' });
    throw new Error(e)
  }

  reply.code(STANDARD.SUCCESS).send({
    message: "Send Transaction Success"
  })
}

export const withdrawPaymentAccount = async (request: ITransaction, reply: FastifyReply) => {
  const userId = request.session!.getUserId();
  const id = request.params.id;
  const { amount, currency } = request.body;

  const pa = await getPaById(userId, id);

  try {
    await processTransaction(pa, { amount, currency, operation: 'withdraw' });
  } catch (e) {
    await createTransaction(pa, { amount, currency, operation: 'withdraw', status: 'failed' });
  }

  reply.code(STANDARD.SUCCESS).send({
    message: "Withdraw Transaction Success"
  })
}