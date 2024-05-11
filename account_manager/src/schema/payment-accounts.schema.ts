import S from 'fluent-json-schema'

export const createPaymentAccountSchema = {
    body: S.object()
        .prop('type', S.string().required())
        .prop('currency', S.string().maxLength(3).required())
}

export const topupSchema = {
    body: S.object()
        .prop('amount', S.number().required())
}