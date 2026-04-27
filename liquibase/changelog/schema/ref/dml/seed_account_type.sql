-- ============================================================
-- SCHEMA: ref
-- DML:    ref.account_type — seed data
-- ============================================================

INSERT INTO ref.account_type (code, label, sort_order) VALUES
    ('CHEQUING',    'Chequing Account',    1),
    ('SAVINGS',     'Savings Account',     2),
    ('CREDIT_CARD', 'Credit Card',         3),
    ('INVESTMENT',  'Investment Account',  4),
    ('OTHER',       'Other',               5)
ON CONFLICT (code) DO NOTHING;
