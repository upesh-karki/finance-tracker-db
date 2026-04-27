-- ============================================================
-- SCHEMA: ods
-- TABLE:  ods.email_otp
-- Desc:   One-time passwords for email verification flow.
-- ============================================================

CREATE TABLE IF NOT EXISTS ods.email_otp (
    id          BIGSERIAL    PRIMARY KEY,
    member_id   BIGINT       NOT NULL,
    otp_code    VARCHAR(6)   NOT NULL,
    expires_at  TIMESTAMP    NOT NULL,
    used        BOOLEAN      NOT NULL DEFAULT FALSE,
    created_at  TIMESTAMP    DEFAULT NOW(),

    CONSTRAINT fk_ods_email_otp_member
        FOREIGN KEY (member_id) REFERENCES ods.member(id)
);

COMMENT ON TABLE ods.email_otp IS 'Email OTP codes for 2-step verification — expires after 2 minutes';
