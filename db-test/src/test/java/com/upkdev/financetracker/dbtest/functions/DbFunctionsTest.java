package com.upkdev.financetracker.dbtest.functions;

import com.upkdev.financetracker.dbtest.BaseDbTest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.*;

class DbFunctionsTest extends BaseDbTest {

    private long memberId;
    private long otherMemberId;

    @BeforeEach
    void setup() throws Exception {
        cleanOdsTables();
        memberId      = insertMember("fn@example.com",    "fnuser");
        otherMemberId = insertMember("other@example.com", "otheruser");
    }

    // ── fn_get_member_monthly_total ────────────────────────────────────────────

    @Test
    void monthlyTotalReturnsZeroForMemberWithNoExpenses() throws Exception {
        double total = callMonthlyTotal(memberId, 2026, 1);
        assertThat(total).isEqualTo(0.0);
    }

    @Test
    void monthlyTotalReturnsCorrectSumForCurrentMonth() throws Exception {
        LocalDate now = LocalDate.now();
        insertExpense(memberId, "A", 100.00, "FOOD",      now);
        insertExpense(memberId, "B", 50.00,  "TRANSPORT", now);
        double total = callMonthlyTotal(memberId, now.getYear(), now.getMonthValue());
        assertThat(total).isEqualTo(150.0);
    }

    @Test
    void monthlyTotalDoesNotIncludeOtherMonths() throws Exception {
        LocalDate now   = LocalDate.now();
        LocalDate other = now.minusMonths(1);
        insertExpense(memberId, "This",  200.00, "FOOD", now);
        insertExpense(memberId, "Other", 999.00, "FOOD", other);
        double total = callMonthlyTotal(memberId, now.getYear(), now.getMonthValue());
        assertThat(total).isEqualTo(200.0);
    }

    @Test
    void monthlyTotalDoesNotIncludeOtherMembers() throws Exception {
        LocalDate now = LocalDate.now();
        insertExpense(memberId,      "Mine",   100.00, "FOOD", now);
        insertExpense(otherMemberId, "Theirs", 900.00, "FOOD", now);
        double total = callMonthlyTotal(memberId, now.getYear(), now.getMonthValue());
        assertThat(total).isEqualTo(100.0);
    }

    // ── fn_get_member_savings_rate ─────────────────────────────────────────────

    @Test
    void savingsRateReturnsZeroWithNoGoal() throws Exception {
        double rate = callSavingsRate(memberId);
        assertThat(rate).isEqualTo(0.0);
    }

    @Test
    void savingsRateCalculatesCorrectlyWhenIncomeExceedsExpenses() throws Exception {
        // income=5000, expenses=3000 this month → (5000-3000)/5000 * 100 = 40.00
        insertSavingsGoal(memberId, "Goal", 10000, 5000.00);
        LocalDate now = LocalDate.now();
        insertExpense(memberId, "E1", 1500, "FOOD",      now);
        insertExpense(memberId, "E2", 1500, "UTILITIES", now);
        double rate = callSavingsRate(memberId);
        assertThat(rate).isEqualTo(40.00);
    }

    @Test
    void savingsRateIsNegativeWhenExpensesExceedIncome() throws Exception {
        insertSavingsGoal(memberId, "Goal", 10000, 1000.00);  // income=1000
        LocalDate now = LocalDate.now();
        insertExpense(memberId, "Big", 2000, "OTHER", now);   // expenses=2000
        double rate = callSavingsRate(memberId);
        assertThat(rate).isLessThan(0);
    }

    // ── fn_get_category_summary ────────────────────────────────────────────────

    @Test
    void categorySummaryReturnsEmptyForMemberWithNoExpenses() throws Exception {
        List<String> rows = new ArrayList<>();
        try (ResultSet rs = executeQuery(
                "SELECT * FROM ods.fn_get_category_summary(" + memberId + ")")) {
            while (rs.next()) rows.add(rs.getString("category"));
        }
        assertThat(rows).isEmpty();
    }

    @Test
    void categorySummaryReturnsCorrectCategoryAndTotal() throws Exception {
        LocalDate now = LocalDate.now();
        insertExpense(memberId, "A", 100, "FOOD",      now);
        insertExpense(memberId, "B", 100, "FOOD",      now);
        insertExpense(memberId, "C", 50,  "TRANSPORT", now);
        try (ResultSet rs = executeQuery(
                "SELECT category, total FROM ods.fn_get_category_summary(" + memberId + ") " +
                "ORDER BY category")) {
            // FOOD: 200, TRANSPORT: 50
            rs.next();
            assertThat(rs.getString("category")).isEqualTo("FOOD");
            assertThat(rs.getDouble("total")).isEqualTo(200.0);
            rs.next();
            assertThat(rs.getString("category")).isEqualTo("TRANSPORT");
            assertThat(rs.getDouble("total")).isEqualTo(50.0);
        }
    }

    @Test
    void categorySummaryPercentagesSumTo100() throws Exception {
        LocalDate now = LocalDate.now();
        insertExpense(memberId, "A", 300, "FOOD",      now);
        insertExpense(memberId, "B", 200, "TRANSPORT", now);
        insertExpense(memberId, "C", 100, "HEALTH",    now);
        double sum = 0;
        try (ResultSet rs = executeQuery(
                "SELECT percentage FROM ods.fn_get_category_summary(" + memberId + ")")) {
            while (rs.next()) sum += rs.getDouble("percentage");
        }
        assertThat(sum).isCloseTo(100.0, within(0.01));
    }

    // ── helpers ────────────────────────────────────────────────────────────────

    private double callMonthlyTotal(long memberId, int year, int month) throws Exception {
        try (ResultSet rs = executeQuery(
                "SELECT ods.fn_get_member_monthly_total(" + memberId + "," + year + "," + month + ")")) {
            rs.next();
            return rs.getDouble(1);
        }
    }

    private double callSavingsRate(long memberId) throws Exception {
        try (ResultSet rs = executeQuery(
                "SELECT ods.fn_get_member_savings_rate(" + memberId + ")")) {
            rs.next();
            return rs.getDouble(1);
        }
    }
}
