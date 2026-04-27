-- ============================================================
-- SCHEMA: rpt
-- TABLE:  rpt.member_monthly_summary
-- Desc:   Pre-aggregated monthly expense totals per member.
--         Computed by reporting engine for fast dashboard queries.
--         Do NOT write to this table from user-facing endpoints.
-- ============================================================

CREATE TABLE IF NOT EXISTS rpt.member_monthly_summary (
    id             BIGSERIAL       PRIMARY KEY,
    member_id      BIGINT          NOT NULL,
    summary_year   INT             NOT NULL,
    summary_month  INT             NOT NULL,
    category       VARCHAR(50),
    total_amount   NUMERIC(10,2),
    expense_count  INT,
    computed_at    TIMESTAMP       DEFAULT NOW(),

    CONSTRAINT fk_rpt_monthly_summary_member
        FOREIGN KEY (member_id) REFERENCES ods.member(id),
    CONSTRAINT uq_rpt_monthly_summary
        UNIQUE (member_id, summary_year, summary_month, category)
);

COMMENT ON TABLE rpt.member_monthly_summary IS 'Pre-aggregated monthly expense totals — output of reporting engine';
