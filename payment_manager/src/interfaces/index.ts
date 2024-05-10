
import { FastifyRequest } from 'fastify';

export interface ISignUpRequest extends FastifyRequest {
    body: {
        email: string,
        fullname: string,
        password: string,
    }
}

export interface IUserAuthToken {
    id: number;
    email: string;
}

export interface IGetPresign {
    fileName: string;
}

export interface IPutPresign {
    userId: number;
    fileName: string;
}