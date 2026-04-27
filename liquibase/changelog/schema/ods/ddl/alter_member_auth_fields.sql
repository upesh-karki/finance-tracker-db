-- ============================================================
-- SCHEMA: ods
-- ALTER:  ods.member — add auth fields (v1.2)
-- Desc:   Adds email_verified, auth_provider, google_id
--         to support Google OAuth + email OTP flows.
-- ============================================================

ALTER TABLE ods.member
    ADD COLUMN IF NOT EXISTS email_verified BOOLEAN      NOT NULL DEFAULT FALSE,
    ADD COLUMN IF NOT EXISTS auth_provider  VARCHAR(20)  NOT NULL DEFAULT 'LOCAL',
    ADD COLUMN IF NOT EXISTS google_id      VARCHAR(255);

COMMENT ON COLUMN ods.member.auth_provider IS 'LOCAL | GOOGLE';
COMMENT ON COLUMN ods.member.google_id     IS 'Google subject ID when auth_provider = GOOGLE';
