-- ============================================================
-- SCHEMA: ref
-- DML:    ref.expense_category — seed data
-- ============================================================

INSERT INTO ref.expense_category (code, label, description, sort_order) VALUES
    ('FOOD',          'Food & Dining',     'Groceries, restaurants, coffee, takeout',            1),
    ('TRANSPORT',     'Transport',         'Public transit, gas, parking, rideshare',             2),
    ('UTILITIES',     'Utilities',         'Electricity, water, gas, internet, phone',            3),
    ('SUBSCRIPTIONS', 'Subscriptions',     'Streaming services, software, memberships',           4),
    ('ENTERTAINMENT', 'Entertainment',     'Movies, events, hobbies, games',                      5),
    ('TRAVEL',        'Travel',            'Flights, hotels, vacation expenses',                  6),
    ('HEALTH',        'Health & Fitness',  'Gym, pharmacy, medical, dental',                      7),
    ('INVESTMENT',    'Investment',        'Contributions to investment/brokerage accounts — neutral', 8),
    ('OTHER',         'Other',             'Anything that does not fit another category',         9)
ON CONFLICT (code) DO NOTHING;
