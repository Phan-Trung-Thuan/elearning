/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     1/6/2024 1:46:05 PM                          */
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
   PASSWORD             blob  comment '',
   PASSWORD_SALT        blob  comment '',
   ADMIN_NAME           varchar(50)  comment '',
   GENDER               bool  comment '',
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
   PROVINCE_ID          tinyint not null  comment '',
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
   BUS_TRIP_TYPE        varchar(10) not null  comment '',
   DEPARTURE_DATE       datetime not null  comment '',
   ARRIVAL_DATE         datetime not null  comment '',
   AVAILABLE_NO_SEATS   tinyint not null  comment '',
   PRICE_PER_SEAT       int  comment '',
   primary key (BUS_TRIP_ID)
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
   PROVINCE_ID          tinyint not null  comment '',
   PROVINCE_NAME        varchar(50)  comment '',
   primary key (PROVINCE_ID)
);

/*==============================================================*/
/* Table: TICKET                                                */
/*==============================================================*/
create table TICKET
(
   TICKET_ID            char(7) not null  comment '',
   ACCOUNT_ID           char(5) not null  comment '',
   BUS_TRIP_ID          char(5) not null  comment '',
   SEAT_NUMBER          char(3)  comment '',
   TICKET_DATE          date  comment '',
   primary key (ACCOUNT_ID, BUS_TRIP_ID, TICKET_ID)
);


alter table BUS_SCHEDULE add constraint FK_BUS_SCHE_HAS_1_BUS_TRIP foreign key (BUS_TRIP_ID)
      references BUS_TRIP (BUS_TRIP_ID);

alter table BUS_SCHEDULE add constraint FK_BUS_SCHE_HAS_2_BUS_STOP foreign key (BUS_STOP_ID)
      references BUS_STOP (BUS_STOP_ID);     
      
alter table BUS_STOP add constraint FK_BUS_STOP_CONSISTOF_PROVINCE foreign key (PROVINCE_ID)
      references PROVINCE (PROVINCE_ID);

alter table BUS_TRIP add constraint FK_BUS_TRIP_CONTAIN_1_BUS_STOP foreign key (ORIGIN)
      references BUS_STOP (BUS_STOP_ID);

alter table BUS_TRIP add constraint FK_BUS_TRIP_CONTAIN_2_BUS_STOP foreign key (DESTINATION)
      references BUS_STOP (BUS_STOP_ID);

alter table TICKET add constraint FK_TICKET_IN_BUS_TRIP foreign key (BUS_TRIP_ID)
      references BUS_TRIP (BUS_TRIP_ID);

alter table TICKET add constraint FK_TICKET_OWN_CUSTOMER foreign key (ACCOUNT_ID)
      references CUSTOMER_ACCOUNT (ACCOUNT_ID);

alter table ADMIN_ACCOUNT add constraint ADMIN_EMAIL_REGEXP 
	  check(EMAIL regexp '^[a-zA-Z0-9][a-zA-Z0-9]*@[a-zA-Z]*\\.[a-zA-Z]{2,63}');
    
alter table BUS_TRIP add constraint BUS_TRIP_TYPE_RANGE
	  check (BUS_TRIP_TYPE in ('Seat', 'Bunk', 'Limousine'));
      
alter table BUS_TRIP add constraint AVAILABLE_NO_SEATS_RANGE
	  check (AVAILABLE_NO_SEATS >= 0 and AVAILABLE_NO_SEATS <= 50);
      
alter table BUS_TRIP add constraint PRICE_PER_SEAT_RANGE
	  check (PRICE_PER_SEAT >= 0);

alter table CUSTOMER_ACCOUNT add constraint CUSTOMER_EMAIL_REGEXP 
	  check(EMAIL regexp '^[a-zA-Z0-9][a-zA-Z0-9]*@[a-zA-Z]*\\.[a-zA-Z]{2,63}');
      
alter table CUSTOMER_ACCOUNT add constraint PHONE_NUMBER_REGEXP
	  check (regexp_like(PHONE_NUMBER, '[0-9]{10}'));
	
alter table CUSTOMER_ACCOUNT add constraint PHONE_NUMBER_UNIQUE
	  unique(phone_number);
      
alter table PROVINCE add constraint PROVINCE_ID_RANGE
	  check (PROVINCE_ID >= 0 and PROVINCE_ID <= 99);
      
alter table TICKET add constraint SEAT_NUMBER_REGEXP
	  check (regexp_like(SEAT_NUMBER, '[A-B][0-9][0-9]'));
	
insert into PROVINCE values (55, 'Can Tho');
insert into PROVINCE values (61, 'Ca Mau');
insert into PROVINCE values (02, 'TP.Ho Chi Minh');

insert into BUS_STOP values ('BXCT', 55, 'Can Tho', 'VP Ben xe Trung tam Can Tho, P.Hung Thanh, Q.Cai Rang, TP.Can Tho'); 
insert into BUS_STOP values ('BXMT', 02, 'BX Mien Tay', 'VP BX Mien Tay: 395, Kinh Duong Vuong, P.An Lac, Q.Binh Tan, TP.HCM');
insert into BUS_STOP values ('BXLX', 55, 'BX Long Xuyen', 'VP Long Xuyên: 392 Phạm Cự Lượng, Khóm Tân Phú, Phường Mỹ Quý, Tp Long Xuyên');
insert into BUS_STOP values ('BXCM', 61, 'BX Ca Mau', 'VP Cà Mau, QL 1A, Lý Thường Kiệt, P.6 , TP.Cà Mau');

insert into BUS_TRIP values ('V21F1', 'BXCT', 'BXMT', 'Bunk', '2024-03-01 10:00:00', '2023-03-01 14:00:00', 40, 165000); 
insert into BUS_TRIP values ('V21F2', 'BXMT', 'BXCT', 'Bunk', '2024-03-01 10:00:00', '2023-03-01 14:00:00', 40, 165000); 
insert into BUS_TRIP values ('V21F3', 'BXLX', 'BXMT', 'Bunk', '2024-03-02 10:00:00', '2023-03-02 14:00:00', 40, 165000); 
insert into BUS_TRIP values ('V21F4', 'BXCT', 'BXCM', 'Bunk', '2024-03-02 10:00:00', '2023-03-02 14:00:00', 40, 160000); 
insert into BUS_TRIP values ('V21F5', 'BXCT', 'BXMT', 'Limousine', '2024-03-01 10:00:00', '2023-03-01 14:00:00', 40, 165000);
insert into BUS_TRIP values ('V21F6', 'BXCT', 'BXMT', 'Seat', '2024-03-01 10:00:00', '2023-03-01 14:00:00', 40, 165000);
insert into BUS_TRIP values ('V21F7', 'BXCT', 'BXMT', 'Seat', '2024-01-01 10:00:00', '2024-01-01 14:00:00', 40, 165000);
insert into BUS_TRIP values ('V21F8', 'BXCT', 'BXMT', 'Seat', '2024-02-01 10:00:00', '2024-02-01 14:00:00', 40, 165000);

insert into BUS_SCHEDULE values ('V21F1', 'BXCT', '2024-03-01 10:00:00');
insert into BUS_SCHEDULE values ('V21F1', 'BXMT', '2024-03-01 14:00:00');
insert into BUS_SCHEDULE values ('V21F2', 'BXMT', '2024-03-01 10:00:00');
insert into BUS_SCHEDULE values ('V21F2', 'BXCT', '2024-03-01 14:00:00');



-- insert into ADMIN_ACCOUNT values('admin1', 'admin', 'Phan Van Thanh', True, 'thanh2521@gmail.com', '2024-01-05');

-- insert into CUSTOMER_ACCOUNT values('10001', '0909027057', '123', 'Nguyen Van A', 1, '2003-01-02', '163 Dong Van Cong, P.An Thoi, Q.Ninh Kieu, TPCT', 
-- 'vana265@gmail.com', 'This is Nguyen Van A account', '2024-02-20');


select * from customer_account;
select * from admin_account;
select * from ticket;
delete from ticket;
delete from customer_account;
delete from admin_account;

-- PROCEDURES AND FUNCTIONS
drop procedure if exists pr_getBusTripInfo;
DELIMITER $$
CREATE PROCEDURE pr_getBusTripInfo(p_bus_trip_id char(5))
BEGIN
	drop table if exists A;
	create temporary table A as 
		(select bus_stop_name as origin_bus_stop_name from bus_trip BT inner join bus_stop BS on BT.origin = BS.bus_stop_id where bus_trip_id = p_bus_trip_id);
	
    drop table if exists B;
    create temporary table B as
		(select bus_stop_name as destination_bus_stop_name from bus_trip BT inner join bus_stop BS on BT.destination = BS.bus_stop_id where bus_trip_id = p_bus_trip_id);
	
    drop table if exists C;
    create temporary table C as
		(select bus_trip_type, departure_date, arrival_date, available_no_seats, price_per_seat from bus_trip where bus_trip_id = p_bus_trip_id); 
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
		(select province_name as origin_province_name from bus_trip BT inner join bus_stop BS on BT.origin = BS.bus_stop_id
			inner join province P on BS.province_id = P.province_id where bus_trip_id = p_bus_trip_id);
	
    drop table if exists B;
    create temporary table B as
		(select province_name as destination_province_name from bus_trip BT inner join bus_stop BS on BT.destination = BS.bus_stop_id
			inner join province P on BS.province_id = P.province_id where bus_trip_id = p_bus_trip_id);
	drop table if exists C;
    create temporary table C as 
		(select departure_date, price_per_seat from bus_trip where bus_trip_id = p_bus_trip_id);
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
    
    if not (regexp_like(p_phone_number, '[0-9]{10}')) then
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
    
    if not (regexp_like(p_phone_number, '[0-9]{10}')) then
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

select * from ticket order by ticket_id;
select * from bus_trip;
select * from bus_stop;
select * from province;

select bus_stop_id, bus_stop_name, province_name from bus_stop BS inner join province P on BS.province_id = P.province_id order by bus_stop_name;

select month(departure_date) as month_id, count(*) as no_tickets
from ticket T inner join bus_trip BT on T.bus_trip_id = BT.bus_trip_id
where origin in (select bus_stop_id from bus_stop where province_id = 55) and destination='BXMT'
group by month(departure_date)
order by month_id;


select month(departure_date) as month_id, count(*) as no_tickets
from ticket T inner join bus_trip BT on T.bus_trip_id = BT.bus_trip_id
where destination = 'BXMT'
group by month(departure_date)
order by month_id;

select origin, destination, count(*) as no_tickets
from ticket T inner join bus_trip BT on T.bus_trip_id = BT.bus_trip_id
group by origin, destination
order by count(*) desc;


select BT.bus_trip_id, price_per_seat, count(*) as no_tickets, sum(price_per_seat) as total
from ticket T inner join bus_trip BT on T.bus_trip_id = BT.bus_trip_id 
group by BT.bus_trip_id;
