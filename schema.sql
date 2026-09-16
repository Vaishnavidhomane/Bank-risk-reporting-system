CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name        VARCHAR(100) NOT NULL,
    email       VARCHAR(100) UNIQUE,
    city        VARCHAR(50)
);

CREATE TABLE accounts (
    account_id   SERIAL PRIMARY KEY,
    customer_id  INT REFERENCES customers(customer_id),
    account_type VARCHAR(20) CHECK (account_type IN ('savings','current')),
    balance      NUMERIC(12,2) DEFAULT 0
);

CREATE TABLE transactions (
    txn_id     SERIAL PRIMARY KEY,
    account_id INT REFERENCES accounts(account_id),
    amount     NUMERIC(12,2) NOT NULL,
    txn_type   VARCHAR(10) CHECK (txn_type IN ('credit','debit')),
    txn_date   DATE DEFAULT CURRENT_DATE
);

CREATE TABLE loans (
    loan_id     SERIAL PRIMARY KEY,
    customer_id INT REFERENCES customers(customer_id),
    loan_amount NUMERIC(12,2) NOT NULL,
    due_date    DATE NOT NULL,
    status      VARCHAR(20) DEFAULT 'active' CHECK (status IN ('active','overdue','paid'))
);

CREATE TABLE audit_log (
    audit_id   SERIAL PRIMARY KEY,
    txn_id     INT,
    amount     NUMERIC(12,2),
    logged_at  TIMESTAMP DEFAULT NOW()
);

INSERT INTO customers (name, email, city) VALUES
('Aarav Shah', 'aarav.shah@mail.com', 'Mumbai'),
('Priya Nair', 'priya.nair@mail.com', 'Pune'),
('Rohan Mehta', 'rohan.mehta@mail.com', 'Nagpur'),
('Sneha Iyer', 'sneha.iyer@mail.com', 'Delhi'),
('Kabir Malhotra', 'kabir.m@mail.com', 'Mumbai'),
('Ananya Rao', 'ananya.rao@mail.com', 'Bengaluru'),
('Vivaan Joshi', 'vivaan.j@mail.com', 'Nagpur'),
('Ishita Desai', 'ishita.d@mail.com', 'Pune'),
('Dev Kapoor', 'dev.kapoor@mail.com', 'Delhi'),
('Meera Pillai', 'meera.p@mail.com', 'Chennai');

INSERT INTO accounts (customer_id, account_type, balance) VALUES
(1,'savings',15000),(1,'current',5000),
(2,'savings',22000),(3,'savings',8000),
(4,'current',30000),(5,'savings',12000),
(6,'current',18000),(7,'savings',9000),
(8,'savings',26000),(9,'current',4000),
(10,'savings',17000);

INSERT INTO transactions (account_id, amount, txn_type, txn_date) VALUES
(1,2000,'credit','2026-06-01'),(1,500,'debit','2026-06-03'),
(2,60000,'credit','2026-06-05'),(3,1500,'debit','2026-06-06'),
(4,3000,'credit','2026-06-07'),(5,55000,'credit','2026-06-08'),
(6,700,'debit','2026-06-09'),(7,2200,'credit','2026-06-10'),
(8,900,'debit','2026-06-11'),(9,70000,'credit','2026-06-12'),
(10,1200,'debit','2026-06-13'),(11,4300,'credit','2026-06-14'),
(1,800,'debit','2026-06-15'),(2,1200,'credit','2026-06-16'),
(3,600,'debit','2026-06-17'),(4,52000,'credit','2026-06-18');

INSERT INTO loans (customer_id, loan_amount, due_date, status) VALUES
(1,50000,'2026-08-01','active'),
(2,120000,'2026-05-15','overdue'),
(3,30000,'2026-09-10','active'),
(4,80000,'2026-04-01','overdue'),
(5,45000,'2026-12-01','active'),
(6,60000,'2026-03-20','overdue'),
(7,20000,'2026-11-05','active'),
(8,90000,'2026-07-15','paid');

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


