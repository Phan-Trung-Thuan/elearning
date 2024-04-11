/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     3/29/2024 12:59:12 PM                        */
/*==============================================================*/

drop database if exists bus;
create database bus;
use bus;

/*==============================================================*/
/* Table: ADMIN_ACCOUNT                                         */
/*==============================================================*/
create table ADMIN_ACCOUNT
(
   USER_NAME            char(6) not null  comment '',
   PASSWORD             blob not null  comment '',
   PASSWORD_SALT        blob not null  comment '',
   ADMIN_NAME           varchar(50) not null  comment '',
   GENDER               bool not null  comment '',
   EMAIL                varchar(100)  comment '',
   HIRED_DATE           date  comment '',
   primary key (USER_NAME)
);

/*==============================================================*/
/* Table: BUS_SCHEDULE                                          */
/*==============================================================*/
create table BUS_SCHEDULE
(
   BUS_TRIP_ID          char(5) not null  comment '',
   BUS_STOP_ID          char(4) not null  comment '',
   ESTIMATED_TIME       datetime  comment '',
   primary key (BUS_TRIP_ID, BUS_STOP_ID)
);

/*==============================================================*/
/* Table: BUS_STOP                                              */
/*==============================================================*/
create table BUS_STOP
(
   BUS_STOP_ID          char(4) not null  comment '',
   PROVINCE_ID          char(2) not null  comment '',
   BUS_STOP_NAME        varchar(50) not null  comment '',
   BUS_STOP_ADDRESS     varchar(200)  comment '',
   primary key (BUS_STOP_ID)
);

/*==============================================================*/
/* Table: BUS_TRIP                                              */
/*==============================================================*/
create table BUS_TRIP
(
   BUS_TRIP_ID          char(5) not null  comment '',
   ORIGIN               char(4) not null  comment '',
   DESTINATION          char(4) not null  comment '',
   BUS_TRIP_TYPE_ID     char(3) not null  comment '',
   DEPARTURE_DATE       datetime not null  comment '',
   ARRIVAL_DATE         datetime not null  comment '',
   primary key (BUS_TRIP_ID)
);

/*==============================================================*/
/* Table: BUS_TRIP_TYPE                                         */
/*==============================================================*/
create table BUS_TRIP_TYPE
(
   BUS_TRIP_TYPE_ID     char(3) not null  comment '',
   BUS_TRIP_TYPE_NAME   varchar(10) not null  comment '',
   NUMBER_OF_SEATS      int  comment '',
   PRICE_PER_SEAT       int  comment '',
   primary key (BUS_TRIP_TYPE_ID)
);

/*==============================================================*/
/* Table: CUSTOMER_ACCOUNT                                      */
/*==============================================================*/
create table CUSTOMER_ACCOUNT
(
   ACCOUNT_ID           char(5) not null  comment '',
   PHONE_NUMBER         char(10) not null  comment '',
   PASSWORD             blob  comment '',
   PASSWORD_SALT        blob  comment '',
   CUSTOMER_NAME        varchar(50) not null  comment '',
   GENDER               bool not null  comment '',
   DATE_OF_BIRTH        date  comment '',
   ADDRESS              varchar(200)  comment '',
   EMAIL                varchar(100)  comment '',
   ACCOUNT_DESCRIPTION  varchar(1024)  comment '',
   ACCOUNT_DATE         date  comment '',
   primary key (ACCOUNT_ID)
);

/*==============================================================*/
/* Table: PROVINCE                                              */
/*==============================================================*/
create table PROVINCE
(
   PROVINCE_ID          char(2) not null  comment '',
   PROVINCE_NAME        varchar(50)  comment '',
   primary key (PROVINCE_ID)
);

/*==============================================================*/
/* Table: TICKET                                                */
/*==============================================================*/
create table TICKET
(
   TICKET_ID            char(7) not null  comment '',
   SEAT_NUMBER          char(3)  comment '',
   TICKET_DATE          datetime  comment '',
   ACCOUNT_ID           char(5) not null  comment '',
   BUS_TRIP_ID          char(5) not null  comment '',
   primary key (TICKET_ID)
);

/*==============================================================*/
/* Table: TRANSACTION                                           */
/*==============================================================*/
create table TRANSACTION
(
   TRANSACTION_ID       char(8) not null  comment '',
   TRANSACTION_AMOUNT   bigint  comment '',
   TRANSACTION_DATE     datetime  comment '',
   TRANSACTION_STATUS_BEFORE tinyint  comment '',
   TRANSACTION_STATUS_AFTER tinyint  comment '',
   primary key (TRANSACTION_ID)
);

/*==============================================================*/
/* Table: TRANSACTION_LOG                                       */
/*==============================================================*/
create table TRANSACTION_LOG
(
   TICKET_ID            char(7) not null  comment '',
   TRANSACTION_ID       char(8) not null  comment '',
   primary key (TRANSACTION_ID, TICKET_ID)
);

alter table BUS_SCHEDULE add constraint FK_BUS_SCHE_BELONGS_TO_BUS_STOP foreign key (BUS_STOP_ID)
      references BUS_STOP (BUS_STOP_ID);

alter table BUS_SCHEDULE add constraint FK_BUS_SCHE_HAS_BUS_S_BUS_TRIP foreign key (BUS_TRIP_ID)
      references BUS_TRIP (BUS_TRIP_ID);

alter table BUS_STOP add constraint FK_BUS_STOP_CONTAINS_PROVINCE foreign key (PROVINCE_ID)
      references PROVINCE (PROVINCE_ID);

alter table BUS_TRIP add constraint FK_BUS_TRIP_BELONGS_O_BUS_STOP foreign key (DESTINATION)
      references BUS_STOP (BUS_STOP_ID);

alter table BUS_TRIP add constraint FK_BUS_TRIP_BELONGS_D_BUS_STOP foreign key (ORIGIN)
      references BUS_STOP (BUS_STOP_ID);

alter table BUS_TRIP add constraint FK_BUS_TRIP_CONSISTS__BUS_TRIP foreign key (BUS_TRIP_TYPE_ID)
      references BUS_TRIP_TYPE (BUS_TRIP_TYPE_ID);

alter table TICKET add constraint FK_TICKET_HAS_TICKE_BUS_TRIP foreign key (BUS_TRIP_ID)
      references BUS_TRIP (BUS_TRIP_ID);

alter table TICKET add constraint FK_TICKET_OWNS_CUSTOMER foreign key (ACCOUNT_ID)
      references CUSTOMER_ACCOUNT (ACCOUNT_ID);

alter table TRANSACTION_LOG add constraint FK_TRANSACT_PAYS_FOR_TRANSACT foreign key (TRANSACTION_ID)
      references TRANSACTION (TRANSACTION_ID);

alter table TRANSACTION_LOG add constraint FK_TRANSACT_PAY_FOR2_TICKET foreign key (TICKET_ID)
      references TICKET (TICKET_ID);

alter table ADMIN_ACCOUNT add constraint ADMIN_EMAIL_REGEXP 
	  check(EMAIL regexp '^[a-zA-Z0-9][a-zA-Z0-9]*@[a-zA-Z]*\\.[a-zA-Z]{2,63}');   
      
alter table BUS_TRIP_TYPE add constraint AVAILABLE_NO_SEATS_RANGE
	  check (NUMBER_OF_SEATS >= 0 and NUMBER_OF_SEATS <= 40);
      
alter table BUS_TRIP_TYPE add constraint PRICE_PER_SEAT_RANGE
	  check (PRICE_PER_SEAT >= 0);

alter table CUSTOMER_ACCOUNT add constraint CUSTOMER_EMAIL_REGEXP 
	  check(EMAIL regexp '^[a-zA-Z0-9][a-zA-Z0-9]*@[a-zA-Z]*\\.[a-zA-Z]{2,63}');
      
alter table CUSTOMER_ACCOUNT add constraint PHONE_NUMBER_REGEXP
      check(PHONE_NUMBER regexp '[0-9]{10}');
	
alter table CUSTOMER_ACCOUNT add constraint PHONE_NUMBER_UNIQUE
	  unique(phone_number);
      
alter table PROVINCE add constraint PROVINCE_ID_RANGE
	  check (PROVINCE_ID >= 0 and PROVINCE_ID <= 99);
      
alter table TICKET add constraint SEAT_NUMBER_REGEXP
	  check (SEAT_NUMBER regexp '[A-B][0-9][0-9]');

alter table TRANSACTION add constraint TRANSACTION_AMOUNT_RANGE
	  check (TRANSACTION_AMOUNT >= 0);

delete from PROVINCE;
insert into PROVINCE values ('55', 'Can Tho');
insert into PROVINCE values ('61', 'Ca Mau');
insert into PROVINCE values ('02', 'TP.Ho Chi Minh');

delete from BUS_STOP; 
insert into BUS_STOP values ('BXCT', '55', 'BX Can Tho', 'VP Ben xe Trung tam Can Tho, P.Hung Thanh, Q.Cai Rang, TP.Can Tho'); 
insert into BUS_STOP values ('BXMT', '02', 'BX Mien Tay', 'VP BX Mien Tay: 395, Kinh Duong Vuong, P.An Lac, Q.Binh Tan, TP.HCM');
insert into BUS_STOP values ('BXLX', '55', 'BX Long Xuyen', 'VP Long Xuyen: 392 Pham Cu Luong, Khom Tan Phu, Phuong My Quy, Tp Long Xuyen');
insert into BUS_STOP values ('BXCM', '61', 'BX Ca Mau', 'VP Ca Mau, QL 1A, Ly Thuong Kiet, P.6 , TP. Ca Mau');

delete from BUS_TRIP_TYPE;
insert into BUS_TRIP_TYPE values ('B00', 'Bunk', 36, 165000);
insert into BUS_TRIP_TYPE values ('L00', 'Limousine', 34, 165000);
insert into BUS_TRIP_TYPE values ('S00', 'Seat', 23, 165000);

delete from BUS_TRIP;
insert into BUS_TRIP values ('V21F1', 'BXCT', 'BXMT', 'B00', '2024-03-01 10:00:00', '2023-03-01 14:00:00'); 
insert into BUS_TRIP values ('V21F2', 'BXMT', 'BXCT', 'B00', '2024-03-01 10:00:00', '2023-03-01 14:00:00'); 
insert into BUS_TRIP values ('V21F3', 'BXLX', 'BXMT', 'B00', '2024-03-02 10:00:00', '2023-03-02 14:00:00'); 
insert into BUS_TRIP values ('V21F4', 'BXCT', 'BXCM', 'B00', '2024-03-02 10:00:00', '2023-03-02 14:00:00'); 
insert into BUS_TRIP values ('V21F5', 'BXCT', 'BXMT', 'L00', '2024-03-01 10:00:00', '2023-03-01 14:00:00');
insert into BUS_TRIP values ('V21F6', 'BXCT', 'BXMT', 'S00', '2024-03-01 10:00:00', '2023-03-01 14:00:00');
insert into BUS_TRIP values ('V21F7', 'BXCT', 'BXMT', 'S00', '2024-01-01 10:00:00', '2024-01-01 14:00:00');
insert into BUS_TRIP values ('V21F8', 'BXCT', 'BXMT', 'S00', '2024-02-01 10:00:00', '2024-02-01 14:00:00');

delete from BUS_SCHEDULE;
insert into BUS_SCHEDULE values ('V21F1', 'BXCT', '2024-03-01 10:00:00');
insert into BUS_SCHEDULE values ('V21F1', 'BXMT', '2024-03-01 14:00:00');
insert into BUS_SCHEDULE values ('V21F2', 'BXMT', '2024-03-01 10:00:00');
insert into BUS_SCHEDULE values ('V21F2', 'BXCT', '2024-03-01 14:00:00');


-- PROCEDURES AND FUNCTIONS
drop procedure if exists pr_getBusTripInfo;
DELIMITER $$
CREATE PROCEDURE pr_getBusTripInfo(p_bus_trip_id char(5))
BEGIN
	drop table if exists A;
	create temporary table A as 
		(select bus_stop_name as origin_bus_stop_name 
        from bus_trip BT inner join bus_stop BS on BT.origin = BS.bus_stop_id 
        where bus_trip_id = p_bus_trip_id);
	
    drop table if exists B;
    create temporary table B as
		(select bus_stop_name as destination_bus_stop_name 
        from bus_trip BT inner join bus_stop BS on BT.destination = BS.bus_stop_id 
        where bus_trip_id = p_bus_trip_id);
	
    drop table if exists C;
    create temporary table C as
		(select bus_trip_type_name, departure_date, arrival_date, number_of_seats, price_per_seat 
        from bus_trip BT inner join bus_trip_type BTT on BT.bus_trip_type_id = BTT.bus_trip_type_id
        where bus_trip_id = p_bus_trip_id); 
	select * from A,B,C;
END $$
DELIMITER ;
call pr_getBusTripInfo('V21F1');

drop procedure if exists pr_getBusTripInfoShort;
DELIMITER $$
CREATE PROCEDURE pr_getBusTripInfoShort(p_bus_trip_id char(5))
BEGIN
	drop table if exists A;
	create temporary table A as 
		(select province_name as origin_province_name 
        from bus_trip BT inner join bus_stop BS on BT.origin = BS.bus_stop_id inner join province P on BS.province_id = P.province_id 
        where bus_trip_id = p_bus_trip_id);
	
    drop table if exists B;
    create temporary table B as
		(select province_name as destination_province_name 
        from bus_trip BT inner join bus_stop BS on BT.destination = BS.bus_stop_id inner join province P on BS.province_id = P.province_id 
		where bus_trip_id = p_bus_trip_id);
	drop table if exists C;
    create temporary table C as 
		(select departure_date, price_per_seat 
        from bus_trip BT inner join bus_trip_type BTT on BT.bus_trip_type_id = BTT.bus_trip_type_id
        where bus_trip_id = p_bus_trip_id);
    select * from A,B,C;    
END $$
DELIMITER ;
call pr_getBusTripInfoShort('V21F1');

-- p_out = 0 if successfully registered, p_out = 1 if email is invalid format,
-- p_out = 2 if phone_number is invalid, p_out = 3 if phone_number is duplicated
drop procedure if exists pr_registerCustomerAccount; 
DELIMITER $$
CREATE PROCEDURE pr_registerCustomerAccount(p_customer_name varchar(50), p_gender bool, p_email varchar(100), p_phone_number char(10), p_password blob, p_password_salt blob, OUT p_out int)
pr: BEGIN
	declare v_account_id char(5);
    declare v_default_date_of_birth date;
    declare v_default_address varchar(200);
    declare v_default_account_description varchar(100);
    declare v_account_date date;
    
    set v_account_id = convert((select max(account_id)+1 from customer_account), char(5));
    set v_default_date_of_birth = '2000-01-01';
    set v_default_address = "";
    set v_default_account_description = concat("Hi! My name is ", p_customer_name);
    set v_account_date = convert(now(), date);
    
	if not (p_email regexp '^[a-zA-Z0-9][a-zA-Z0-9]*@[a-zA-Z]*\\.[a-zA-Z]{2,63}') then
	    set	p_out = 1;
        leave pr;
	end if;    
    
    if not (p_phone_number regexp '[0-9]{10}') then
		set p_out = 2;
        leave pr;
    end if;
    
    if exists (select * from customer_account where phone_number = p_phone_number) then 
		set p_out = 3;
        leave pr;
    end if;
    insert into customer_account values (v_account_id, p_phone_number, p_password, p_password_salt, p_customer_name, p_gender, v_default_date_of_birth, v_default_address, p_email, 
    v_default_account_description, v_account_date);
    
    set p_out = 0;
END pr$$
DELIMITER ;

-- p_out = 0 if changed successfully , p_out = 1 if email is invalid format,
-- p_out = 2 if phone_number is invalid, p_out = 3 if phone_number is duplicated
drop procedure if exists pr_changeCustomerAccountInfo; 
DELIMITER $$
CREATE PROCEDURE pr_changeCustomerAccountInfo(p_account_id char(5), p_phone_number char(10), p_customer_name varchar(50), p_gender bool,
 p_date_of_birth date, p_address varchar(200), p_email varchar(100), p_account_description varchar(1024), OUT p_out int)
pr: BEGIN  
    
	if not (p_email regexp '^[a-zA-Z0-9][a-zA-Z0-9]*@[a-zA-Z]*\\.[a-zA-Z]{2,63}') then
	    set	p_out = 1;
        leave pr;
	end if;    
    
    if not (p_phone_number regexp '[0-9]{10}') then
		set p_out = 2;
        leave pr;
    end if;
    
    if exists (select * from customer_account where phone_number = p_phone_number and account_id <> p_account_id) then 
		set p_out = 3;
        leave pr;
    end if;    
    
   update customer_account set 
	   customer_name = p_customer_name, 
       phone_number = p_phone_number,
	   gender = p_gender, 
	   date_of_birth = p_date_of_birth, 
	   address = p_address, 
	   email = p_email, 
	   account_description = p_account_description 
   where account_id = p_account_id;
    
    set p_out = 0;
END pr$$
DELIMITER ;

-- p_out = 0 if delete account and tickets successfully, p_out = 1 if not
drop procedure if exists pr_deleteAccount; 
DELIMITER $$
CREATE PROCEDURE pr_deleteAccount(p_account_id char(5), OUT p_out int)
pr: BEGIN 
	set p_out = 1;
    
	delete from ticket where account_id = p_account_id;    
    delete from customer_account where account_id = p_account_id;
    
    set p_out = 0;
END pr$$
DELIMITER ;


-- p_out = status after transaction
drop procedure if exists pr_getTransactionStatus; 
DELIMITER $$
CREATE PROCEDURE pr_getTransactionStatus(p_ticket_id char(7), OUT p_out tinyint)
pr: BEGIN 	
	drop table if exists A;
	create temporary table A as (
		select TRL.transaction_id, transaction_date
        from transaction_log TRL inner join transaction TR on TRL.transaction_id = TR.transaction_id
        where TRL.ticket_id = p_ticket_id
    );
        
    drop table if exists B;
    create temporary table B as (
		select transaction_id from A
        where transaction_date = (select max(A.transaction_date) from A)
    );
    
	set p_out = (select transaction_status_after 
					from transaction TR 
                    where TR.transaction_id = (select B.transaction_id from B));
	
END pr$$
DELIMITER ;
call pr_getTransactionStatus('1000001', @p_out);
select @p_out from dual;

alter table ticket add column STATE binary;
alter table ticket drop column STATE;
select * from ticket order by ticket_id;
update ticket set seat_number='A03' where ticket_id='1000003';
select * from bus_trip;
select * from bus_stop;
select * from province;

select sum(price_per_seat) as total 
from ticket T inner join bus_trip BT on T.bus_trip_id = BT.bus_trip_id inner join bus_trip_type BTT on BT.bus_trip_type_id = BTT.bus_trip_type_id where origin in (select bus_stop_id from bus_stop where province_id = @origin) group by BT.bus_trip_id;

select month(departure_date) as month_id, count(*) as no_tickets 
from ticket T inner join bus_trip BT on T.bus_trip_id = BT.bus_trip_id 
where origin in (select bus_stop_id from bus_stop where province_id = '55') and year(departure_date) = 2024 
group by month(departure_date) 
order by month_id;


select month(departure_date) as month_id, count(*) as no_tickets
from ticket T inner join bus_trip BT on T.bus_trip_id = BT.bus_trip_id 
where destination = 'BXMT' and year(departure_date) = 2024 
group by month(departure_date)
order by month_id;


select origin, destination, count(*) as no_tickets
from ticket T inner join bus_trip BT on T.bus_trip_id = BT.bus_trip_id
group by origin, destination
order by count(*) desc;

select BT.bus_trip_id, price_per_seat, count(*) as no_tickets, sum(price_per_seat) as total
from ticket T inner join bus_trip BT on T.bus_trip_id = BT.bus_trip_id 
inner join bus_trip_type BTT on BT.bus_trip_type_id = BTT.bus_trip_type_id
group by BT.bus_trip_id;

select price_per_seat
from TICKET T inner join BUS_TRIP BT on T.bus_trip_id = BT.bus_trip_id
inner join BUS_TRIP_TYPE BTT on BT.bus_trip_type_id = BTT.bus_trip_type_id
where ticket_id = '1000001';

SELECT price_per_seat
        FROM TICKET T INNER JOIN BUS_TRIP BT ON T.bus_trip_id = BT.bus_trip_id
        INNER JOIN BUS_TRIP_TYPE BTT ON BT.bus_trip_type_id = BTT.bus_trip_type_id
        WHERE ticket_id = '1000001';

select * from ticket;        
select * from transaction_log;
select * from transaction;

select * from bus_trip;
insert into bus_trip values('V21F9', 'BXMT', 'BXLX', 'B00', '2023-09-10 10:00:00', '2023-09-10 14:00:00');
select min(YEAR(departure_date)), max(YEAR(departure_date)) from bus_trip;