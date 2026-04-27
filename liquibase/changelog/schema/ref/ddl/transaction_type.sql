-- ============================================================
-- SCHEMA: ref
-- TABLE:  ref.transaction_type
-- Desc:   Transaction type codes used when importing statement rows.
-- ============================================================

CREATE TABLE IF NOT EXISTS ref.transaction_type (
    code        VARCHAR(30)   PRIMARY KEY,
    label       VARCHAR(100)  NOT NULL,
    description VARCHAR(255),
    sort_order  INT           DEFAULT 0,
    is_active   BOOLEAN       DEFAULT TRUE
);

COMMENT ON TABLE ref.transaction_type IS 'Transaction type reference — EXPENSE, INCOME, TRANSFER, CC_PAYMENT, INVESTMENT';
