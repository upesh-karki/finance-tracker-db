-- ============================================================
-- FUNCTION: ods.fn_get_member_savings_rate
-- Desc:     Returns the savings rate % for a member based on income vs
--           current month expenses.
-- ============================================================

CREATE OR REPLACE FUNCTION ods.fn_get_member_savings_rate(
    p_member_id BIGINT
) RETURNS NUMERIC AS $$
DECLARE
    v_income         NUMERIC;
    v_total_expenses NUMERIC;
BEGIN
    SELECT COALESCE(MAX(income), 0) INTO v_income
    FROM ods.savings_goal
    WHERE member_id = p_member_id AND status = 'ACTIVE';

    SELECT COALESCE(SUM(amount), 0) INTO v_total_expenses
    FROM ods.expense
    WHERE member_id  = p_member_id
      AND expense_date >= DATE_TRUNC('month', CURRENT_DATE);

    IF v_income = 0 THEN RETURN 0; END IF;
    RETURN ROUND(((v_income - v_total_expenses) / v_income) * 100, 2);
END;
$$ LANGUAGE plpgsql;
