-- ============================================================
-- SCHEMA: ods
-- TABLE:  ods.expense
-- Desc:   Expenses logged by the user. Category validated against ref.expense_category.
-- ============================================================

CREATE TABLE IF NOT EXISTS ods.expense (
    id               BIGSERIAL       PRIMARY KEY,
    member_id        BIGINT          NOT NULL,
    expense_name     VARCHAR(255)    NOT NULL,
    amount           NUMERIC(10,2)   NOT NULL,
    category         VARCHAR(50),
    description      VARCHAR(500),
    expense_date     DATE            NOT NULL,
    account_id       BIGINT,
    statement_id     BIGINT,
    transaction_type VARCHAR(30)     DEFAULT 'DEBIT',
    created_at       TIMESTAMP       DEFAULT NOW(),

    CONSTRAINT fk_ods_expense_member
        FOREIGN KEY (member_id)    REFERENCES ods.member(id),
    CONSTRAINT fk_ods_expense_account
        FOREIGN KEY (account_id)   REFERENCES ods.financial_account(id),
    CONSTRAINT fk_ods_expense_statement
        FOREIGN KEY (statement_id) REFERENCES ods.account_statement(id)
);

COMMENT ON TABLE  ods.expense IS 'User-submitted expense records';
COMMENT ON COLUMN ods.expense.category         IS 'FK → ref.expense_category.code';
COMMENT ON COLUMN ods.expense.transaction_type IS 'DEBIT | CREDIT | TRANSFER';
