-- ============================================================
-- SCHEMA: ods
-- TABLE:  ods.income
-- Desc:   Income records — imported from statements or manually entered.
-- ============================================================

CREATE TABLE IF NOT EXISTS ods.income (
    id                   BIGSERIAL       PRIMARY KEY,
    member_id            BIGINT          NOT NULL,
    account_id           BIGINT,
    statement_id         BIGINT,
    source_name          VARCHAR(255)    NOT NULL,
    amount               NUMERIC(12,2)   NOT NULL,
    income_category_code VARCHAR(30)     NOT NULL,
    income_date          DATE            NOT NULL,
    description          VARCHAR(500),
    created_at           TIMESTAMP       DEFAULT NOW(),

    CONSTRAINT fk_ods_income_member
        FOREIGN KEY (member_id)    REFERENCES ods.member(id),
    CONSTRAINT fk_ods_income_account
        FOREIGN KEY (account_id)   REFERENCES ods.financial_account(id),
    CONSTRAINT fk_ods_income_statement
        FOREIGN KEY (statement_id) REFERENCES ods.account_statement(id),
    CONSTRAINT fk_ods_income_category
        FOREIGN KEY (income_category_code) REFERENCES ref.income_category(code)
);

COMMENT ON TABLE  ods.income IS 'Income records — from statements or manual entry';
COMMENT ON COLUMN ods.income.income_category_code IS 'FK → ref.income_category.code';
