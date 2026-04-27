-- ============================================================
-- FUNCTION: ods.fn_get_member_monthly_total
-- Desc:     Returns total expense amount for a member in a given year/month.
-- ============================================================

CREATE OR REPLACE FUNCTION ods.fn_get_member_monthly_total(
    p_member_id BIGINT,
    p_year      INT,
    p_month     INT
) RETURNS NUMERIC AS $$
BEGIN
    RETURN COALESCE((
        SELECT SUM(amount)
        FROM ods.expense
        WHERE member_id = p_member_id
          AND EXTRACT(YEAR  FROM expense_date) = p_year
          AND EXTRACT(MONTH FROM expense_date) = p_month
    ), 0);
END;
$$ LANGUAGE plpgsql;
