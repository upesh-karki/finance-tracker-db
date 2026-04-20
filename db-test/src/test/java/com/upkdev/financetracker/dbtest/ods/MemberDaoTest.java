package com.upkdev.financetracker.dbtest.ods;

import com.upkdev.financetracker.dbtest.BaseDbTest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.ResultSet;
import java.sql.SQLException;

import static org.assertj.core.api.Assertions.*;

class MemberDaoTest extends BaseDbTest {

    @BeforeEach
    void clean() throws Exception {
        cleanOdsTables();
    }

    @Test
    void insertValidMemberSucceeds() throws Exception {
        long id = insertMember("alice@example.com", "alice");
        assertThat(id).isGreaterThan(0);
    }

    @Test
    void duplicateEmailThrowsUniqueConstraint() throws Exception {
        insertMember("dup@example.com", "user1");
        assertThatThrownBy(() -> insertMember("dup@example.com", "user2"))
                .isInstanceOf(SQLException.class)
                .hasMessageContaining("unique");
    }

    @Test
    void duplicateUsernameThrowsUniqueConstraint() throws Exception {
        insertMember("a@example.com", "sameuser");
        assertThatThrownBy(() -> insertMember("b@example.com", "sameuser"))
                .isInstanceOf(SQLException.class)
                .hasMessageContaining("unique");
    }

    @Test
    void nullEmailThrowsConstraint() {
        assertThatThrownBy(() -> executeUpdate(
                "INSERT INTO ods.member (first_name, last_name, email, password, username) " +
                "VALUES ('A','B',NULL,'pw','nullemail')"))
                .isInstanceOf(SQLException.class);
    }

    @Test
    void nullPasswordThrowsConstraint() {
        assertThatThrownBy(() -> executeUpdate(
                "INSERT INTO ods.member (first_name, last_name, email, password, username) " +
                "VALUES ('A','B','pw@example.com',NULL,'nullpw')"))
                .isInstanceOf(SQLException.class);
    }

    @Test
    void profileStatusDefaultsToActive() throws Exception {
        long id = insertMember("defaults@example.com", "defaultuser");
        try (ResultSet rs = executeQuery(
                "SELECT profile_status FROM ods.member WHERE id = " + id)) {
            rs.next();
            assertThat(rs.getString("profile_status")).isEqualTo("ACTIVE");
        }
    }

    @Test
    void createdAtIsSetAutomatically() throws Exception {
        long id = insertMember("ts@example.com", "tsuser");
        try (ResultSet rs = executeQuery(
                "SELECT created_at FROM ods.member WHERE id = " + id)) {
            rs.next();
            assertThat(rs.getTimestamp("created_at")).isNotNull();
        }
    }
}
