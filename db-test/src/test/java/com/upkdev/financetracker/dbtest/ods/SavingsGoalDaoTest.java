package com.upkdev.financetracker.dbtest.ods;

import com.upkdev.financetracker.dbtest.BaseDbTest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.ResultSet;
import java.sql.SQLException;

import static org.assertj.core.api.Assertions.*;

class SavingsGoalDaoTest extends BaseDbTest {

    private long memberId;

    @BeforeEach
    void clean() throws Exception {
        cleanOdsTables();
        memberId = insertMember();
    }

    @Test
    void insertGoalWithValidMemberSucceeds() throws Exception {
        long id = insertSavingsGoal(memberId);
        assertThat(id).isGreaterThan(0);
    }

    @Test
    void currentAmountDefaultsToZero() throws Exception {
        long id = insertSavingsGoal(memberId);
        try (ResultSet rs = executeQuery(
                "SELECT current_amount FROM ods.savings_goal WHERE id = " + id)) {
            rs.next();
            assertThat(rs.getBigDecimal("current_amount").doubleValue()).isEqualTo(0.0);
        }
    }

    @Test
    void statusDefaultsToActive() throws Exception {
        long id = insertSavingsGoal(memberId);
        try (ResultSet rs = executeQuery(
                "SELECT status FROM ods.savings_goal WHERE id = " + id)) {
            rs.next();
            assertThat(rs.getString("status")).isEqualTo("ACTIVE");
        }
    }

    @Test
    void fkToMemberIsEnforced() {
        assertThatThrownBy(() -> insertSavingsGoal(999999L))
                .isInstanceOf(SQLException.class)
                .hasMessageContaining("fk_ods_savings_goal_member");
    }
}
