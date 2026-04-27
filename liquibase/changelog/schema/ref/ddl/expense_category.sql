-- ============================================================
-- SCHEMA: ref
-- TABLE:  ref.expense_category
-- Desc:   Valid expense category codes. Read-only from application code.
-- ============================================================

CREATE TABLE IF NOT EXISTS ref.expense_category (
    code        VARCHAR(50)   PRIMARY KEY,
    label       VARCHAR(100)  NOT NULL,
    description VARCHAR(255),
    icon        VARCHAR(50),
    sort_order  INT           DEFAULT 0,
    is_active   BOOLEAN       DEFAULT TRUE
);

COMMENT ON TABLE ref.expense_category IS 'Expense category reference data — app enum must stay in sync';
