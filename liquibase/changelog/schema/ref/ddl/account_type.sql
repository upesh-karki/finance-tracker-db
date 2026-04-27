-- ============================================================
-- SCHEMA: ref
-- TABLE:  ref.account_type
-- Desc:   Financial account type codes (CHEQUING, SAVINGS, CREDIT, etc.)
-- ============================================================

CREATE TABLE IF NOT EXISTS ref.account_type (
    code        VARCHAR(30)   PRIMARY KEY,
    label       VARCHAR(100)  NOT NULL,
    description VARCHAR(255),
    sort_order  INT           DEFAULT 0,
    is_active   BOOLEAN       DEFAULT TRUE
);

COMMENT ON TABLE ref.account_type IS 'Financial account type reference data';
