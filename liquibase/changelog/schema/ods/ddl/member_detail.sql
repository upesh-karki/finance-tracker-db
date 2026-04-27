-- ============================================================
-- SCHEMA: ods
-- TABLE:  ods.member_detail
-- Desc:   Extended profile info for a member. One-to-one with ods.member.
-- ============================================================

CREATE TABLE IF NOT EXISTS ods.member_detail (
    id             BIGSERIAL       PRIMARY KEY,
    member_id      BIGINT          NOT NULL UNIQUE,
    occupation     VARCHAR(100),
    phone_number   VARCHAR(30),
    date_of_birth  DATE,
    address        VARCHAR(500),
    created_at     TIMESTAMP       DEFAULT NOW(),
    updated_at     TIMESTAMP       DEFAULT NOW(),

    CONSTRAINT fk_ods_member_detail_member
        FOREIGN KEY (member_id) REFERENCES ods.member(id)
);

COMMENT ON TABLE ods.member_detail IS 'Extended profile — one-to-one with ods.member';
