-- ============================================================
-- SCHEMA: dbutils
-- Purpose: Audit schema for Liquibase deployment tracking.
--
-- Liquibase is configured (via liquibase.properties) to store its
-- DATABASECHANGELOG table in this schema as "changelog_audit".
-- Liquibase auto-creates and manages the table structure.
--
-- This file just ensures the schema exists before Liquibase runs
-- and adds a comment explaining the schema's purpose.
-- ============================================================

CREATE SCHEMA IF NOT EXISTS dbutils;

COMMENT ON SCHEMA dbutils IS 'Liquibase deployment audit schema. changelog_audit table is auto-managed by Liquibase. Do not modify manually.';
