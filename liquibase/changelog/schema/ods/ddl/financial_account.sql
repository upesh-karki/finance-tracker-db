-- ============================================================
-- SCHEMA: ods
-- TABLE:  ods.financial_account
-- Desc:   User's financial accounts (bank, credit card, investment).
--         institution_code FK → ref.financial_institution.code
-- ============================================================

CREATE TABLE IF NOT EXISTS ods.financial_account (
    id                   BIGSERIAL       PRIMARY KEY,
    member_id            BIGINT          NOT NULL,
    nickname             VARCHAR(100)    NOT NULL,
    institution_name     VARCHAR(100)    NOT NULL,
    institution_code     VARCHAR(30),
    account_type_code    VARCHAR(30)     NOT NULL,
    opened_date          DATE,
    tracking_start_date  DATE            NOT NULL,
    is_active            BOOLEAN         NOT NULL DEFAULT TRUE,
    created_at           TIMESTAMP       DEFAULT NOW(),
    updated_at           TIMESTAMP       DEFAULT NOW(),

    CONSTRAINT fk_ods_financial_account_member
        FOREIGN KEY (member_id)         REFERENCES ods.member(id),
    CONSTRAINT fk_ods_financial_account_type
        FOREIGN KEY (account_type_code) REFERENCES ref.account_type(code)
);

COMMENT ON TABLE  ods.financial_account IS 'User financial accounts — bank, credit card, investment';
COMMENT ON COLUMN ods.financial_account.institution_code IS 'FK → ref.financial_institution.code';
