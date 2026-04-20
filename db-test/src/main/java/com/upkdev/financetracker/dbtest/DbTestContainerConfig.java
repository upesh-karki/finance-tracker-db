package com.upkdev.financetracker.dbtest;

import liquibase.Liquibase;
import liquibase.database.Database;
import liquibase.database.DatabaseFactory;
import liquibase.database.jvm.JdbcConnection;
import liquibase.resource.ClassLoaderResourceAccessor;
import org.testcontainers.containers.PostgreSQLContainer;

import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Shared singleton Testcontainer config that other modules (finance-tracker-api) can import.
 * Uses static initialiser so the container starts once per JVM and Liquibase migrations
 * are applied exactly once.
 */
public class DbTestContainerConfig {

    @SuppressWarnings("resource")   // container lifetime == JVM lifetime
    private static final PostgreSQLContainer<?> POSTGRES =
            new PostgreSQLContainer<>("postgres:16")
                    .withDatabaseName("finance_tracker_test")
                    .withUsername("test_user")
                    .withPassword("test_pass");

    static {
        POSTGRES.start();
        runMigrations();
    }

    private static void runMigrations() {
        try (Connection conn = DriverManager.getConnection(
                POSTGRES.getJdbcUrl(), POSTGRES.getUsername(), POSTGRES.getPassword())) {

            Database database = DatabaseFactory.getInstance()
                    .findCorrectDatabaseImplementation(new JdbcConnection(conn));

            try (Liquibase liquibase = new Liquibase(
                    "db/changelog/db.changelog-master.xml",
                    new ClassLoaderResourceAccessor(),
                    database)) {

                liquibase.update("");   // apply all changesets
            }
        } catch (Exception e) {
            throw new RuntimeException("Liquibase migration failed", e);
        }
    }

    public static String getJdbcUrl()  { return POSTGRES.getJdbcUrl();  }
    public static String getUsername() { return POSTGRES.getUsername(); }
    public static String getPassword() { return POSTGRES.getPassword(); }
}
