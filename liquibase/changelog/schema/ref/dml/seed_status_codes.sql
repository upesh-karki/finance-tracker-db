-- ============================================================
-- SCHEMA: ref
-- DML:    ref.status_codes — seed data
-- ============================================================

INSERT INTO ref.status_codes (code, label, description, entity_type) VALUES
    ('ACTIVE',     'Active',     'Account is active and in good standing',        'MEMBER'),
    ('INACTIVE',   'Inactive',   'Account exists but user has not logged in recently', 'MEMBER'),
    ('SUSPENDED',  'Suspended',  'Account has been suspended by an administrator', 'MEMBER'),
    ('ACHIEVED',   'Achieved',   'Target amount has been reached',                'SAVINGS_GOAL'),
    ('PAUSED',     'Paused',     'Goal is temporarily paused',                    'SAVINGS_GOAL'),
    ('CANCELLED',  'Cancelled',  'Goal was cancelled by the user',                'SAVINGS_GOAL'),
    ('PENDING',    'Pending',    'Statement not yet uploaded',                    'STATEMENT'),
    ('UPLOADED',   'Uploaded',   'Statement has been uploaded and processed',     'STATEMENT')
ON CONFLICT (code) DO NOTHING;
