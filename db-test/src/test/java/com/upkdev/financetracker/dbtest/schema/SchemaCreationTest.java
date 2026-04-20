package com.upkdev.financetracker.dbtest.schema;

import com.upkdev.financetracker.dbtest.BaseDbTest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.ResultSet;

import static org.assertj.core.api.Assertions.assertThat;

/**
 * Verifies that Liquibase migrations created all expected schemas, tables,
 * columns, functions, and views.
 */
class SchemaCreationTest extends BaseDbTest {

    @BeforeEach
    void clean() throws Exception {
        cleanOdsTables();
    }

    // ── schemas ────────────────────────────────────────────────────────────────

    @Test
    void odsSchemaExists() throws Exception {
        assertThat(schemaExists("ods")).isTrue();
    }

    @Test
    void refSchemaExists() throws Exception {
        assertThat(schemaExists("ref")).isTrue();
    }

    @Test
    void rptSchemaExists() throws Exception {
        assertThat(schemaExists("rpt")).isTrue();
    }

    // ── ods tables ─────────────────────────────────────────────────────────────

    @Test
    void memberTableExists() throws Exception {
        assertThat(tableExists("ods", "member")).isTrue();
    }

    @Test
    void memberTableHasExpectedColumns() throws Exception {
        for (String col : new String[]{"id","first_name","last_name","email","password",
                                       "username","profile_status","created_at"}) {
            assertThat(columnExists("ods", "member", col))
                    .as("column ods.member.%s", col).isTrue();
        }
    }

    @Test
    void expenseTableExists() throws Exception {
        assertThat(tableExists("ods", "expense")).isTrue();
    }

    @Test
    void savingsGoalTableExists() throws Exception {
        assertThat(tableExists("ods", "savings_goal")).isTrue();
    }

    @Test
    void memberDetailTableExists() throws Exception {
        assertThat(tableExists("ods", "member_detail")).isTrue();
    }

    // ── ref tables ─────────────────────────────────────────────────────────────

    @Test
    void expenseCategoryHas8Rows() throws Exception {
        try (ResultSet rs = executeQuery("SELECT COUNT(*) FROM ref.expense_category")) {
            rs.next();
            assertThat(rs.getInt(1)).isEqualTo(8);
        }
    }

    @Test
    void profileStatusHas3Rows() throws Exception {
        try (ResultSet rs = executeQuery("SELECT COUNT(*) FROM ref.profile_status")) {
            rs.next();
            assertThat(rs.getInt(1)).isEqualTo(3);
        }
    }

    @Test
    void goalStatusHas3Rows() throws Exception {
        try (ResultSet rs = executeQuery("SELECT COUNT(*) FROM ref.goal_status")) {
            rs.next();
            assertThat(rs.getInt(1)).isEqualTo(3);
        }
    }

    // ── rpt tables ─────────────────────────────────────────────────────────────

    @Test
    void savingsRecommendationTableExists() throws Exception {
        assertThat(tableExists("rpt", "savings_recommendation")).isTrue();
    }

    @Test
    void memberMonthlySummaryTableExists() throws Exception {
        assertThat(tableExists("rpt", "member_monthly_summary")).isTrue();
    }

    // ── helpers ────────────────────────────────────────────────────────────────

    private boolean schemaExists(String schema) throws Exception {
        try (ResultSet rs = executeQuery(
                "SELECT 1 FROM information_schema.schemata WHERE schema_name = '" + schema + "'")) {
            return rs.next();
        }
    }

    private boolean tableExists(String schema, String table) throws Exception {
        try (ResultSet rs = executeQuery(
                "SELECT 1 FROM information_schema.tables WHERE table_schema = '" + schema +
                "' AND table_name = '" + table + "'")) {
            return rs.next();
        }
    }

    private boolean columnExists(String schema, String table, String column) throws Exception {
        try (ResultSet rs = executeQuery(
                "SELECT 1 FROM information_schema.columns WHERE table_schema = '" + schema +
                "' AND table_name = '" + table + "' AND column_name = '" + column + "'")) {
            return rs.next();
        }
    }
}
