drop table categories;
drop table members;
drop table books;
drop table loans;
delete from members;

-- STEP(1)
----- CREATE FOUR TABLES
create table categories(
    category_id number(10),
    category_name varchar2(10) not null
);
create table members(
    member_id number(10),
    full_name varchar2(100) not null,
    email varchar2(30),
    phone varchar2(20),
    city varchar2(50),
    joined_on date default sysdate,
    points number(10) default 0
);
create table books(
    book_id number(10),
    title varchar2(50) not null,
    auther varchar2(100),
    category_id number(10),
    price number(8,2),
    copies_available number(10),
    published_year number(10)
);
create table loans(
    loan_id number(10),
    member_id number(10),
    book_id number(10),
    loaned_at timestamp default systimestamp,
    status varchar2(20) default 'ACTIVE'
);
-- STEP(2)
---- INSERT CATEGORIES DATA
INSERT INTO categories VALUES (1, 'Technology');
INSERT INTO categories VALUES (2, 'Fiction');
INSERT INTO categories VALUES (3, 'History');
--- INSERT MEMBERS DATA
INSERT INTO members VALUES (1, 'Ahmed Hassan', 'ahmed.hassan@mail.com', '01012345678', 'Cairo', ADD_MONTHS(SYSDATE, -14), 250);
INSERT INTO members VALUES (2, 'Mona Ali', 'mona.ali@mail.com', '01123456789', 'Cairo', ADD_MONTHS(SYSDATE, -9), 120);
INSERT INTO members VALUES (3, 'Youssef Samir', 'youssef@gmail.com', '01234567890', 'Giza', ADD_MONTHS(SYSDATE, -3), 0);
INSERT INTO members VALUES (4, 'Amira Tarek', 'amira@mail.com', '01098765432', 'Alexandria', ADD_MONTHS(SYSDATE, -20), 80);
INSERT INTO members VALUES (5, 'Karim Nabil', 'karim@gmail.com', NULL, 'Cairo', ADD_MONTHS(SYSDATE, -7), 150);
INSERT INTO members VALUES (6, 'Sara Mahmoud', 'sara@mail.com', '01155551234', 'Giza', ADD_MONTHS(SYSDATE, -2), 400);
INSERT INTO members VALUES (7, 'Omar Fathy', 'omar@yahoo.com', '01277778888', 'Cairo', ADD_MONTHS(SYSDATE, -12), 95);
INSERT INTO members VALUES (8, 'Laila Adel', 'laila@mail.com', '01066669999', 'Mansoura', ADD_MONTHS(SYSDATE, -1), 30);
--- INSERT BOOKS DATA
INSERT INTO books VALUES (1, 'Algorithms Made Simple', 'Omar Salem', 1, 450.00, 5, 2020);
INSERT INTO books VALUES (2, 'Ancient Egypt', 'Hana Mostafa', 3, 320.00, 3, 2018);
INSERT INTO books VALUES (3, 'Pocket SQL Guide', 'Nadia Fouad', 1, 85.00, 12, 2022);
INSERT INTO books VALUES (4, 'Spring Boot in Action', 'Tarek Hegazy', 1, 500.00, 4, 2023);
INSERT INTO books VALUES (5, 'Complete Oracle Reference', 'Mina Gerges', 1, 1250.00, 2, 2021);
INSERT INTO books VALUES (6, 'The Desert Night', 'Laila Hamdy', 2, 150.00, 0, 2015);
INSERT INTO books VALUES (7, 'Egyptian History', 'Hana Mostafa', 3, 280.00, 6, 2019);
INSERT INTO books VALUES (8, 'City of Lights', NULL, 2, 199.99, 7, 2017);
INSERT INTO books VALUES (9, 'Clean Code Basics', 'Youssef Anwar', 1, 600.00, 8, 2020);
INSERT INTO books VALUES (10, 'The Last Pharaoh', 'Amr Zaki', 3, 100.00, 1, 2016);
--- INSERT LOANS DATA
INSERT INTO loans (loan_id, member_id, book_id) VALUES (1, 1, 1);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (2, 2, 3);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (3, 3, 2);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (4, 1, 4);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (5, 6, 5);
INSERT INTO loans (loan_id, member_id, book_id) VALUES (6, 7, 9);
-- STEP(3)
commit;
alter table books add (isbn varchar2(20));
alter table loans add (returned_at date);
-- STEP(4)
update loans set status ='RETURNED', RETURNED_AT=sysdate where LOAN_ID=1;
update books set price=price*0.10 where CATEGORY_ID=2;
commit;
-- STEP(5)
delete from books;
select * from books;
rollback;
select * from books;
/*
EXPLANATION:
Why TRUNCATE cannot be undone with ROLLBACK:
**DELETE: A DML command that removes data row by row and records the operation in the Undo/Redo logs;
 therefore, the action can be reversed using ROLLBACK, provided a COMMIT has not yet been issued.
**TRUNCATE: A DDL command that clears all data from a table in a single operation. It performs an
 automatic commit immediately before and after execution, making the change permanent and rendering 
 it impossible to reverse the action using ROLLBACK.
 */
 -- STEP(6)
select member_id, full_name from members where member_id not in (SELECT DISTINCT member_id FROM loans WHERE member_id IS NOT NULL); --4,5,8
delete from members where member_id =8;    --delete one member
select * from members;
rename loans to book_loans;
commit;
 --                                 <<<<<<<<<<<<<<<<<<<<<<<< QUERIES >>>>>>>>>>>>>>>>>>>>>>>>
 -- STEP(7)                       
select * from members;
 -- STEP(8)                       
select title as "Book Title", auther as "Author" , price as "Price" from books;
 -- STEP(9)                       
select distinct city from members;
 -- STEP(10)                       
select book_id,title,price,round(price*0.10,2) as "Price With Vat" from books;
 -- STEP(11)                       
select * from members where city='Cairo';
select * from members where city='cairo';
/*
EXPLANATION:
Why the result changed?
String literal comparisons in SQL (including Oracle Database) are case-sensitive by default.Therefore, 'Cairo' and 'cairo' are not equal
*/
 -- STEP(12)                       
select * from books where price>300 and copies_available>0;
 -- STEP(13)                       
select * from books where price between 100 and 500 ;
/*
ANSWER TO BOUNDARY QUESTION:
Yes, the book priced at exactly 500 will show up.
The `BETWEEN ... AND ...` operator in SQL is equivalent to : price >= 100 AND price <= 500).
*/
 -- STEP(14)                       
select member_id , full_name,city from members where city='Cairo' or city='Alexandria' or city='Giza' order by city;
select member_id , full_name,city from members where city in('Cairo','Giza','Alexandria') order by city;
/*
WHICH ONE IS CLEANER?
The second query using the `IN` operator is much cleaner, and easier to read (readable).
*/
 -- STEP(15)                       
select * from books where title like ('A%') or title like ('%y');
 -- STEP(16)                       
select * from members where phone is null;
/*
EXPLANATION:
In SQL, NULL means "unknown" or "missing data", not zero or empty text. 
Because of this, you cannot use the equals sign (=) to compare something with NULL, 
as `phone = NULL` always evaluates to UNKNOWN. 
To correctly check if a value is missing or NULL, we must use `IS NULL`.
*/
 -- STEP(17)
 select * from books order by price desc , title;         
 -- STEP(18) 
 select full_name AS "Member Name", phone AS "Phone Number", city AS "City", points AS "Loyalty Points" 
 from members where city in('Cairo','Giza') and phone is not null order by points desc;                     
 -- STEP(19)  
 select initcap(full_name || '-' || city ) as Greeting_Line, upper(full_name)as Upper_Name,
 length(full_name)as Name_Length , substr(email,1,INSTR(email, '@')-1) as email_username  from members;             
 -- STEP(20)                       
select * from members where joined_on < ADD_MONTHS(SYSDATE, -6) and points < 200;
 -- STEP(21) 
 /*
 Predict without running. In a comment, write how many rows each of these queries will return, then run them and compare:
SELECT * FROM members WHERE city = 'Cairo' OR city = 'Giza' AND points >= 100; 
           ** the query retrieves (anyone from Cairo, regardless of their points) + (anyone from Giza with points >= 100).
              all cairo + 1 giza & points=400 --> 5 rows
SELECT * FROM members WHERE (city = 'Cairo' OR city = 'Giza') AND points >= 100; 
           **  the query retrieves anyone from Cairo or Giza, provided their points are 100 or greater.
               3 cairo + 1 giza  --> 4 rows
SELECT * FROM books WHERE price BETWEEN 500 AND 100;  
           **  Expected number of rows: 0 rows (no rows will be returned, and no error will be raised).
               Reason: The BETWEEN condition always requires starting with (BETWEEN min AND max).
SELECT title, price * 1.14 AS price_vat FROM books WHERE price_vat > 500;
           **  (Error)! , (Error Code):"PRICE_VAT": invalid identifier , BECAUSE :
               You cannot use a column alias (Alias) such as `price_vat` inside a `WHERE` condition
               SELECT title, price * 1.14 AS price_vat FROM books WHERE (price * 1.14) > 500;          <---------
*/
SELECT * FROM members WHERE city = 'Cairo' OR city = 'Giza' AND points >= 100; 
SELECT * FROM members WHERE (city = 'Cairo' OR city = 'Giza') AND points >= 100; 
SELECT * FROM books WHERE price BETWEEN 500 AND 100;  
SELECT title, price * 1.14 AS price_vat FROM books WHERE price_vat > 500;
SELECT title, price * 1.14 AS price_vat FROM books WHERE (price * 1.14) > 500; 

 --                                 <<<<<<<<<<<<<<<<<<<<<<<< SHOW TABLES >>>>>>>>>>>>>>>>>>>>>>>>

select * from categories;
select * from members;
select * from books;
select * from loans;


