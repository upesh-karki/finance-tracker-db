-- ============================================================
-- FUNCTION: ods.fn_get_category_summary
-- Desc:     Returns per-category expense totals and % of grand total
--           for a given member.
-- ============================================================

CREATE OR REPLACE FUNCTION ods.fn_get_category_summary(
    p_member_id BIGINT
) RETURNS TABLE(category VARCHAR, total NUMERIC, percentage NUMERIC) AS $$
DECLARE
    v_grand_total NUMERIC;
BEGIN
    SELECT COALESCE(SUM(amount), 0) INTO v_grand_total
    FROM ods.expense
    WHERE member_id = p_member_id;

    RETURN QUERY
    SELECT  e.category,
            SUM(e.amount)                                                          AS total,
            CASE WHEN v_grand_total = 0 THEN 0
                 ELSE ROUND((SUM(e.amount) / v_grand_total) * 100, 2)
            END                                                                    AS percentage
    FROM ods.expense e
    WHERE e.member_id = p_member_id
    GROUP BY e.category
    ORDER BY total DESC;
END;
$$ LANGUAGE plpgsql;
