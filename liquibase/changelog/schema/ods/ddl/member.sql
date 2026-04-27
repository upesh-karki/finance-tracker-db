-- ============================================================
-- SCHEMA: ods
-- TABLE:  ods.member
-- Desc:   Core user accounts. Input from registration form.
-- ============================================================

CREATE TABLE IF NOT EXISTS ods.member (
    id             BIGSERIAL       PRIMARY KEY,
    first_name     VARCHAR(100),
    last_name      VARCHAR(100),
    email          VARCHAR(255)    NOT NULL UNIQUE,
    password       VARCHAR(255)    NOT NULL,
    username       VARCHAR(100)    UNIQUE,
    profile_status VARCHAR(20)     DEFAULT 'ACTIVE',
    created_at     TIMESTAMP       DEFAULT NOW()
);

COMMENT ON TABLE  ods.member IS 'Registered user accounts — input from user registration';
COMMENT ON COLUMN ods.member.profile_status IS 'ACTIVE | INACTIVE | SUSPENDED';
