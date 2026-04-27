-- ============================================================
-- SCHEMA: rpt
-- VIEW:   rpt.vw_expense_category_breakdown
-- Desc:   Expense stats by member and category.
-- ============================================================

CREATE OR REPLACE VIEW rpt.vw_expense_category_breakdown AS
SELECT
    e.member_id,
    e.category,
    rc.label                AS category_label,
    COUNT(*)                AS expense_count,
    SUM(e.amount)           AS total_amount,
    AVG(e.amount)           AS avg_amount,
    MIN(e.expense_date)     AS first_expense,
    MAX(e.expense_date)     AS last_expense
FROM ods.expense e
LEFT JOIN ref.expense_category rc ON rc.code = e.category
GROUP BY e.member_id, e.category, rc.label;

COMMENT ON VIEW rpt.vw_expense_category_breakdown IS 'Expense stats by member and category for spending analysis';
