# Bank-risk-reporting-system
A small PostgreSQL project simulating core banking data operations — customer accounts,
transactions, and loans — with automated reporting and risk flagging, built to practice
database procedures, triggers, functions, and Shell scripting.

## Tools Used
- PostgreSQL (pgAdmin)
- PL/pgSQL (stored procedures, functions, triggers)
- Bash / Git Bash (Shell scripting)

## What It Does
- **Schema**: customers, accounts, transactions, loans, and an audit_log table
- **Stored Procedure** (`generate_monthly_summary`): calculates total credits, debits,
  and closing balance for a given account and month
- **Trigger** (`flag_large_transaction`): automatically logs any transaction above
  ₹50,000 into an audit table — simulating compliance/risk flagging
- **Function** (`check_loan_overdue`): checks whether a loan is overdue, paid, or on track
- **Shell Script** (`export_report.sh`): connects to the database and exports all
  overdue loans to a dated CSV report

## Files
| File | Purpose |
|---|---|
| `schema.sql` | Table definitions |
| `sample_data.sql` | Sample customers, accounts, transactions, and loans |
| `procedurefunction_trigger.sql` | Stored procedure, trigger, and function |
| `export_report.sh` | Shell script to export overdue loans as CSV |

## How to Run
1. Create a PostgreSQL database (e.g. `bank_system`) in pgAdmin.
2. Run `schema.sql` in the Query Tool to create the tables.
3. Run `sample_data.sql` to insert sample records.
4. Run `procedurefunction_trigger.sql` to create the procedure, trigger, and function.
5. Test the procedure and function:
   ```sql
   CALL generate_monthly_summary(1, 6);
   SELECT loan_id, check_loan_overdue(loan_id) FROM loans;
   ```
6. From a terminal (Git Bash on Windows), run the Shell script:
   ```bash
   chmod +x export_report.sh
   ./export_report.sh
   ```
7. Check the generated `overdue_loans_<date>.csv` file for the report output.

## Sample Output
```
loan_id,customer_id,loan_amount,due_date,status
2,2,120000.00,2026-05-15,overdue
4,4,80000.00,2026-04-01,overdue
6,6,60000.00,2026-03-20,overdue
```
