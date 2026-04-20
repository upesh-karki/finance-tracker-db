package com.upkdev.financetracker.dbtest;

import org.junit.jupiter.api.BeforeEach;

import java.sql.*;
import java.time.LocalDate;

/**
 * Abstract base class for all DB integration tests.
 * Opens a fresh connection per test class and provides convenience helpers.
 */
public abstract class BaseDbTest {

    protected Connection conn;

    @BeforeEach
    void openConnection() throws SQLException {
        conn = DriverManager.getConnection(
                DbTestContainerConfig.getJdbcUrl(),
                DbTestContainerConfig.getUsername(),
                DbTestContainerConfig.getPassword());
        conn.setAutoCommit(true);
    }

    @org.junit.jupiter.api.AfterEach
    void closeConnection() throws SQLException {
        if (conn != null && !conn.isClosed()) {
            conn.close();
        }
    }

    // ── helpers ────────────────────────────────────────────────────────────────

    protected ResultSet executeQuery(String sql) throws SQLException {
        return conn.createStatement().executeQuery(sql);
    }

    protected int executeUpdate(String sql) throws SQLException {
        return conn.createStatement().executeUpdate(sql);
    }

    protected void cleanOdsTables() throws SQLException {
        executeUpdate("DELETE FROM ods.expense");
        executeUpdate("DELETE FROM ods.savings_goal");
        executeUpdate("DELETE FROM ods.member_detail");
        executeUpdate("DELETE FROM ods.member");
    }

    /**
     * Inserts a member and returns its generated id.
     */
    protected long insertMember(String email, String username) throws SQLException {
        String sql = String.format(
                "INSERT INTO ods.member (first_name, last_name, email, password, username) " +
                "VALUES ('Test','User','%s','hashed_pw','%s') RETURNING id",
                email, username);
        try (ResultSet rs = executeQuery(sql)) {
            rs.next();
            return rs.getLong(1);
        }
    }

    protected long insertMember() throws SQLException {
        return insertMember("test@example.com", "testuser");
    }

    /**
     * Inserts an expense for the given member and returns its id.
     */
    protected long insertExpense(long memberId, String name, double amount,
                                 String category, LocalDate date) throws SQLException {
        String sql = String.format(
                "INSERT INTO ods.expense (member_id, expense_name, amount, category, expense_date) " +
                "VALUES (%d,'%s',%s,'%s','%s') RETURNING id",
                memberId, name, amount, category, date);
        try (ResultSet rs = executeQuery(sql)) {
            rs.next();
            return rs.getLong(1);
        }
    }

    protected long insertExpense(long memberId) throws SQLException {
        return insertExpense(memberId, "Groceries", 50.00, "FOOD", LocalDate.now());
    }

    /**
     * Inserts a savings goal for the given member and returns its id.
     */
    protected long insertSavingsGoal(long memberId, String goalName,
                                     double targetAmount, double income) throws SQLException {
        String sql = String.format(
                "INSERT INTO ods.savings_goal (member_id, goal_name, target_amount, income) " +
                "VALUES (%d,'%s',%s,%s) RETURNING id",
                memberId, goalName, targetAmount, income);
        try (ResultSet rs = executeQuery(sql)) {
            rs.next();
            return rs.getLong(1);
        }
    }

    protected long insertSavingsGoal(long memberId) throws SQLException {
        return insertSavingsGoal(memberId, "Emergency Fund", 10000.00, 5000.00);
    }
}
