-- =============================================================
-- Finance Tracker — Sample Dev/Test Data
-- Run manually against a local dev database only.
-- DO NOT run in production.
-- Usage: psql -U finance_user -d finance_tracker -f 001-sample-data.sql
-- =============================================================

-- Sample members
INSERT INTO member (first_name, last_name, email, password, username, occupation, phone_number, profile_status)
VALUES
    ('John',  'Doe',   'john.doe@example.com',  'password123', 'johndoe',   'Software Engineer', '555-100-0001', 'ACTIVE'),
    ('Jane',  'Smith', 'jane.smith@example.com', 'password123', 'janesmith', 'Designer',          '555-100-0002', 'ACTIVE'),
    ('Alex',  'Brown', 'alex.brown@example.com', 'password123', 'alexbrown', 'Product Manager',   '555-100-0003', 'ACTIVE');

-- Sample expenses for John (id=1)
INSERT INTO expense (member_id, expense_name, amount, category, description, expense_date)
VALUES
    (1, 'Grocery Run',       250.00, 'FOOD',          'Weekly groceries',        CURRENT_DATE - INTERVAL '2 days'),
    (1, 'Netflix',            18.99, 'SUBSCRIPTIONS', 'Monthly streaming',        CURRENT_DATE - INTERVAL '5 days'),
    (1, 'Spotify',            10.99, 'SUBSCRIPTIONS', 'Music subscription',       CURRENT_DATE - INTERVAL '5 days'),
    (1, 'Hydro Bill',        120.00, 'UTILITIES',     'Monthly electricity bill', CURRENT_DATE - INTERVAL '10 days'),
    (1, 'TTC Monthly Pass',  156.00, 'TRANSPORT',     'Public transit pass',      CURRENT_DATE - INTERVAL '1 day'),
    (1, 'Restaurant',         85.00, 'FOOD',          'Dinner with friends',      CURRENT_DATE - INTERVAL '3 days'),
    (1, 'Gym Membership',     50.00, 'HEALTH',        'Monthly gym fee',          CURRENT_DATE - INTERVAL '7 days'),
    (1, 'Movie Tickets',      35.00, 'ENTERTAINMENT', 'Weekend movies',           CURRENT_DATE - INTERVAL '4 days'),
    (1, 'Flight Booking',    450.00, 'TRAVEL',        'Trip to NYC',              CURRENT_DATE - INTERVAL '15 days'),
    (1, 'Internet Bill',      80.00, 'UTILITIES',     'Monthly internet',         CURRENT_DATE - INTERVAL '8 days');

-- Sample savings goal for John
INSERT INTO savings_goal (member_id, goal_name, target_amount, current_amount, monthly_savings_target, income, target_date, status)
VALUES
    (1, 'Emergency Fund', 10000.00, 1500.00, 500.00, 5000.00, CURRENT_DATE + INTERVAL '18 months', 'ACTIVE'),
    (1, 'Vacation Fund',   3000.00,  300.00, 200.00, 5000.00, CURRENT_DATE + INTERVAL '12 months', 'ACTIVE');
