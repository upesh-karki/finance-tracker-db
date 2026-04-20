package com.upkdev.financetracker.dbtest.ods;

import com.upkdev.financetracker.dbtest.BaseDbTest;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.sql.SQLException;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.*;

class ExpenseDaoTest extends BaseDbTest {

    private long memberId;

    @BeforeEach
    void clean() throws Exception {
        cleanOdsTables();
        memberId = insertMember();
    }

    @Test
    void insertExpenseWithValidMemberSucceeds() throws Exception {
        long id = insertExpense(memberId, "Coffee", 3.50, "FOOD", LocalDate.now());
        assertThat(id).isGreaterThan(0);
    }

    @Test
    void insertExpenseWithInvalidMemberThrowsFkViolation() {
        assertThatThrownBy(() -> insertExpense(999999L, "Ghost", 10, "FOOD", LocalDate.now()))
                .isInstanceOf(SQLException.class)
                .hasMessageContaining("fk_ods_expense_member");
    }

    @Test
    void nullExpenseNameThrowsConstraint() {
        assertThatThrownBy(() -> executeUpdate(
                "INSERT INTO ods.expense (member_id, expense_name, amount, expense_date) " +
                "VALUES (" + memberId + ", NULL, 10, CURRENT_DATE)"))
                .isInstanceOf(SQLException.class);
    }

    @Test
    void nullAmountThrowsConstraint() {
        assertThatThrownBy(() -> executeUpdate(
                "INSERT INTO ods.expense (member_id, expense_name, amount, expense_date) " +
                "VALUES (" + memberId + ", 'Item', NULL, CURRENT_DATE)"))
                .isInstanceOf(SQLException.class);
    }

    @Test
    void nullExpenseDateThrowsConstraint() {
        assertThatThrownBy(() -> executeUpdate(
                "INSERT INTO ods.expense (member_id, expense_name, amount, expense_date) " +
                "VALUES (" + memberId + ", 'Item', 10, NULL)"))
                .isInstanceOf(SQLException.class);
    }

    @Test
    void categoryAcceptsAllValidValues() throws Exception {
        String[] categories = {"FOOD","TRANSPORT","UTILITIES","SUBSCRIPTIONS",
                               "ENTERTAINMENT","TRAVEL","HEALTH","OTHER"};
        int i = 0;
        for (String cat : categories) {
            insertExpense(memberId, "Item" + i++, 1.0, cat, LocalDate.now());
        }
        // if we got here without exception — all 8 are accepted
    }
}
