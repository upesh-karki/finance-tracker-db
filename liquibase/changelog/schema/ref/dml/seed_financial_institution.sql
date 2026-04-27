-- ============================================================
-- SCHEMA: ref
-- DML:    ref.financial_institution — seed data
-- ============================================================

INSERT INTO ref.financial_institution (code, name, country) VALUES
    ('CHASE',        'Chase',                'US'),
    ('BOFA',         'Bank of America',      'US'),
    ('WELLS_FARGO',  'Wells Fargo',          'US'),
    ('CITI',         'Citi',                 'US'),
    ('DISCOVER',     'Discover',             'US'),
    ('CAPITAL_ONE',  'Capital One',          'US'),
    ('TD',           'TD Bank',              'US'),
    ('US_BANK',      'U.S. Bank',            'US'),
    ('PNC',          'PNC Bank',             'US'),
    ('RBC',          'RBC Royal Bank',       'CA'),
    ('TD_CA',        'TD Canada Trust',      'CA'),
    ('SCOTIABANK',   'Scotiabank',           'CA'),
    ('BMO',          'BMO Bank of Montreal', 'CA'),
    ('CIBC',         'CIBC',                 'CA'),
    ('OTHER',        'Other',                '')
ON CONFLICT (code) DO NOTHING;
