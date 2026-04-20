-- =============================================================
-- Finance Tracker — Reference DDL
-- This is for documentation only. Schema is managed by Liquibase.
-- Source of truth: finance-tracker-api/src/main/resources/db/changelog/
-- =============================================================

-- ---------------------------------------------------------------
-- member
-- ---------------------------------------------------------------
CREATE TABLE member (
    id             BIGSERIAL PRIMARY KEY,
    first_name     VARCHAR(100),
    last_name      VARCHAR(100),
    email          VARCHAR(255) NOT NULL UNIQUE,
    password       VARCHAR(255) NOT NULL,
    username       VARCHAR(100) UNIQUE,
    occupation     VARCHAR(100),
    phone_number   VARCHAR(30),
    profile_status VARCHAR(20)  DEFAULT 'ACTIVE',
    created_at     TIMESTAMP    DEFAULT NOW()
);

-- ---------------------------------------------------------------
-- member_detail
-- ---------------------------------------------------------------
CREATE TABLE member_detail (
    id             BIGSERIAL PRIMARY KEY,
    member_id      BIGINT NOT NULL REFERENCES member(id),
    occupation     VARCHAR(100),
    address1       VARCHAR(255),
    address2       VARCHAR(255),
    city           VARCHAR(100),
    country        VARCHAR(100),
    zip_code       VARCHAR(20),
    phone_number   VARCHAR(30),
    profile_status VARCHAR(20)  DEFAULT 'ACTIVE',
    created_at     TIMESTAMP    DEFAULT NOW()
);

-- ---------------------------------------------------------------
-- expense
-- ---------------------------------------------------------------
-- category values: FOOD, TRANSPORT, UTILITIES, SUBSCRIPTIONS,
--                  ENTERTAINMENT, TRAVEL, HEALTH, OTHER
CREATE TABLE expense (
    id             BIGSERIAL PRIMARY KEY,
    member_id      BIGINT         NOT NULL REFERENCES member(id),
    expense_name   VARCHAR(255)   NOT NULL,
    amount         NUMERIC(10, 2) NOT NULL,
    category       VARCHAR(50),
    description    VARCHAR(500),
    expense_date   DATE,
    created_at     TIMESTAMP DEFAULT NOW()
);

-- ---------------------------------------------------------------
-- savings_goal
-- ---------------------------------------------------------------
-- status values: ACTIVE, ACHIEVED, CANCELLED
CREATE TABLE savings_goal (
    id                     BIGSERIAL PRIMARY KEY,
    member_id              BIGINT         NOT NULL REFERENCES member(id),
    goal_name              VARCHAR(255)   NOT NULL,
    target_amount          NUMERIC(10, 2),
    current_amount         NUMERIC(10, 2) DEFAULT 0,
    monthly_savings_target NUMERIC(10, 2),
    income                 NUMERIC(10, 2),
    target_date            DATE,
    status                 VARCHAR(20)    DEFAULT 'ACTIVE',
    created_at             TIMESTAMP DEFAULT NOW()
);
