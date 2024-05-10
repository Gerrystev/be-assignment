import S from 'fluent-json-schema'

export const createPaymentAccountSchema = {
    body: S.object()
        .prop('type', S.string().required())
}

export const topupSchema = {
    body: S.object()
        .prop('amount', S.number().required())
}