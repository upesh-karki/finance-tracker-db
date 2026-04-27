-- ============================================================
-- SCHEMA: rpt
-- VIEW:   rpt.vw_member_expense_summary
-- Desc:   Per-member expense totals — output for dashboard.
-- ============================================================

CREATE OR REPLACE VIEW rpt.vw_member_expense_summary AS
SELECT
    m.id                                AS member_id,
    m.first_name || ' ' || m.last_name  AS full_name,
    m.email,
    COUNT(e.id)                         AS total_expense_count,
    COALESCE(SUM(e.amount), 0)          AS total_expenses,
    COUNT(DISTINCT e.category)          AS category_count,
    MAX(e.expense_date)                 AS latest_expense_date
FROM ods.member m
LEFT JOIN ods.expense e ON e.member_id = m.id
GROUP BY m.id, m.first_name, m.last_name, m.email;

COMMENT ON VIEW rpt.vw_member_expense_summary IS 'Per-member expense totals for dashboard';
