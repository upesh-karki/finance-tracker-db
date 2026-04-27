-- ============================================================
-- SCHEMA: ref
-- DML:    ref.transaction_type — seed data
-- ============================================================

INSERT INTO ref.transaction_type (code, label, description, sort_order) VALUES
    ('EXPENSE',    'Expense',              'Money spent on goods or services',              1),
    ('INCOME',     'Income',               'Money received',                                2),
    ('INVESTMENT', 'Investment',           'Money moved to investment accounts',             3),
    ('TRANSFER',   'Transfer',             'Internal transfer between own accounts',         4),
    ('CC_PAYMENT', 'Credit Card Payment',  'Payment made to a credit card from chequing',   5)
ON CONFLICT (code) DO NOTHING;
