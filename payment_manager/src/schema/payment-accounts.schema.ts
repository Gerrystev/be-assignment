import S from 'fluent-json-schema'

export const transactionSchema = {
    body: S.object()
        .prop('amount', S.number().required())
        .prop('currency', S.string().maxLength(3).required())
}