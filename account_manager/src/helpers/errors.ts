import { ERROR400, ERROR404, ERROR500 } from "./constants"

export class FastifyError extends Error {
  constructor(public replyCode, message) {
    super(message);
  }
}

export class InternalServerError extends FastifyError {
  constructor(message = ERROR500.message) {
    super(ERROR500.statusCode, message);
  }
}

export class NotFoundError extends FastifyError {
  constructor(message = ERROR404.message) {
    super(ERROR404.statusCode, message);
  }
}

export class BadRequestError extends FastifyError {
  constructor(message = ERROR400.message) {
    super(ERROR400.statusCode, message);
  }
}