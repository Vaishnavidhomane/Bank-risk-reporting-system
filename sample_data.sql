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