-- ============================================================
-- SCHEMA: ref
-- TABLE:  ref.income_category
-- Desc:   Valid income category codes.
-- ============================================================

CREATE TABLE IF NOT EXISTS ref.income_category (
    code        VARCHAR(30)   PRIMARY KEY,
    label       VARCHAR(100)  NOT NULL,
    description VARCHAR(255),
    sort_order  INT           DEFAULT 0,
    is_active   BOOLEAN       DEFAULT TRUE
);

COMMENT ON TABLE ref.income_category IS 'Income category reference data';
