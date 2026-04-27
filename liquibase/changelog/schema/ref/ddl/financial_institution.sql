-- ============================================================
-- SCHEMA: ref
-- TABLE:  ref.financial_institution
-- Desc:   Bank/institution reference data. institution_code on
--         ods.financial_account must reference this table.
-- ============================================================

CREATE TABLE IF NOT EXISTS ref.financial_institution (
    code       VARCHAR(30)   PRIMARY KEY,
    name       VARCHAR(100)  NOT NULL,
    country    VARCHAR(10)   DEFAULT 'US',
    is_active  BOOLEAN       NOT NULL DEFAULT TRUE
);

COMMENT ON TABLE ref.financial_institution IS 'Financial institution reference — used as FK on ods.financial_account';
