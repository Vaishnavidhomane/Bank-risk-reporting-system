CREATE OR REPLACE PROCEDURE generate_monthly_summary(acc_id INT, txn_month INT)
LANGUAGE plpgsql
AS $$
DECLARE
    total_credit NUMERIC := 0;
    total_debit  NUMERIC := 0;
    closing_bal  NUMERIC := 0;
BEGIN
    SELECT COALESCE(SUM(amount),0) INTO total_credit
    FROM transactions
    WHERE account_id = acc_id AND txn_type = 'credit'
      AND EXTRACT(MONTH FROM txn_date) = txn_month;

    SELECT COALESCE(SUM(amount),0) INTO total_debit
    FROM transactions
    WHERE account_id = acc_id AND txn_type = 'debit'
      AND EXTRACT(MONTH FROM txn_date) = txn_month;

    SELECT balance INTO closing_bal FROM accounts WHERE account_id = acc_id;

    RAISE NOTICE 'Account %: Credits = %, Debits = %, Closing Balance = %',
        acc_id, total_credit, total_debit, closing_bal;
END;
$$;

-- Run it:
CALL generate_monthly_summary(1, 6);



CREATE OR REPLACE FUNCTION flag_large_transaction()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.amount > 50000 THEN
        INSERT INTO audit_log(txn_id, amount, logged_at)
        VALUES (NEW.txn_id, NEW.amount, NOW());
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trg_large_txn
AFTER INSERT ON transactions
FOR EACH ROW EXECUTE FUNCTION flag_large_transaction();

-- Test it:
INSERT INTO transactions (account_id, amount, txn_type, txn_date)
VALUES (2, 75000, 'credit', CURRENT_DATE);

SELECT * FROM audit_log;   -- should show the new row


CREATE OR REPLACE FUNCTION check_loan_overdue(l_id INT)
RETURNS VARCHAR AS $$
DECLARE
    d_date DATE;
    l_status VARCHAR(20);
BEGIN
    SELECT due_date, status INTO d_date, l_status
    FROM loans WHERE loan_id = l_id;

    IF l_status = 'paid' THEN
        RETURN 'Paid';
    ELSIF d_date < CURRENT_DATE THEN
        RETURN 'Overdue';
    ELSE
        RETURN 'On Track';
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Use it directly in a SELECT:
SELECT loan_id, check_loan_overdue(loan_id) AS status_check FROM loans;

