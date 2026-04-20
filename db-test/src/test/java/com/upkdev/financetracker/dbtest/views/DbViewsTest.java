package com.upkdev.financetracker.dbtest.views;

import com.upkdev.financetracker.dbtest.BaseDbTest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.ResultSet;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.*;

class DbViewsTest extends BaseDbTest {

    private long memberId;

    @BeforeEach
    void setup() throws Exception {
        cleanOdsTables();
        memberId = insertMember();
    }

    // ── rpt.vw_member_expense_summary ──────────────────────────────────────────

    @Test
    void memberWithNoExpensesShowsTotalExpensesZero() throws Exception {
        try (ResultSet rs = executeQuery(
                "SELECT total_expenses FROM rpt.vw_member_expense_summary " +
                "WHERE member_id = " + memberId)) {
            assertThat(rs.next()).isTrue();
            assertThat(rs.getDouble("total_expenses")).isEqualTo(0.0);
        }
    }

    @Test
    void memberWithExpensesShowsCorrectTotals() throws Exception {
        insertExpense(memberId, "A", 80,  "FOOD",      LocalDate.now());
        insertExpense(memberId, "B", 120, "TRANSPORT", LocalDate.now());
        try (ResultSet rs = executeQuery(
                "SELECT total_expenses, total_expense_count FROM rpt.vw_member_expense_summary " +
                "WHERE member_id = " + memberId)) {
            assertThat(rs.next()).isTrue();
            assertThat(rs.getDouble("total_expenses")).isEqualTo(200.0);
            assertThat(rs.getInt("total_expense_count")).isEqualTo(2);
        }
    }

    // ── rpt.vw_member_savings_overview ─────────────────────────────────────────

    @Test
    void savingsOverviewShowsCorrectNetSavings() throws Exception {
        // income=5000, expenses=2000 → net=3000
        insertSavingsGoal(memberId, "Goal", 10000, 5000.00);
        insertExpense(memberId, "E", 2000, "OTHER", LocalDate.now());
        try (ResultSet rs = executeQuery(
                "SELECT net_savings FROM rpt.vw_member_savings_overview " +
                "WHERE member_id = " + memberId)) {
            assertThat(rs.next()).isTrue();
            assertThat(rs.getDouble("net_savings")).isEqualTo(3000.0);
        }
    }

    // ── rpt.vw_expense_category_breakdown ─────────────────────────────────────

    @Test
    void categoryBreakdownShowsCategoryLabel() throws Exception {
        insertExpense(memberId, "Lunch", 15, "FOOD", LocalDate.now());
        try (ResultSet rs = executeQuery(
                "SELECT category_label FROM rpt.vw_expense_category_breakdown " +
                "WHERE member_id = " + memberId + " AND category = 'FOOD'")) {
            assertThat(rs.next()).isTrue();
            assertThat(rs.getString("category_label")).isNotBlank();
        }
    }

    @Test
    void categoryBreakdownShowsCorrectTotalsPerCategory() throws Exception {
        insertExpense(memberId, "A", 100, "FOOD",      LocalDate.now());
        insertExpense(memberId, "B", 200, "FOOD",      LocalDate.now());
        insertExpense(memberId, "C", 50,  "TRANSPORT", LocalDate.now());
        try (ResultSet rs = executeQuery(
                "SELECT category, total_amount FROM rpt.vw_expense_category_breakdown " +
                "WHERE member_id = " + memberId + " ORDER BY category")) {
            rs.next();
            assertThat(rs.getString("category")).isEqualTo("FOOD");
            assertThat(rs.getDouble("total_amount")).isEqualTo(300.0);
            rs.next();
            assertThat(rs.getString("category")).isEqualTo("TRANSPORT");
            assertThat(rs.getDouble("total_amount")).isEqualTo(50.0);
        }
    }

    // ── ref.vw_expense_categories_active ──────────────────────────────────────

    @Test
    void activeCategoriesViewReturns8RowsOrderedBySortOrder() throws Exception {
        int count = 0;
        int prevOrder = -1;
        try (ResultSet rs = executeQuery(
                "SELECT sort_order FROM ref.vw_expense_categories_active ORDER BY sort_order")) {
            while (rs.next()) {
                int so = rs.getInt("sort_order");
                assertThat(so).isGreaterThanOrEqualTo(prevOrder);
                prevOrder = so;
                count++;
            }
        }
        assertThat(count).isEqualTo(8);
    }
}
