# Liquibase Structure

This directory contains all database change management for the Finance Tracker platform.

## Directory Layout

```
liquibase/
├── liquibase.properties              ← Local dev connection config
└── changelog/
    ├── db.changelog-master.xml       ← ENTRY POINT — includes all releases in order
    ├── releases/
    │   ├── v1.0/
    │   │   └── release-changelog.xml ← Includes all v1.0 schema objects in order
    │   └── v1.1/                     ← Next release goes here
    │       └── release-changelog.xml
    └── schema/
        ├── sequences/                ← Custom sequences
        │   └── v1.0-sequences.xml
        ├── tables/                   ← One file per table, versioned
        │   ├── v1.0-001-member.xml
        │   ├── v1.0-002-member-detail.xml
        │   ├── v1.0-003-expense.xml
        │   └── v1.0-004-savings-goal.xml
        ├── indexes/                  ← All indexes for a release in one file
        │   └── v1.0-indexes.xml
        ├── functions/                ← Stored procedures and functions (runOnChange=true)
        │   └── v1.0-functions.xml
        └── views/                   ← Views (runOnChange=true)
            └── v1.0-views.xml
```

## Rules

1. **Never edit a committed changeSet** — Liquibase checksums will fail.
2. **New column / table in the same release?** Add a new changeSet at the bottom of the relevant file.
3. **New release?** Create `releases/vX.Y/release-changelog.xml` and include it in `db.changelog-master.xml`.
4. **Functions and views** use `runOnChange="true"` — you can edit them freely, Liquibase will re-run on change.
5. **Always add a `<rollback>` block** to every changeSet.
6. **changeSet IDs** follow the pattern: `vX.Y-<type>-<NNN>-<short-description>`
   - types: `tbl`, `idx`, `fn`, `vw`, `seq`, `dml`

## How to Add Something New

### Add a column to an existing table (v1.1)
```
1. Create liquibase/changelog/releases/v1.1/release-changelog.xml
2. Create liquibase/changelog/schema/tables/v1.1-001-alter-member-add-dob.xml
3. Include it in the v1.1 release-changelog.xml
4. Uncomment the v1.1 include in db.changelog-master.xml
```

### Add a new table (v1.1)
```
1. Create liquibase/changelog/schema/tables/v1.1-005-budget.xml
2. Include it in the v1.1 release-changelog.xml (after its dependencies)
```

### Modify a function or view
```
1. Edit the existing function/view file directly (they use runOnChange=true)
2. Liquibase will detect the change and re-run it on next startup
```

## Current DB Objects

### Tables
| Table | Version | Description |
|---|---|---|
| `member` | v1.0 | Core user accounts |
| `member_detail` | v1.0 | Extended profile info |
| `expense` | v1.0 | All member expenses |
| `savings_goal` | v1.0 | Savings goals and targets |

### Functions
| Function | Version | Description |
|---|---|---|
| `fn_get_member_monthly_total(member_id, year, month)` | v1.0 | Total expenses for a member in a given month |
| `fn_get_member_savings_rate(member_id)` | v1.0 | Savings rate % (income - expenses / income) |
| `fn_get_category_summary(member_id)` | v1.0 | Expense breakdown by category with percentages |

### Views
| View | Version | Description |
|---|---|---|
| `vw_member_expense_summary` | v1.0 | Per-member expense totals and counts |
| `vw_member_savings_overview` | v1.0 | Income vs expenses vs savings goals |
| `vw_expense_category_breakdown` | v1.0 | Expense stats grouped by member + category |
