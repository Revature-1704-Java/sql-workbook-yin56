conn chinook/p4ssw0rd
begin
DBMS_output.put_line('employee');
end;
/
--2.1 SELECT

SELECT * FROM EMPLOYEE;

SELECT * FROM EMPLOYEE WHERE Lastname = 'King';

SELECT * FROM EMPLOYEE WHERE FIRSTNAME = 'Andrew' AND REPORTSTO IS NULL;


--2.2 ORDER BY

SELECT * FROM ALBUM ORDER BY TITLE DESC;

SELECT firstname FROM CUSTOMER ORDER BY city ASC;

--2.3 INSERT

INSERT INTO GENRE (GENREID, NAME) VALUES (26, 'Kpop');
INSERT INTO GENRE (GENREID, NAME) VALUES (27, 'Dubstep');

INSERT INTO EMPLOYEE (EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email)
VALUES (9 , 'Chen', 'Brian', 'IT Staff','', '01-JAN-95', '01-JAN-17', '123 Walnut Road', 'Las Vegas', 'NV', 'United States', '34254', '144-234-4325', '345-352-3266', 'brianc@gmail.com'); 

INSERT INTO EMPLOYEE (EmployeeId, LastName, FirstName, Title, ReportsTo, BirthDate, HireDate, Address, City, State, Country, PostalCode, Phone, Fax, Email)
VALUES (10 , 'Che', 'Bria', 'IT Staff', '' ,'01-JAN-96', '01-JAN-17', '123 Walnut Road', 'Las Vegas', 'NV', 'United States', '34254', '144-234-4325', '345-352-3266', 'bc@gmail.com'); 


INSERT INTO CUSTOMER (CustomerId, FirstName, LastName, Company, Address, City, State, Country, PostalCode, Phone, Fax, Email, Supportrepid)
VALUES (60 , 'Chen', 'Brian', '', '123 Walnut Road', 'Las Vegas', 'NV', 'United States', '34254', '144-234-4325', '345-352-3266', 'brianc@gmail.com', 3); 

INSERT INTO CUSTOMER (CustomerId, FirstName, LastName, Company, Address, City, State, Country, PostalCode, Phone, Fax, Email, Supportrepid)
VALUES (61 , 'Che', 'Bria', '', '123 Walnut Road', 'Las Vegas', 'NV', 'United States', '34254', '144-234-4325', '345-352-3266', 'bc@gmail.com', 5); 


--UPDATE

UPDATE Customer SET FirstName = 'Robert', lastName = 'Walter'
WHERE FirstName = 'Aaron' AND lastName = 'Mitchell';

UPDATE Artist SET Name = 'CCR'
WHERE Name = 'Creedence Clearwater Revival';


--LIKE
Select * FROM INVOICE
WHERE billingaddress like 'T%';


--2.6 Between
select * from invoice where total between 15 and 50;
select * from employee where hiredate between '01-JUN-03' and '01-MAR-04';

--2.7 DELETE
Select invoiceid from invoice where customerid = 32;
DELETE FROM INVOICELINE WHERE invoiceid = 245;
DELETE FROM INVOICELINE WHERE invoiceid = 268;
DELETE FROM INVOICELINE WHERE invoiceid = 290;
DELETE FROM INVOICELINE WHERE invoiceid = 342;
DELETE FROM INVOICELINE WHERE invoiceid = 50;
DELETE FROM INVOICELINE WHERE invoiceid = 61;
DELETE FROM INVOICELINE WHERE invoiceid = 116;
DELETE FROM INVOICE WHERE customerid = 32;
DELETE FROM Customer WHERE firstName = 'Robert' and lastName = 'Walter';



--3.0 SQL Functions

--3.1 System defined functions

select to_char(sysdate, 'Dy DD-Mon-YYYY HH24:MI:SS') as "Current Time"
from dual;

select mediatypeid, length(name) FROM MEDIATYPE;

--3.2 SYSTEM DEFINED AGGREGATE FUNCTION
create or replace function find_avg
return NUMBER as avg_number NUMBER; 
begin
    select AVG(total) into avg_number from invoice;
    return avg_number;
end;
/

declare
    avgnum number;
begin
    avgnum := find_avg;
    dbms_output.put_line('invoice avg= ' || avgnum);
end;
/


create or replace function expensive_track
return number as max_price number;
begin
    select MAX(unitprice) INTO max_price FROM invoiceline;
    return max_price;
end;
/

declare
    price number;
begin
    price := expensive_track;
    dbms_output.put_line('most expensive track  = ' || price);
end;
/

--3.3 USER DEFINED FUNCTIONS

create or replace function find_avg2
return NUMBER as 
avg_number NUMBER;
counter NUMBER;
temp_var NUMBER;
max_row NUMBER;
begin
    SELECT COUNT(*) INTO max_row FROM INVOICELINE;
    counter:= 0;
    loop
        counter := counter + 1;
        SELECT unitprice INTO temp_var FROM INVOICELINE WHERE invoicelineid = counter;
        avg_number:= avg_number + temp_var;
        IF counter = max_row then
            exit;
        END IF;
    end loop;
    
    avg_number := avg_number / counter;
    return avg_number;
end;
/

declare
    avgnum number;
begin
    avgnum := find_avg2;
    dbms_output.put_line('invoice avg2= ' || avgnum);
end;
/



--3.4 USER DEFINED TABLE VALUED FUNCTIONS
create or replace function get_employees
return sys_refcursor as
empname sys_refcursor;
begin
    open empname for select firstname, lastname from employee where birthdate > '31-DEC-68';
    return empname;
end;
/

 
declare
  r sys_refcursor;
  fname varchar2(100);
  lname varchar2(100);
begin
  r := get_employees;
  loop
    fetch r into fname, lname;
    exit when r%notfound;
        dbms_output.put_line(fname || lname || 'born after 1968');
  end loop;
end;
/

--4.0 Stored Procedures

--4.1 Basic Stored Procedure

create or replace procedure
get_all_employees(s out sys_REFCURSOR) as
begin
    open s for select firstname, lastname from employee;
end get_all_employees;
/



declare
    s SYS_REFCURSOR;
    some_first employee.firstname%type;
    some_last employee.lastname%type;
begin
    get_all_employees(s);
     loop
        fetch s into some_first, some_last;
        exit when s%notfound;
        dbms_output.put_line('Employee name: ' || some_first|| some_last);
    end loop;
end;
/

--4.2 Stored Procedure Input Parameters
create or replace procedure
update_employee(eid in number,ln in varchar2, fn in varchar2, ttle in varchar2, rpto in number,bday in date, hday in date, addr in varchar2,
cty in varchar2, st in varchar2, cntry in varchar2, pcode in varchar2, phonenum in varchar2, faxnum in varchar2, emails in varchar2)
as
begin
    update employee set lastname = ln, firstname = fn, title = ttle, reportsto = rpto, birthdate = birthdate, hiredate = hday, address = addr,
    city = cty, state = st, country = cntry, postalcode = pcode, phone = phonenum, fax = faxnum, email = emails where employeeid = eid;
    
end update_employee;
/


begin
    update_employee(1, 'yin', 'sam', 'da boss', 3, '22-JAN-99', '12-DEC-17', '333 lala rd', 'maple city', 'CA', 'USA', '93204', '832-382-3928', '328-323-6464', 'slemd@lems.com');
end;
/


create or replace procedure get_manager(eid in number,mid out employee.employeeid%type)
as
begin
   select reportsto into mid from employee where employeeid = eid;
end get_manager;
/

declare
    managerid employee.employeeid%type;
begin
    get_manager(1, managerid);   
     dbms_output.put_line('manager id: ' || managerid);
end;
/

--4.3
create or replace procedure get_manager(cid in number,cname out customer.firstname%type, ccmpy out customer.company%type)
as
begin
   select firstname, company into cname, ccmpy from customer where customerid = cid;
end get_manager;
/

declare
    cname customer.firstname%type;
    cmpy customer.company%type;
begin
    get_manager(1, cname, cmpy);
    dbms_output.put_line('customers name: ' || cname || 'the company is' || cmpy);
end;
/

--5.0 Transactions
--first transaction
create or replace procedure delete_invoice(invid in number)
as
begin

    delete from invoiceline where invoiceid = invid;    --remove child dependency
    delete from invoice where invoiceid = invid;
    
    commit;
end;
/

--test previous transcation
begin
    delete_invoice(1);
end;
/

--2nd transcation
create or replace procedure insert_customer(cid in number, fn in varchar2, ln in varchar2, comp in varchar2, addr in varchar2,
cty in varchar2, st in varchar2, cntry in varchar2, pcode in varchar2, phonenum in varchar2, faxnum in varchar2, emails in varchar2, sptid in number)
as
begin
    insert into customer (customerid, firstname, lastname, company, address, city, state ,country, postalcode, phone ,fax, email, supportrepid)   
    values(cid, fn, ln, comp, addr, cty, st, cntry, pcode, phonenum, faxnum, emails, sptid);
    commit;
end;
/

--test previous transaction
--begin
--    insert_customer(60, 'sam', 'y', 'lala corp', '123 lala lan2', 'lala city', 'new york', 'usa', '23525', '234-2365-2356', '634-453-3265', 'sam@lala.com', 3);
--end;
--/



--6.0 Triggers
--insert trigger
create or replace trigger employee_inserted
    after insert on employee
    for each row
begin
    dbms_output.put_line('new employee added');
end;
/

--update trigger
create or replace trigger album_updated
    after update on album
    for each row
begin
    dbms_output.put_line('new album update happened');
end;
/


--delete trigger
create or replace trigger customer_deleted
    after delete on customer
    for each row
begin
    dbms_output.put_line('customer has been deleted');
end;
/

--7.0 Joins

--INNER
SELECT CUSTOMER.Customerid, INVOICE.invoiceid FROM CUSTOMER
INNER JOIN INVOICE ON CUSTOMER.Customerid = INVOICE.Customerid;

--LEFT OUTER
SELECT CUSTOMER.Customerid, CUSTOMER.FIRSTNAME, CUSTOMER.LASTNAME, INVOICE.invoiceid,INVOICE.TOTAL FROM CUSTOMER
LEFT OUTER JOIN INVOICE ON CUSTOMER.Customerid = INVOICE.Customerid;

--RIGHT OUTER
SELECT ARTIST.NAME, ALBUM.TITLE FROM ARTIST
RIGHT OUTER JOIN ALBUM ON ARTIST.artistid = ALBUM.artistid;

--CROSS JOIN
SELECT ARTIST.name FROM ALBUM
CROSS JOIN ARTIST ORDER BY ARTIST.name ASC;

--SELF JOIN
SELECT e1.firstname, e2.firstname FROM employee e1, employee e2 
WHERE e1.employeeid = e2.reportsto;

--COMPLICATED INNER JOIN

select * from invoiceline inner join invoice on invoiceline.invoiceid = invoice.invoiceid
    inner join customer on invoice.customerid = customer.customerid
    inner  join employee on employee.employeeid = customer.supportrepid
    inner join track on track.trackid = invoiceline.trackid
    inner join genre on track.genreid = genre.genreid
    inner join mediatype on mediatype.mediatypeid = track.mediatypeid
    inner join album on album.albumid = track.albumid
    inner join playlisttrack on  playlisttrack.trackid = track.trackid
    inner join playlist on playlisttrack.playlistid =  playlist.playlistid
    inner join artist on artist.artistid = album.artistid;


