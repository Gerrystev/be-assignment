export class FastifyError extends Error {
  constructor(public replyCode, message) {
    super(message);
  }
}

export class InternalServerError extends FastifyError {
  constructor(message = "INTERNAL_SERVER_ERROR") {
    super(500, message);
  }
}

export class NotFoundError extends FastifyError {
  constructor(message = "NOT_FOUND") {
    super(404, message);
  }
}

export class BadRequestError extends FastifyError {
  constructor(message = "BAD_REQUEST") {
    super(400, message);
  }
}