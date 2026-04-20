package com.upkdev.financetracker.dbtest.ref;

import com.upkdev.financetracker.dbtest.BaseDbTest;
import org.junit.jupiter.api.Test;

import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import static org.assertj.core.api.Assertions.*;

class ReferenceDataTest extends BaseDbTest {

    @Test
    void expenseCategoryHasExactly8Rows() throws Exception {
        try (ResultSet rs = executeQuery("SELECT COUNT(*) FROM ref.expense_category")) {
            rs.next();
            assertThat(rs.getInt(1)).isEqualTo(8);
        }
    }

    @Test
    void allExpenseCategoryCodesExist() throws Exception {
        List<String> codes = new ArrayList<>();
        try (ResultSet rs = executeQuery("SELECT code FROM ref.expense_category")) {
            while (rs.next()) codes.add(rs.getString(1));
        }
        assertThat(codes).containsExactlyInAnyOrder(
                "FOOD","TRANSPORT","UTILITIES","SUBSCRIPTIONS",
                "ENTERTAINMENT","TRAVEL","HEALTH","OTHER");
    }

    @Test
    void vwExpenseCategoriesActiveReturnsAllOrderedBySortOrder() throws Exception {
        List<String> codes = new ArrayList<>();
        try (ResultSet rs = executeQuery(
                "SELECT code FROM ref.vw_expense_categories_active ORDER BY sort_order")) {
            while (rs.next()) codes.add(rs.getString(1));
        }
        assertThat(codes).hasSize(8);
        // verify ordering is ascending sort_order
        List<Integer> sortOrders = new ArrayList<>();
        try (ResultSet rs = executeQuery(
                "SELECT sort_order FROM ref.vw_expense_categories_active ORDER BY sort_order")) {
            while (rs.next()) sortOrders.add(rs.getInt(1));
        }
        for (int i = 1; i < sortOrders.size(); i++) {
            assertThat(sortOrders.get(i)).isGreaterThanOrEqualTo(sortOrders.get(i - 1));
        }
    }

    @Test
    void profileStatusHasCorrectCodes() throws Exception {
        List<String> codes = new ArrayList<>();
        try (ResultSet rs = executeQuery("SELECT code FROM ref.profile_status")) {
            while (rs.next()) codes.add(rs.getString(1));
        }
        assertThat(codes).containsExactlyInAnyOrder("ACTIVE","INACTIVE","SUSPENDED");
    }

    @Test
    void goalStatusHasCorrectCodes() throws Exception {
        List<String> codes = new ArrayList<>();
        try (ResultSet rs = executeQuery("SELECT code FROM ref.goal_status")) {
            while (rs.next()) codes.add(rs.getString(1));
        }
        assertThat(codes).containsExactlyInAnyOrder("ACTIVE","ACHIEVED","CANCELLED");
    }
}
