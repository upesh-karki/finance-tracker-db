-- ============================================================
-- SCHEMA: rpt
-- VIEW:   rpt.vw_member_savings_overview
-- Desc:   Income vs expenses vs savings goals per member.
-- ============================================================

CREATE OR REPLACE VIEW rpt.vw_member_savings_overview AS
SELECT
    m.id                                                     AS member_id,
    m.first_name || ' ' || m.last_name                       AS full_name,
    COALESCE(sg.income, 0)                                   AS monthly_income,
    COALESCE(SUM(e.amount), 0)                               AS total_expenses,
    COALESCE(sg.income, 0) - COALESCE(SUM(e.amount), 0)     AS net_savings,
    COUNT(DISTINCT sg.id)                                    AS active_goals,
    COALESCE(SUM(sg.target_amount), 0)                       AS total_goals_target,
    COALESCE(SUM(sg.current_amount), 0)                      AS total_goals_saved
FROM ods.member m
LEFT JOIN ods.expense     e  ON e.member_id  = m.id
LEFT JOIN ods.savings_goal sg ON sg.member_id = m.id AND sg.status = 'ACTIVE'
GROUP BY m.id, m.first_name, m.last_name, sg.income;

COMMENT ON VIEW rpt.vw_member_savings_overview IS 'Income vs expenses vs savings goals per member';
