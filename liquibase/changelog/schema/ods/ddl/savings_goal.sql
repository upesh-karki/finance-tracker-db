-- ============================================================
-- SCHEMA: ods
-- TABLE:  ods.savings_goal
-- Desc:   Savings targets defined by the user.
-- ============================================================

CREATE TABLE IF NOT EXISTS ods.savings_goal (
    id             BIGSERIAL       PRIMARY KEY,
    member_id      BIGINT          NOT NULL,
    goal_name      VARCHAR(255)    NOT NULL,
    target_amount  NUMERIC(12,2)   NOT NULL,
    current_amount NUMERIC(12,2)   DEFAULT 0,
    income         NUMERIC(12,2),
    target_date    DATE,
    status         VARCHAR(20)     DEFAULT 'ACTIVE',
    created_at     TIMESTAMP       DEFAULT NOW(),
    updated_at     TIMESTAMP       DEFAULT NOW(),

    CONSTRAINT fk_ods_savings_goal_member
        FOREIGN KEY (member_id) REFERENCES ods.member(id)
);

COMMENT ON TABLE  ods.savings_goal IS 'User-defined savings goals';
COMMENT ON COLUMN ods.savings_goal.status IS 'ACTIVE | COMPLETED | PAUSED | CANCELLED';
