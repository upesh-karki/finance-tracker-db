-- ============================================================
-- SCHEMA: ref
-- VIEW:   ref.vw_expense_categories_active
-- Desc:   Active expense categories for UI dropdowns.
-- ============================================================

CREATE OR REPLACE VIEW ref.vw_expense_categories_active AS
SELECT code, label, description, icon, sort_order
FROM ref.expense_category
WHERE is_active = TRUE
ORDER BY sort_order;

COMMENT ON VIEW ref.vw_expense_categories_active IS 'Active expense categories for UI dropdowns';
