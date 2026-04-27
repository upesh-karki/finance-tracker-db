-- ============================================================
-- SCHEMA: ref
-- TABLE:  ref.status_codes
-- Desc:   Generic status code lookup for profile_status etc.
-- ============================================================

CREATE TABLE IF NOT EXISTS ref.status_codes (
    code        VARCHAR(30)   PRIMARY KEY,
    label       VARCHAR(100)  NOT NULL,
    description VARCHAR(255),
    entity_type VARCHAR(50),
    is_active   BOOLEAN       DEFAULT TRUE
);

COMMENT ON TABLE ref.status_codes IS 'Generic status codes used across ods entities';
