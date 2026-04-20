package com.upkdev.financetracker.dbtest;

import io.zonky.test.db.postgres.embedded.EmbeddedPostgres;
import liquibase.Liquibase;
import liquibase.database.DatabaseFactory;
import liquibase.database.jvm.JdbcConnection;
import liquibase.resource.ClassLoaderResourceAccessor;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DriverManager;

/**
 * Shared embedded PostgreSQL instance for all DB tests.
 *
 * Uses io.zonky.test:embedded-postgres — starts a real Postgres process
 * in-process. No Docker required. Downloads a platform binary on first run,
 * caches it in ~/.embedpostgresql/
 *
 * Singleton: Postgres starts once per JVM. Liquibase migrations run once.
 * All test classes share this instance.
 *
 * Published in the main JAR so finance-tracker-api can import it
 * as a test dependency (classifier=tests) for DAO layer tests.
 */
public class DbEmbeddedPostgresConfig {

    private static final EmbeddedPostgres POSTGRES;
    private static final String USERNAME = "postgres";
    private static final String PASSWORD = "";

    static {
        try {
            POSTGRES = EmbeddedPostgres.start();
            runMigrations();
        } catch (Exception e) {
            throw new RuntimeException("Failed to start embedded PostgreSQL", e);
        }
    }

    private static void runMigrations() throws Exception {
        // embedded-postgres default DB is "postgres", owned by user "postgres"
        DataSource ds = POSTGRES.getPostgresDatabase();
        try (Connection conn = ds.getConnection()) {
            // Set search_path so schema-qualified objects resolve correctly
            conn.createStatement().execute("SET search_path TO public, ods, ref, rpt");
            liquibase.database.Database database = DatabaseFactory.getInstance()
                    .findCorrectDatabaseImplementation(new JdbcConnection(conn));
            // Tell Liquibase not to prepend a default schema
            database.setDefaultSchemaName(null);
            Liquibase liquibase = new Liquibase(
                    "db/changelog/db.changelog-master.xml",
                    new ClassLoaderResourceAccessor(),
                    database
            );
            liquibase.update("");
        }
    }

    /** JDBC URL pointing at the embedded instance's default "postgres" database */
    public static String getJdbcUrl() {
        return "jdbc:postgresql://localhost:" + POSTGRES.getPort() + "/postgres";
    }

    public static String getUsername() {
        return USERNAME;
    }

    public static String getPassword() {
        return PASSWORD;
    }

    public static int getPort() {
        return POSTGRES.getPort();
    }
}
