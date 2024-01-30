use finalcial_analysis;

CREATE TABLE Customers (
CustomerID INT PRIMARY KEY,
FirstName VARCHAR(50) NOT NULL,
LastName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);

INSERT INTO Customers (CustomerID, FirstName, LastName, City, State)
VALUES (1, 'John', 'Doe', 'New York', 'NY'),
(2, 'Jane', 'Doe', 'New York', 'NY'),
(3, 'Bob', 'Smith', 'San Francisco', 'CA'),
(4, 'Alice', 'Johnson', 'San Francisco', 'CA'),
(5, 'Michael', 'Lee', 'Los Angeles', 'CA'),
(6, 'Jennifer', 'Wang', 'Los Angeles', 'CA');

CREATE TABLE Branches (
BranchID INT PRIMARY KEY,
BranchName VARCHAR(50) NOT NULL,
City VARCHAR(50) NOT NULL,
State VARCHAR(2) NOT NULL
);


INSERT INTO Branches (BranchID, BranchName, City, State)
VALUES (1, 'Main', 'New York', 'NY'),
(2, 'Downtown', 'San Francisco', 'CA'),
(3, 'West LA', 'Los Angeles', 'CA'),
(4, 'East LA', 'Los Angeles', 'CA'),
(5, 'Uptown', 'New York', 'NY'),
(6, 'Financial District', 'San Francisco', 'CA'),
(7, 'Midtown', 'New York', 'NY'),
(8, 'South Bay', 'San Francisco', 'CA'),
(9, 'Downtown', 'Los Angeles', 'CA'),
(10, 'Chinatown', 'New York', 'NY'),
(11, 'Marina', 'San Francisco', 'CA'),
(12, 'Beverly Hills', 'Los Angeles', 'CA'),
(13, 'Brooklyn', 'New York', 'NY'),
(14, 'North Beach', 'San Francisco', 'CA'),
(15, 'Pasadena', 'Los Angeles', 'CA');


CREATE TABLE Accounts (
AccountID INT PRIMARY KEY,
CustomerID INT NOT NULL,
BranchID INT NOT NULL,
AccountType VARCHAR(50) NOT NULL,
Balance DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
FOREIGN KEY (BranchID) REFERENCES Branches(BranchID)
);


INSERT INTO Accounts (AccountID, CustomerID, BranchID, AccountType, Balance)
VALUES (1, 1, 5, 'Checking', 1000.00),
(2, 1, 5, 'Savings', 5000.00),
(3, 2, 1, 'Checking', 2500.00),
(4, 2, 1, 'Savings', 10000.00),
(5, 3, 2, 'Checking', 7500.00),
(6, 3, 2, 'Savings', 15000.00),
(7, 4, 8, 'Checking', 5000.00),
(8, 4, 8, 'Savings', 20000.00),
(9, 5, 14, 'Checking', 10000.00),
(10, 5, 14, 'Savings', 50000.00),
(11, 6, 2, 'Checking', 5000.00),
(12, 6, 2, 'Savings', 10000.00),
(13, 1, 5, 'Credit Card', -500.00),
(14, 2, 1, 'Credit Card', -1000.00),
(15, 3, 2, 'Credit Card', -2000.00);


CREATE TABLE Transactions (
TransactionID INT PRIMARY KEY,
AccountID INT NOT NULL,
TransactionDate DATE NOT NULL,
Amount DECIMAL(10, 2) NOT NULL,
FOREIGN KEY (AccountID) REFERENCES Accounts(AccountID)
);



INSERT INTO Transactions (TransactionID, AccountID, TransactionDate, Amount)
VALUES (1, 1, '2022-01-01', -500.00),
(2, 1, '2022-01-02', -250.00),
(3, 2, '2022-01-03', 1000.00),
(4, 3, '2022-01-04', -1000.00),
(5, 3, '2022-01-05', 500.00),
(6, 4, '2022-01-06', 1000.00),
(7, 4, '2022-01-07', -500.00),
(8, 5, '2022-01-08', -2500.00),
(9, 6, '2022-01-09', 500.00),
(10, 6, '2022-01-10', -1000.00),
(11, 7, '2022-01-11', -500.00),
(12, 7, '2022-01-12', -250.00),
(13, 8, '2022-01-13', 1000.00),
(14, 8, '2022-01-14', -1000.00),
(15, 9, '2022-01-15', 500.00);

select * from transactions;
-- 1. What are the names of all the customers who live in New York?

select * from customers;

select FirstName, LastName from
customers where city = 'New York'
group by FirstName, LastName;

-- 2 What is the total no of  accounts in the accounts table ?

select * from accounts;

select count(distinct(AccountId)) as no_of_accounts from accounts;

-- 3 What is the total balance of all checking account ??

select * from transactions;
select * from accounts;

select sum(balance) as balance
from accounts where AccountType = 'Checking';

-- 3 what is the total balance of all savings account

select sum(balance) as total_balance
from accounts where AccountType = 'Savings';

----- 4 what is the total balance of all accounts associated with customers who live in los angels;

select * from accounts;

select * from customers;

select sum(a.balance) as total_balance , c.city
from accounts a inner join customers c
on a.CustomerID = c.CustomerID
where city = 'Los Angeles';


-- 5 Which branch has the highest average account balance??
select * from branches;
select * from accounts;

with cte1 as (
select b.BranchName, avg(a.balance) as avg_balance 
from branches b inner join accounts a on b.BranchId = a.BranchId
group by b.BranchName)
,cte2 as
(
select *, 
Dense_rank() over(ORDER BY avg_balance DESC) drk
from cte1
)
select BranchName, avg_balance
from cte2 where drk = 1;

-- 6 Which customers has the highest current balance in their accounts.

select * from customers;
select * from accounts;


--  Which customers has made more transaction in the transactions table?

select * from transactions;

select * from customers;

select * from accounts;
with cte1 as (
select c.CustomerID, c.FirstName, c.LastName, count(t.TransactionID) as no_of_transactions
from customers c inner join accounts a on a.CustomerID = c.CustomerID
inner join transactions t on a.AccountID = t.AccountID
group by c.CustomerID, c.FirstName, c.LastName)
, cte2 as
(
select *, dense_rank() over(order by no_of_transactions desc) drnk
from cte1
)
select CustomerID, FirstName, LastName, no_of_transactions from cte2
where drnk = 1;

-- Q8 Which branch has the highest total balance across all of its account?

select * from customers;

select * from accounts;
select * from branches;


with cte1 as 
( select b.BranchName, sum(a.balance) as total_balance
from accounts a inner join branches b on a.BranchID = b.BranchID
group by b.BranchName
)
, cte2 as 
(
select *, 
dense_rank() over(order by total_balance desc) drnk
from cte1
)

select BranchName, total_balance
from cte2 
where drnk = 1;	

-- Q9 Which customer has the highest total balance across all of their accounts, includings savings and checking accounts?

select * from customers;
select * from accounts;

select c.CustomerID, c.FirstName, c.LastName , sum(a.Balance) as total_balance
from customers c inner join accounts a on a.CustomerID = c.CustomerID
where a.AccountType in ('Checking','Savings')
group by c.CustomerID, c.FirstName, c.LastName
order by total_balance desc limit 1;

-- Which branch is the highest number of transactions in the transactions table?

with cte1 as 
( select b.BranchName, count(distinct t.transactionID) as no_of_transactions
from branches b inner join accounts a on b.BranchID = a.BranchID
inner join transactions t on a.AccountID = t.AccountID
group by b.BranchName
)
, cte2 as 
(
select *, 
dense_rank() over (order by no_of_transactions desc) drk
from cte1
)
select BranchName, no_of_transactions
from cte2
where drk = 1;





