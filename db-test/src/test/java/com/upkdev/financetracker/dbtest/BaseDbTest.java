package com.upkdev.financetracker.dbtest;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;

import java.sql.*;
import java.time.LocalDate;

/**
 * Base class for all DB integration tests.
 *
 * Opens a single JDBC connection per test, closes it after.
 * Provides helper methods that all test classes share.
 * Call cleanOdsTables() in @BeforeEach to ensure test isolation.
 */
public abstract class BaseDbTest {

    protected Connection conn;

    @BeforeEach
    void openConnection() throws Exception {
        conn = DriverManager.getConnection(
                DbEmbeddedPostgresConfig.getJdbcUrl(),
                DbEmbeddedPostgresConfig.getUsername(),
                DbEmbeddedPostgresConfig.getPassword()
        );
        conn.setAutoCommit(true);
    }

    @AfterEach
    void closeConnection() throws Exception {
        if (conn != null && !conn.isClosed()) {
            conn.close();
        }
    }

    protected ResultSet executeQuery(String sql) throws SQLException {
        return conn.createStatement().executeQuery(sql);
    }

    protected void executeUpdate(String sql) throws SQLException {
        conn.createStatement().execute(sql);
    }

    protected int countRows(String schemaTable) throws SQLException {
        ResultSet rs = conn.createStatement()
                .executeQuery("SELECT COUNT(*) FROM " + schemaTable);
        rs.next();
        return rs.getInt(1);
    }

    /** Insert a member and return its generated id */
    protected long insertMember(String email, String username) throws SQLException {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO ods.member (first_name, last_name, email, password, username) " +
            "VALUES ('Test', 'User', ?, 'password123', ?) RETURNING id"
        );
        ps.setString(1, email);
        ps.setString(2, username);
        ResultSet rs = ps.executeQuery();
        rs.next();
        return rs.getLong(1);
    }

    /** Insert an expense and return its generated id */
    protected long insertExpense(long memberId, String name,
                                  double amount, String category, LocalDate date) throws SQLException {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO ods.expense (member_id, expense_name, amount, category, expense_date) " +
            "VALUES (?, ?, ?, ?, ?) RETURNING id"
        );
        ps.setLong(1, memberId);
        ps.setString(2, name);
        ps.setDouble(3, amount);
        ps.setString(4, category);
        ps.setDate(5, Date.valueOf(date));
        ResultSet rs = ps.executeQuery();
        rs.next();
        return rs.getLong(1);
    }

    /** Insert a savings goal and return its generated id */
    protected long insertSavingsGoal(long memberId, String goalName,
                                      double targetAmount, double income) throws SQLException {
        PreparedStatement ps = conn.prepareStatement(
            "INSERT INTO ods.savings_goal (member_id, goal_name, target_amount, income) " +
            "VALUES (?, ?, ?, ?) RETURNING id"
        );
        ps.setLong(1, memberId);
        ps.setString(2, goalName);
        ps.setDouble(3, targetAmount);
        ps.setDouble(4, income);
        ResultSet rs = ps.executeQuery();
        rs.next();
        return rs.getLong(1);
    }

    /** No-arg overload — inserts a default test member */
    protected long insertMember() throws SQLException {
        // Use random suffix to avoid unique constraint conflicts across tests
        String suffix = String.valueOf(System.nanoTime()).substring(10);
        return insertMember("test" + suffix + "@example.com", "user" + suffix);
    }

    /** Overload for FK test — invalid member */
    protected long insertSavingsGoal(long memberId) throws SQLException {
        return insertSavingsGoal(memberId, "Test Goal", 5000.0, 3000.0);
    }

    /** Clean all ODS and RPT data between tests — ref data is preserved */
    protected void cleanOdsTables() throws SQLException {
        conn.createStatement().execute(
            "TRUNCATE TABLE rpt.member_monthly_summary, rpt.savings_recommendation, " +
            "ods.savings_goal, ods.expense, ods.member_detail, ods.member " +
            "RESTART IDENTITY CASCADE"
        );
    }
}
