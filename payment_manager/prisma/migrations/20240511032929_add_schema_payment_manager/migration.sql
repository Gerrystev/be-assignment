-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "auth";

-- CreateEnum
CREATE TYPE "public"."transaction_status" AS ENUM ('pending', 'success', 'failed');

-- CreateEnum
CREATE TYPE "public"."transaction_operation" AS ENUM ('send', 'withdraw');

-- CreateTable
CREATE TABLE "auth"."all_auth_recipe_users" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" CHAR(36) NOT NULL,
    "primary_or_recipe_user_id" CHAR(36) NOT NULL,
    "is_linked_or_is_a_primary_user" BOOLEAN NOT NULL DEFAULT false,
    "recipe_id" VARCHAR(128) NOT NULL,
    "time_joined" BIGINT NOT NULL,
    "primary_or_recipe_user_time_joined" BIGINT NOT NULL,

    CONSTRAINT "all_auth_recipe_users_pkey" PRIMARY KEY ("app_id","tenant_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."app_id_to_user_id" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" CHAR(36) NOT NULL,
    "recipe_id" VARCHAR(128) NOT NULL,
    "primary_or_recipe_user_id" CHAR(36) NOT NULL,
    "is_linked_or_is_a_primary_user" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "app_id_to_user_id_pkey" PRIMARY KEY ("app_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."apps" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "created_at_time" BIGINT,

    CONSTRAINT "apps_pkey" PRIMARY KEY ("app_id")
);

-- CreateTable
CREATE TABLE "auth"."dashboard_user_sessions" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "session_id" CHAR(36) NOT NULL,
    "user_id" CHAR(36) NOT NULL,
    "time_created" BIGINT NOT NULL,
    "expiry" BIGINT NOT NULL,

    CONSTRAINT "dashboard_user_sessions_pkey" PRIMARY KEY ("app_id","session_id")
);

-- CreateTable
CREATE TABLE "auth"."dashboard_users" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" CHAR(36) NOT NULL,
    "email" VARCHAR(256) NOT NULL,
    "password_hash" VARCHAR(256) NOT NULL,
    "time_joined" BIGINT NOT NULL,

    CONSTRAINT "dashboard_users_pkey" PRIMARY KEY ("app_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."emailpassword_pswd_reset_tokens" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" CHAR(36) NOT NULL,
    "token" VARCHAR(128) NOT NULL,
    "email" VARCHAR(256),
    "token_expiry" BIGINT NOT NULL,

    CONSTRAINT "emailpassword_pswd_reset_tokens_pkey" PRIMARY KEY ("app_id","user_id","token")
);

-- CreateTable
CREATE TABLE "auth"."emailpassword_user_to_tenant" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" CHAR(36) NOT NULL,
    "email" VARCHAR(256) NOT NULL,

    CONSTRAINT "emailpassword_user_to_tenant_pkey" PRIMARY KEY ("app_id","tenant_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."emailpassword_users" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" CHAR(36) NOT NULL,
    "email" VARCHAR(256) NOT NULL,
    "password_hash" VARCHAR(256) NOT NULL,
    "time_joined" BIGINT NOT NULL,

    CONSTRAINT "emailpassword_users_pkey" PRIMARY KEY ("app_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."emailverification_tokens" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" VARCHAR(128) NOT NULL,
    "email" VARCHAR(256) NOT NULL,
    "token" VARCHAR(128) NOT NULL,
    "token_expiry" BIGINT NOT NULL,

    CONSTRAINT "emailverification_tokens_pkey" PRIMARY KEY ("app_id","tenant_id","user_id","email","token")
);

-- CreateTable
CREATE TABLE "auth"."emailverification_verified_emails" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" VARCHAR(128) NOT NULL,
    "email" VARCHAR(256) NOT NULL,

    CONSTRAINT "emailverification_verified_emails_pkey" PRIMARY KEY ("app_id","user_id","email")
);

-- CreateTable
CREATE TABLE "auth"."jwt_signing_keys" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "key_id" VARCHAR(255) NOT NULL,
    "key_string" TEXT NOT NULL,
    "algorithm" VARCHAR(10) NOT NULL,
    "created_at" BIGINT,

    CONSTRAINT "jwt_signing_keys_pkey" PRIMARY KEY ("app_id","key_id")
);

-- CreateTable
CREATE TABLE "auth"."key_value" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "name" VARCHAR(128) NOT NULL,
    "value" TEXT,
    "created_at_time" BIGINT,

    CONSTRAINT "key_value_pkey" PRIMARY KEY ("app_id","tenant_id","name")
);

-- CreateTable
CREATE TABLE "auth"."passwordless_codes" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "code_id" CHAR(36) NOT NULL,
    "device_id_hash" CHAR(44) NOT NULL,
    "link_code_hash" CHAR(44) NOT NULL,
    "created_at" BIGINT NOT NULL,

    CONSTRAINT "passwordless_codes_pkey" PRIMARY KEY ("app_id","tenant_id","code_id")
);

-- CreateTable
CREATE TABLE "auth"."passwordless_devices" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "device_id_hash" CHAR(44) NOT NULL,
    "email" VARCHAR(256),
    "phone_number" VARCHAR(256),
    "link_code_salt" CHAR(44) NOT NULL,
    "failed_attempts" INTEGER NOT NULL,

    CONSTRAINT "passwordless_devices_pkey" PRIMARY KEY ("app_id","tenant_id","device_id_hash")
);

-- CreateTable
CREATE TABLE "auth"."passwordless_user_to_tenant" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" CHAR(36) NOT NULL,
    "email" VARCHAR(256),
    "phone_number" VARCHAR(256),

    CONSTRAINT "passwordless_user_to_tenant_pkey" PRIMARY KEY ("app_id","tenant_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."passwordless_users" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" CHAR(36) NOT NULL,
    "email" VARCHAR(256),
    "phone_number" VARCHAR(256),
    "time_joined" BIGINT NOT NULL,

    CONSTRAINT "passwordless_users_pkey" PRIMARY KEY ("app_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."role_permissions" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "role" VARCHAR(255) NOT NULL,
    "permission" VARCHAR(255) NOT NULL,

    CONSTRAINT "role_permissions_pkey" PRIMARY KEY ("app_id","role","permission")
);

-- CreateTable
CREATE TABLE "auth"."roles" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "role" VARCHAR(255) NOT NULL,

    CONSTRAINT "roles_pkey" PRIMARY KEY ("app_id","role")
);

-- CreateTable
CREATE TABLE "auth"."session_access_token_signing_keys" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "created_at_time" BIGINT NOT NULL,
    "value" TEXT,

    CONSTRAINT "session_access_token_signing_keys_pkey" PRIMARY KEY ("app_id","created_at_time")
);

-- CreateTable
CREATE TABLE "auth"."session_info" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "session_handle" VARCHAR(255) NOT NULL,
    "user_id" VARCHAR(128) NOT NULL,
    "refresh_token_hash_2" VARCHAR(128) NOT NULL,
    "session_data" TEXT,
    "expires_at" BIGINT NOT NULL,
    "created_at_time" BIGINT NOT NULL,
    "jwt_user_payload" TEXT,
    "use_static_key" BOOLEAN NOT NULL,

    CONSTRAINT "session_info_pkey" PRIMARY KEY ("app_id","tenant_id","session_handle")
);

-- CreateTable
CREATE TABLE "auth"."tenant_configs" (
    "connection_uri_domain" VARCHAR(256) NOT NULL DEFAULT '',
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "core_config" TEXT,
    "email_password_enabled" BOOLEAN,
    "passwordless_enabled" BOOLEAN,
    "third_party_enabled" BOOLEAN,

    CONSTRAINT "tenant_configs_pkey" PRIMARY KEY ("connection_uri_domain","app_id","tenant_id")
);

-- CreateTable
CREATE TABLE "auth"."tenant_first_factors" (
    "connection_uri_domain" VARCHAR(256) NOT NULL DEFAULT '',
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "factor_id" VARCHAR(128) NOT NULL,

    CONSTRAINT "tenant_first_factors_pkey" PRIMARY KEY ("connection_uri_domain","app_id","tenant_id","factor_id")
);

-- CreateTable
CREATE TABLE "auth"."tenant_required_secondary_factors" (
    "connection_uri_domain" VARCHAR(256) NOT NULL DEFAULT '',
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "factor_id" VARCHAR(128) NOT NULL,

    CONSTRAINT "tenant_required_secondary_factors_pkey" PRIMARY KEY ("connection_uri_domain","app_id","tenant_id","factor_id")
);

-- CreateTable
CREATE TABLE "auth"."tenant_thirdparty_provider_clients" (
    "connection_uri_domain" VARCHAR(256) NOT NULL DEFAULT '',
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "third_party_id" VARCHAR(28) NOT NULL,
    "client_type" VARCHAR(64) NOT NULL DEFAULT '',
    "client_id" VARCHAR(256) NOT NULL,
    "client_secret" TEXT,
    "scope" VARCHAR(128)[],
    "force_pkce" BOOLEAN,
    "additional_config" TEXT,

    CONSTRAINT "tenant_thirdparty_provider_clients_pkey" PRIMARY KEY ("connection_uri_domain","app_id","tenant_id","third_party_id","client_type")
);

-- CreateTable
CREATE TABLE "auth"."tenant_thirdparty_providers" (
    "connection_uri_domain" VARCHAR(256) NOT NULL DEFAULT '',
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "third_party_id" VARCHAR(28) NOT NULL,
    "name" VARCHAR(64),
    "authorization_endpoint" TEXT,
    "authorization_endpoint_query_params" TEXT,
    "token_endpoint" TEXT,
    "token_endpoint_body_params" TEXT,
    "user_info_endpoint" TEXT,
    "user_info_endpoint_query_params" TEXT,
    "user_info_endpoint_headers" TEXT,
    "jwks_uri" TEXT,
    "oidc_discovery_endpoint" TEXT,
    "require_email" BOOLEAN,
    "user_info_map_from_id_token_payload_user_id" VARCHAR(64),
    "user_info_map_from_id_token_payload_email" VARCHAR(64),
    "user_info_map_from_id_token_payload_email_verified" VARCHAR(64),
    "user_info_map_from_user_info_endpoint_user_id" VARCHAR(64),
    "user_info_map_from_user_info_endpoint_email" VARCHAR(64),
    "user_info_map_from_user_info_endpoint_email_verified" VARCHAR(64),

    CONSTRAINT "tenant_thirdparty_providers_pkey" PRIMARY KEY ("connection_uri_domain","app_id","tenant_id","third_party_id")
);

-- CreateTable
CREATE TABLE "auth"."tenants" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "created_at_time" BIGINT,

    CONSTRAINT "tenants_pkey" PRIMARY KEY ("app_id","tenant_id")
);

-- CreateTable
CREATE TABLE "auth"."thirdparty_user_to_tenant" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" CHAR(36) NOT NULL,
    "third_party_id" VARCHAR(28) NOT NULL,
    "third_party_user_id" VARCHAR(256) NOT NULL,

    CONSTRAINT "thirdparty_user_to_tenant_pkey" PRIMARY KEY ("app_id","tenant_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."thirdparty_users" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "third_party_id" VARCHAR(28) NOT NULL,
    "third_party_user_id" VARCHAR(256) NOT NULL,
    "user_id" CHAR(36) NOT NULL,
    "email" VARCHAR(256) NOT NULL,
    "time_joined" BIGINT NOT NULL,

    CONSTRAINT "thirdparty_users_pkey" PRIMARY KEY ("app_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."totp_used_codes" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" VARCHAR(128) NOT NULL,
    "code" VARCHAR(8) NOT NULL,
    "is_valid" BOOLEAN NOT NULL,
    "expiry_time_ms" BIGINT NOT NULL,
    "created_time_ms" BIGINT NOT NULL,

    CONSTRAINT "totp_used_codes_pkey" PRIMARY KEY ("app_id","tenant_id","user_id","created_time_ms")
);

-- CreateTable
CREATE TABLE "auth"."totp_user_devices" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" VARCHAR(128) NOT NULL,
    "device_name" VARCHAR(256) NOT NULL,
    "secret_key" VARCHAR(256) NOT NULL,
    "period" INTEGER NOT NULL,
    "skew" INTEGER NOT NULL,
    "verified" BOOLEAN NOT NULL,
    "created_at" BIGINT,

    CONSTRAINT "totp_user_devices_pkey" PRIMARY KEY ("app_id","user_id","device_name")
);

-- CreateTable
CREATE TABLE "auth"."totp_users" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" VARCHAR(128) NOT NULL,

    CONSTRAINT "totp_users_pkey" PRIMARY KEY ("app_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."user_last_active" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" VARCHAR(128) NOT NULL,
    "last_active_time" BIGINT,

    CONSTRAINT "user_last_active_pkey" PRIMARY KEY ("app_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."user_metadata" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" VARCHAR(128) NOT NULL,
    "user_metadata" TEXT NOT NULL,

    CONSTRAINT "user_metadata_pkey" PRIMARY KEY ("app_id","user_id")
);

-- CreateTable
CREATE TABLE "auth"."user_roles" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "tenant_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "user_id" VARCHAR(128) NOT NULL,
    "role" VARCHAR(255) NOT NULL,

    CONSTRAINT "user_roles_pkey" PRIMARY KEY ("app_id","tenant_id","user_id","role")
);

-- CreateTable
CREATE TABLE "auth"."userid_mapping" (
    "app_id" VARCHAR(64) NOT NULL DEFAULT 'public',
    "supertokens_user_id" CHAR(36) NOT NULL,
    "external_user_id" VARCHAR(128) NOT NULL,
    "external_user_id_info" TEXT,

    CONSTRAINT "userid_mapping_pkey" PRIMARY KEY ("app_id","supertokens_user_id","external_user_id")
);

-- CreateTable
CREATE TABLE "public"."payment_accounts" (
    "id" BIGINT NOT NULL,
    "type" TEXT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "user_id" TEXT NOT NULL,

    CONSTRAINT "payment_accounts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "public"."transactions" (
    "id" BIGINT NOT NULL,
    "amount" DECIMAL(65,30) NOT NULL,
    "timestamp" TIMESTAMP(3) NOT NULL,
    "payment_account_id" BIGINT NOT NULL,
    "status" "public"."transaction_status" NOT NULL,
    "operation" "public"."transaction_operation" NOT NULL,

    CONSTRAINT "transactions_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "all_auth_recipe_users_user_id_key" ON "auth"."all_auth_recipe_users"("user_id");

-- CreateIndex
CREATE INDEX "all_auth_recipe_tenant_id_index" ON "auth"."all_auth_recipe_users"("app_id", "tenant_id");

-- CreateIndex
CREATE INDEX "all_auth_recipe_user_id_index" ON "auth"."all_auth_recipe_users"("app_id", "user_id");

-- CreateIndex
CREATE INDEX "all_auth_recipe_users_pagination_index1" ON "auth"."all_auth_recipe_users"("app_id", "tenant_id", "primary_or_recipe_user_time_joined" DESC, "primary_or_recipe_user_id" DESC);

-- CreateIndex
CREATE INDEX "all_auth_recipe_users_pagination_index2" ON "auth"."all_auth_recipe_users"("app_id", "tenant_id", "primary_or_recipe_user_time_joined", "primary_or_recipe_user_id" DESC);

-- CreateIndex
CREATE INDEX "all_auth_recipe_users_pagination_index3" ON "auth"."all_auth_recipe_users"("recipe_id", "app_id", "tenant_id", "primary_or_recipe_user_time_joined" DESC, "primary_or_recipe_user_id" DESC);

-- CreateIndex
CREATE INDEX "all_auth_recipe_users_pagination_index4" ON "auth"."all_auth_recipe_users"("recipe_id", "app_id", "tenant_id", "primary_or_recipe_user_time_joined", "primary_or_recipe_user_id" DESC);

-- CreateIndex
CREATE INDEX "all_auth_recipe_users_primary_user_id_index" ON "auth"."all_auth_recipe_users"("primary_or_recipe_user_id", "app_id");

-- CreateIndex
CREATE INDEX "all_auth_recipe_users_recipe_id_index" ON "auth"."all_auth_recipe_users"("app_id", "recipe_id", "tenant_id");

-- CreateIndex
CREATE INDEX "app_id_to_user_id_app_id_index" ON "auth"."app_id_to_user_id"("app_id");

-- CreateIndex
CREATE INDEX "app_id_to_user_id_primary_user_id_index" ON "auth"."app_id_to_user_id"("primary_or_recipe_user_id", "app_id");

-- CreateIndex
CREATE INDEX "dashboard_user_sessions_expiry_index" ON "auth"."dashboard_user_sessions"("expiry");

-- CreateIndex
CREATE INDEX "dashboard_user_sessions_user_id_index" ON "auth"."dashboard_user_sessions"("app_id", "user_id");

-- CreateIndex
CREATE INDEX "dashboard_users_app_id_index" ON "auth"."dashboard_users"("app_id");

-- CreateIndex
CREATE UNIQUE INDEX "dashboard_users_email_key" ON "auth"."dashboard_users"("app_id", "email");

-- CreateIndex
CREATE UNIQUE INDEX "emailpassword_pswd_reset_tokens_token_key" ON "auth"."emailpassword_pswd_reset_tokens"("token");

-- CreateIndex
CREATE INDEX "emailpassword_password_reset_token_expiry_index" ON "auth"."emailpassword_pswd_reset_tokens"("token_expiry");

-- CreateIndex
CREATE INDEX "emailpassword_pswd_reset_tokens_user_id_index" ON "auth"."emailpassword_pswd_reset_tokens"("app_id", "user_id");

-- CreateIndex
CREATE UNIQUE INDEX "emailpassword_user_to_tenant_email_key" ON "auth"."emailpassword_user_to_tenant"("app_id", "tenant_id", "email");

-- CreateIndex
CREATE UNIQUE INDEX "emailverification_tokens_token_key" ON "auth"."emailverification_tokens"("token");

-- CreateIndex
CREATE INDEX "emailverification_tokens_index" ON "auth"."emailverification_tokens"("token_expiry");

-- CreateIndex
CREATE INDEX "emailverification_tokens_tenant_id_index" ON "auth"."emailverification_tokens"("app_id", "tenant_id");

-- CreateIndex
CREATE INDEX "emailverification_verified_emails_app_id_index" ON "auth"."emailverification_verified_emails"("app_id");

-- CreateIndex
CREATE INDEX "jwt_signing_keys_app_id_index" ON "auth"."jwt_signing_keys"("app_id");

-- CreateIndex
CREATE INDEX "key_value_tenant_id_index" ON "auth"."key_value"("app_id", "tenant_id");

-- CreateIndex
CREATE INDEX "passwordless_codes_created_at_index" ON "auth"."passwordless_codes"("app_id", "tenant_id", "created_at");

-- CreateIndex
CREATE INDEX "passwordless_codes_device_id_hash_index" ON "auth"."passwordless_codes"("app_id", "tenant_id", "device_id_hash");

-- CreateIndex
CREATE UNIQUE INDEX "passwordless_codes_link_code_hash_key" ON "auth"."passwordless_codes"("app_id", "tenant_id", "link_code_hash");

-- CreateIndex
CREATE INDEX "passwordless_devices_email_index" ON "auth"."passwordless_devices"("app_id", "tenant_id", "email");

-- CreateIndex
CREATE INDEX "passwordless_devices_phone_number_index" ON "auth"."passwordless_devices"("app_id", "tenant_id", "phone_number");

-- CreateIndex
CREATE INDEX "passwordless_devices_tenant_id_index" ON "auth"."passwordless_devices"("app_id", "tenant_id");

-- CreateIndex
CREATE UNIQUE INDEX "passwordless_user_to_tenant_email_key" ON "auth"."passwordless_user_to_tenant"("app_id", "tenant_id", "email");

-- CreateIndex
CREATE UNIQUE INDEX "passwordless_user_to_tenant_phone_number_key" ON "auth"."passwordless_user_to_tenant"("app_id", "tenant_id", "phone_number");

-- CreateIndex
CREATE INDEX "role_permissions_permission_index" ON "auth"."role_permissions"("app_id", "permission");

-- CreateIndex
CREATE INDEX "role_permissions_role_index" ON "auth"."role_permissions"("app_id", "role");

-- CreateIndex
CREATE INDEX "roles_app_id_index" ON "auth"."roles"("app_id");

-- CreateIndex
CREATE INDEX "access_token_signing_keys_app_id_index" ON "auth"."session_access_token_signing_keys"("app_id");

-- CreateIndex
CREATE INDEX "session_expiry_index" ON "auth"."session_info"("expires_at");

-- CreateIndex
CREATE INDEX "session_info_tenant_id_index" ON "auth"."session_info"("app_id", "tenant_id");

-- CreateIndex
CREATE INDEX "tenant_first_factors_tenant_id_index" ON "auth"."tenant_first_factors"("connection_uri_domain", "app_id", "tenant_id");

-- CreateIndex
CREATE INDEX "tenant_default_required_factor_ids_tenant_id_index" ON "auth"."tenant_required_secondary_factors"("connection_uri_domain", "app_id", "tenant_id");

-- CreateIndex
CREATE INDEX "tenant_thirdparty_provider_clients_third_party_id_index" ON "auth"."tenant_thirdparty_provider_clients"("connection_uri_domain", "app_id", "tenant_id", "third_party_id");

-- CreateIndex
CREATE INDEX "tenant_thirdparty_providers_tenant_id_index" ON "auth"."tenant_thirdparty_providers"("connection_uri_domain", "app_id", "tenant_id");

-- CreateIndex
CREATE INDEX "tenants_app_id_index" ON "auth"."tenants"("app_id");

-- CreateIndex
CREATE UNIQUE INDEX "thirdparty_user_to_tenant_third_party_user_id_key" ON "auth"."thirdparty_user_to_tenant"("app_id", "tenant_id", "third_party_id", "third_party_user_id");

-- CreateIndex
CREATE INDEX "thirdparty_users_email_index" ON "auth"."thirdparty_users"("app_id", "email");

-- CreateIndex
CREATE INDEX "thirdparty_users_thirdparty_user_id_index" ON "auth"."thirdparty_users"("app_id", "third_party_id", "third_party_user_id");

-- CreateIndex
CREATE INDEX "totp_used_codes_expiry_time_ms_index" ON "auth"."totp_used_codes"("app_id", "tenant_id", "expiry_time_ms");

-- CreateIndex
CREATE INDEX "totp_used_codes_tenant_id_index" ON "auth"."totp_used_codes"("app_id", "tenant_id");

-- CreateIndex
CREATE INDEX "totp_used_codes_user_id_index" ON "auth"."totp_used_codes"("app_id", "user_id");

-- CreateIndex
CREATE INDEX "totp_user_devices_user_id_index" ON "auth"."totp_user_devices"("app_id", "user_id");

-- CreateIndex
CREATE INDEX "totp_users_app_id_index" ON "auth"."totp_users"("app_id");

-- CreateIndex
CREATE INDEX "user_last_active_app_id_index" ON "auth"."user_last_active"("app_id");

-- CreateIndex
CREATE INDEX "user_metadata_app_id_index" ON "auth"."user_metadata"("app_id");

-- CreateIndex
CREATE INDEX "user_roles_app_id_role_index" ON "auth"."user_roles"("app_id", "role");

-- CreateIndex
CREATE INDEX "user_roles_role_index" ON "auth"."user_roles"("app_id", "tenant_id", "role");

-- CreateIndex
CREATE INDEX "user_roles_tenant_id_index" ON "auth"."user_roles"("app_id", "tenant_id");

-- CreateIndex
CREATE INDEX "userid_mapping_supertokens_user_id_index" ON "auth"."userid_mapping"("app_id", "supertokens_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "userid_mapping_external_user_id_key" ON "auth"."userid_mapping"("app_id", "external_user_id");

-- CreateIndex
CREATE UNIQUE INDEX "userid_mapping_supertokens_user_id_key" ON "auth"."userid_mapping"("app_id", "supertokens_user_id");

-- AddForeignKey
ALTER TABLE "auth"."all_auth_recipe_users" ADD CONSTRAINT "all_auth_recipe_users_primary_or_recipe_user_id_fkey" FOREIGN KEY ("app_id", "primary_or_recipe_user_id") REFERENCES "auth"."app_id_to_user_id"("app_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."all_auth_recipe_users" ADD CONSTRAINT "all_auth_recipe_users_tenant_id_fkey" FOREIGN KEY ("app_id", "tenant_id") REFERENCES "auth"."tenants"("app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."all_auth_recipe_users" ADD CONSTRAINT "all_auth_recipe_users_user_id_fkey" FOREIGN KEY ("app_id", "user_id") REFERENCES "auth"."app_id_to_user_id"("app_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."app_id_to_user_id" ADD CONSTRAINT "app_id_to_user_id_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."app_id_to_user_id" ADD CONSTRAINT "app_id_to_user_id_primary_or_recipe_user_id_fkey" FOREIGN KEY ("app_id", "primary_or_recipe_user_id") REFERENCES "auth"."app_id_to_user_id"("app_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."dashboard_user_sessions" ADD CONSTRAINT "dashboard_user_sessions_user_id_fkey" FOREIGN KEY ("app_id", "user_id") REFERENCES "auth"."dashboard_users"("app_id", "user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth"."dashboard_users" ADD CONSTRAINT "dashboard_users_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."emailpassword_pswd_reset_tokens" ADD CONSTRAINT "emailpassword_pswd_reset_tokens_user_id_fkey" FOREIGN KEY ("app_id", "user_id") REFERENCES "auth"."app_id_to_user_id"("app_id", "user_id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth"."emailpassword_user_to_tenant" ADD CONSTRAINT "emailpassword_user_to_tenant_user_id_fkey" FOREIGN KEY ("app_id", "tenant_id", "user_id") REFERENCES "auth"."all_auth_recipe_users"("app_id", "tenant_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."emailpassword_users" ADD CONSTRAINT "emailpassword_users_user_id_fkey" FOREIGN KEY ("app_id", "user_id") REFERENCES "auth"."app_id_to_user_id"("app_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."emailverification_tokens" ADD CONSTRAINT "emailverification_tokens_tenant_id_fkey" FOREIGN KEY ("app_id", "tenant_id") REFERENCES "auth"."tenants"("app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."emailverification_verified_emails" ADD CONSTRAINT "emailverification_verified_emails_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."jwt_signing_keys" ADD CONSTRAINT "jwt_signing_keys_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."key_value" ADD CONSTRAINT "key_value_tenant_id_fkey" FOREIGN KEY ("app_id", "tenant_id") REFERENCES "auth"."tenants"("app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."passwordless_codes" ADD CONSTRAINT "passwordless_codes_device_id_hash_fkey" FOREIGN KEY ("app_id", "tenant_id", "device_id_hash") REFERENCES "auth"."passwordless_devices"("app_id", "tenant_id", "device_id_hash") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "auth"."passwordless_devices" ADD CONSTRAINT "passwordless_devices_tenant_id_fkey" FOREIGN KEY ("app_id", "tenant_id") REFERENCES "auth"."tenants"("app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."passwordless_user_to_tenant" ADD CONSTRAINT "passwordless_user_to_tenant_user_id_fkey" FOREIGN KEY ("app_id", "tenant_id", "user_id") REFERENCES "auth"."all_auth_recipe_users"("app_id", "tenant_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."passwordless_users" ADD CONSTRAINT "passwordless_users_user_id_fkey" FOREIGN KEY ("app_id", "user_id") REFERENCES "auth"."app_id_to_user_id"("app_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."role_permissions" ADD CONSTRAINT "role_permissions_role_fkey" FOREIGN KEY ("app_id", "role") REFERENCES "auth"."roles"("app_id", "role") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."roles" ADD CONSTRAINT "roles_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."session_access_token_signing_keys" ADD CONSTRAINT "session_access_token_signing_keys_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."session_info" ADD CONSTRAINT "session_info_tenant_id_fkey" FOREIGN KEY ("app_id", "tenant_id") REFERENCES "auth"."tenants"("app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."tenant_first_factors" ADD CONSTRAINT "tenant_first_factors_tenant_id_fkey" FOREIGN KEY ("connection_uri_domain", "app_id", "tenant_id") REFERENCES "auth"."tenant_configs"("connection_uri_domain", "app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."tenant_required_secondary_factors" ADD CONSTRAINT "tenant_required_secondary_factors_tenant_id_fkey" FOREIGN KEY ("connection_uri_domain", "app_id", "tenant_id") REFERENCES "auth"."tenant_configs"("connection_uri_domain", "app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."tenant_thirdparty_provider_clients" ADD CONSTRAINT "tenant_thirdparty_provider_clients_third_party_id_fkey" FOREIGN KEY ("connection_uri_domain", "app_id", "tenant_id", "third_party_id") REFERENCES "auth"."tenant_thirdparty_providers"("connection_uri_domain", "app_id", "tenant_id", "third_party_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."tenant_thirdparty_providers" ADD CONSTRAINT "tenant_thirdparty_providers_tenant_id_fkey" FOREIGN KEY ("connection_uri_domain", "app_id", "tenant_id") REFERENCES "auth"."tenant_configs"("connection_uri_domain", "app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."tenants" ADD CONSTRAINT "tenants_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."thirdparty_user_to_tenant" ADD CONSTRAINT "thirdparty_user_to_tenant_user_id_fkey" FOREIGN KEY ("app_id", "tenant_id", "user_id") REFERENCES "auth"."all_auth_recipe_users"("app_id", "tenant_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."thirdparty_users" ADD CONSTRAINT "thirdparty_users_user_id_fkey" FOREIGN KEY ("app_id", "user_id") REFERENCES "auth"."app_id_to_user_id"("app_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."totp_used_codes" ADD CONSTRAINT "totp_used_codes_tenant_id_fkey" FOREIGN KEY ("app_id", "tenant_id") REFERENCES "auth"."tenants"("app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."totp_used_codes" ADD CONSTRAINT "totp_used_codes_user_id_fkey" FOREIGN KEY ("app_id", "user_id") REFERENCES "auth"."totp_users"("app_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."totp_user_devices" ADD CONSTRAINT "totp_user_devices_user_id_fkey" FOREIGN KEY ("app_id", "user_id") REFERENCES "auth"."totp_users"("app_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."totp_users" ADD CONSTRAINT "totp_users_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."user_last_active" ADD CONSTRAINT "user_last_active_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."user_metadata" ADD CONSTRAINT "user_metadata_app_id_fkey" FOREIGN KEY ("app_id") REFERENCES "auth"."apps"("app_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."user_roles" ADD CONSTRAINT "user_roles_tenant_id_fkey" FOREIGN KEY ("app_id", "tenant_id") REFERENCES "auth"."tenants"("app_id", "tenant_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "auth"."userid_mapping" ADD CONSTRAINT "userid_mapping_supertokens_user_id_fkey" FOREIGN KEY ("app_id", "supertokens_user_id") REFERENCES "auth"."app_id_to_user_id"("app_id", "user_id") ON DELETE CASCADE ON UPDATE NO ACTION;

-- AddForeignKey
ALTER TABLE "public"."payment_accounts" ADD CONSTRAINT "payment_accounts_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."all_auth_recipe_users"("user_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."transactions" ADD CONSTRAINT "transactions_payment_account_id_fkey" FOREIGN KEY ("payment_account_id") REFERENCES "public"."payment_accounts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
