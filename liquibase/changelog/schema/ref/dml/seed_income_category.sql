-- ============================================================
-- SCHEMA: ref
-- DML:    ref.income_category — seed data
-- ============================================================

INSERT INTO ref.income_category (code, label, description, sort_order) VALUES
    ('SALARY',     'Salary',        'Regular employment income',              1),
    ('FREELANCE',  'Freelance',     'Self-employment or contract income',      2),
    ('INVESTMENT', 'Investment',    'Dividends, interest, capital gains',      3),
    ('REFUND',     'Refund',        'Refunds and reimbursements',              4),
    ('TRANSFER',   'Transfer',      'Incoming bank transfers',                 5),
    ('OTHER',      'Other',         'Income that does not fit another category', 6)
ON CONFLICT (code) DO NOTHING;
