-- ============================================================
-- SCHEMA: ods
-- INDEXES: all ODS table indexes
-- ============================================================

-- ods.member
CREATE UNIQUE INDEX IF NOT EXISTS idx_member_email    ON ods.member (email);
CREATE UNIQUE INDEX IF NOT EXISTS idx_member_username ON ods.member (username);

-- ods.expense
CREATE INDEX IF NOT EXISTS idx_expense_member_id       ON ods.expense (member_id);
CREATE INDEX IF NOT EXISTS idx_expense_member_category ON ods.expense (member_id, category);
CREATE INDEX IF NOT EXISTS idx_expense_member_date     ON ods.expense (member_id, expense_date);

-- ods.savings_goal
CREATE INDEX IF NOT EXISTS idx_savings_goal_member  ON ods.savings_goal (member_id);

-- ods.financial_account
CREATE INDEX IF NOT EXISTS idx_financial_account_member ON ods.financial_account (member_id);

-- ods.account_statement
CREATE INDEX IF NOT EXISTS idx_account_statement_account ON ods.account_statement (account_id);
CREATE INDEX IF NOT EXISTS idx_account_statement_member  ON ods.account_statement (member_id);

-- ods.income
CREATE INDEX IF NOT EXISTS idx_income_member  ON ods.income (member_id);
CREATE INDEX IF NOT EXISTS idx_income_account ON ods.income (account_id);
CREATE INDEX IF NOT EXISTS idx_income_date    ON ods.income (income_date);

-- ods.email_otp
CREATE INDEX IF NOT EXISTS idx_email_otp_member ON ods.email_otp (member_id);
