-- ============================================================
-- SCHEMA: ods
-- TABLE:  ods.account_statement
-- Desc:   Tracks which months have had bank statements uploaded
--         for each financial_account. status: PENDING | UPLOADED
-- ============================================================

CREATE TABLE IF NOT EXISTS ods.account_statement (
    id            BIGSERIAL    PRIMARY KEY,
    account_id    BIGINT       NOT NULL,
    member_id     BIGINT       NOT NULL,
    statement_year  INT        NOT NULL,
    statement_month INT        NOT NULL,
    status        VARCHAR(20)  NOT NULL DEFAULT 'PENDING',
    uploaded_at   TIMESTAMP,
    created_at    TIMESTAMP    DEFAULT NOW(),

    CONSTRAINT fk_ods_account_statement_account
        FOREIGN KEY (account_id) REFERENCES ods.financial_account(id),
    CONSTRAINT fk_ods_account_statement_member
        FOREIGN KEY (member_id)  REFERENCES ods.member(id),
    CONSTRAINT uq_ods_account_statement_account_month
        UNIQUE (account_id, statement_year, statement_month)
);

COMMENT ON TABLE  ods.account_statement IS 'Statement upload tracking per account per month';
COMMENT ON COLUMN ods.account_statement.status IS 'PENDING | UPLOADED';
