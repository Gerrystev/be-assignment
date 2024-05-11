-- AlterTable
ALTER TABLE "public"."payment_accounts" ADD COLUMN     "currency" VARCHAR(3) NOT NULL DEFAULT 'USD';

-- AlterTable
ALTER TABLE "public"."transactions" ADD COLUMN     "currency" VARCHAR(3) NOT NULL DEFAULT 'USD';
