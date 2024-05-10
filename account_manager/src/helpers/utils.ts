import { PrismaClient } from '@prisma/client'

export const prisma = new PrismaClient()

export const utils = {
  isJSON: (data: string) => {
    try {
      JSON.parse(data)
    } catch (e) {
      return false
    }
    return true
  },
  getTime: () => {
    const date = new Date()
    const time = date.getTime()
    return time
  },
  healthCheck: (): Promise<void> => {
    return new Promise((resolve, reject) => {
      prisma
        .$queryRaw`SELECT 1`
        .then(() => {
          resolve()
        })
        .catch((e) => {
          reject(e)
        })
    })
  }
}
