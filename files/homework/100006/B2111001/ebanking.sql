DROP DATABASE IF EXISTS EBANKING;
SET GLOBAL log_bin_trust_function_creators = 1;
CREATE DATABASE eBanking;
USE eBanking;

/*==============================================================*/
/* Table: ACCOUNT_CUSTOMER                                      */
/*==============================================================*/
create table ACCOUNT_CUSTOMER
(
   ACCOUNTCS_ID         char(9) not null,
   ACCOUNTCS_LOGIN      char(5) not null,
   ACCOUNTCS_PASSWORD   varchar(50) not null,
   ACCOUNTCS_BALANCE    int unsigned not null,
   ACCOUNTCS_DESC       varchar(100),
   ACCOUNTCS_DATE       date not null,
   BANK_ID              char(5) not null,
   primary key (ACCOUNTCS_ID)
);

/*==============================================================*/
/* Table: ACCOUNT_EMPLOYEE                                      */
/*==============================================================*/
create table ACCOUNT_EMPLOYEE
(
   ACCOUNTEMP_ID        char(9) not null,
   ACCOUNTEMP_LOGIN     char(5) not null,
   ACCOUNTEMP_PASSWORD  varchar(50) not null,
   primary key (ACCOUNTEMP_ID)
);

/*==============================================================*/
/* Table: BANK                                                  */
/*==============================================================*/
create table BANK
(
   BANK_ID              char(5) not null,
   BANK_NAME            varchar(100) not null,
   BANK_ADDRESS         varchar(100) not null,
   BANK_CITY            varchar(30) not null,
   primary key (BANK_ID)
);

/*==============================================================*/
/* Table: BENEFICIARY                                           */
/*==============================================================*/
create table BENEFICIARY
(
   ACCOUNTCS_ID         char(9) not null,
   BENEFICIARYACCOUNT_ID char(9) not null,
   ALIAS                varchar(50),
   primary key (ACCOUNTCS_ID, BENEFICIARYACCOUNT_ID)
);

/*==============================================================*/
/* Table: CUSTOMER                                              */
/*==============================================================*/
create table CUSTOMER
(
   CUSTOMER_ID          char(5) not null,
   CUSTOMER_NAME        varchar(100) not null,
   CUSTOMER_PHONE       char(10) not null,
   CUSTOMER_EMAIL       varchar(100),
   CUSTOMER_ADDRESS     varchar(200) not null,
   CUSTOMER_CITY        varchar(30) not null,
   primary key (CUSTOMER_ID)
);

/*==============================================================*/
/* Table: EMPLOYEE                                              */
/*==============================================================*/
create table EMPLOYEE
(
   EMPLOYEE_ID          char(5) not null,
   EMPLOYEE_NAME        varchar(100),
   primary key (EMPLOYEE_ID)
);

/*==============================================================*/
/* Table: E_TRANSACTION                                           */
/*==============================================================*/
create table E_TRANSACTION
(
   TRANSACTION_ID       char(10) not null,
   ACCOUNTCS_ID1        char(9),
   ACCOUNTCS_ID2        char(9),
   TRANSACTION_DATE     date not null,
   TRANSACTION_DESC     varchar(100),
   TRANSACTION_AMOUNT   int unsigned not null,
   primary key (TRANSACTION_ID)
);
 
alter table CUSTOMER add constraint CUSTOMER_PHONE_UNIQUE 
	unique(CUSTOMER_PHONE);

alter table CUSTOMER add constraint CUSTOMER_PHONE_REGEXP 
	check(CUSTOMER_PHONE regexp '[0-9]{10}');
    
alter table CUSTOMER add constraint CUSTOMER_EMAIL_REGEXP
	check(CUSTOMER_EMAIL regexp '^[a-zA-Z0-9][a-zA-Z0-9]*@[a-zA-Z]*\\.[a-zA-Z]{2,63}');
    
alter table ACCOUNT_CUSTOMER add constraint ACCOUNT_CS_BALANCE
	check(ACCOUNTCS_BALANCE > 0);

alter table E_TRANSACTION add constraint TRANSACT_AMOUNT
	check (TRANSACTION_AMOUNT > 0);

   
alter table ACCOUNT_CUSTOMER add constraint FK_ACCOUNT__REFERENCE_CUSTOMER foreign key (ACCOUNTCS_LOGIN)
      references CUSTOMER (CUSTOMER_ID);
      
alter table ACCOUNT_CUSTOMER add constraint FK_ACCOUNT__REFERENCE_BANK foreign key (BANK_ID)
      references BANK (BANK_ID);

alter table ACCOUNT_EMPLOYEE add constraint FK_ACCOUNT__REFERENCE_EMPLOYEE foreign key (ACCOUNTEMP_LOGIN)
      references EMPLOYEE (EMPLOYEE_ID);
 
alter table BENEFICIARY add constraint FK_BENEFICI_REFERENCE_ACCOUNT_1 foreign key (ACCOUNTCS_ID)
      references ACCOUNT_CUSTOMER (ACCOUNTCS_ID) ON DELETE CASCADE;

alter table BENEFICIARY add constraint FK_BENEFICI_REFERENCE_ACCOUNT_2 foreign key (BENEFICIARYACCOUNT_ID)
      references ACCOUNT_CUSTOMER (ACCOUNTCS_ID) ON DELETE CASCADE;

alter table E_TRANSACTION add constraint FK_TRANSACT_REFERENCE_ACCOUNT_1 foreign key (ACCOUNTCS_ID1)
      references ACCOUNT_CUSTOMER (ACCOUNTCS_ID) ON DELETE CASCADE;

alter table E_TRANSACTION add constraint FK_TRANSACT_REFERENCE_ACCOUNT_2 foreign key (ACCOUNTCS_ID2)
      references ACCOUNT_CUSTOMER (ACCOUNTCS_ID) ON DELETE CASCADE;

insert into employee values('emp01', 'Phan Dinh Anh');
insert into employee values('emp02', 'Vo Anh Thu');

insert into customer values('cs001', 'Nguyen Thi Chu An', '0909123001', 'an27@gmail.com', '101, Bui Huu Nghia, P.Binh Thuy, Q.Binh Thuy, TPCT', 'Can Tho');
insert into customer values('cs002', 'Pham Yen Binh', '0909123002', 'binh67@gmail.com', '68A/24, Dong Van Cong, P.An Thoi, Q.Binh Thuy, TPCT', 'Can Tho');
insert into customer values('cs003', 'Do Hung Cuong', '0909123003', 'cuong52@gmail.com', '17, Nguyen Van Trang, P.Ben Thanh, Q.1, TPHCM', 'Thanh pho Ho Chi Minh');
insert into customer values('cs004', 'Tran Thi My Dung', '0909123004', 'dung24@gmail.com', '9, Ly Thai To, P.My Phuoc, Thanh pho Long Xuyen, An Giang', 'An Giang');
insert into customer values('cs005', 'Phan Thi Hong Em', '0909123005', 'em634@gmail.com', '99G, Duong so 8, P.Thuong Thach, Q.Cai Rang, TPCT', 'Can Tho');

insert into bank values('BK001', 'MSB', '254, Mau Than, P.An Hoa, Q.Ninh Kieu, TPCT', 'Can Tho');
insert into bank values('BK002', 'PAB', '74H, Nguyen Van Cu noi dai, P.An Khanh, Q.Ninh Kieu, TPCT', 'Can Tho');

insert into account_customer values('271023001', 'cs001', '123', 1000000, 'Customer 01', '2023-10-20', 'BK001');
insert into account_customer values('271023002', 'cs002', '123', 1000000, 'Customer 02', '2022-9-20', 'BK001');
insert into account_customer values('271023003', 'cs003', '123', 1000000, 'Customer 03', '2020-7-31', 'BK001');
insert into account_customer values('271023004', 'cs003', '123', 1000000, 'Customer 03', '2021-2-14', 'BK002');
insert into account_customer values('271023005', 'cs004', '123', 1000000, 'Customer 04', '2023-1-20', 'BK002');

insert into account_employee values('102157001', 'emp01', '123');
insert into account_employee values('102157002', 'emp02', '123');

insert into beneficiary values('271023001', '271023002', 'Yen Binh');
insert into beneficiary values('271023001', '271023003', 'Hung Cuong');
insert into beneficiary values('271023003', '271023001', 'Chu An');

insert into e_transaction values('3702512001', '271023001', '271023002', '2023-09-01', 'From Nguyen Thi Chu An', 50000);
insert into e_transaction values('3702512002', '271023001', '271023003', '2023-08-01', 'From Nguyen Thi Chu An', 100000);
insert into e_transaction values('3702512003', '271023002', '271023001', '2023-07-01', 'From Pham Yen Binh', 20000);
insert into e_transaction values('3702512004', '271023001', '271023004', '2023-06-01', 'From Nguyen Thi Chu An', 50000);
insert into e_transaction values('3702512005', '271023003', '271023004', '2023-05-01', 'From Do Hung Cuong', 60000);

/* ============================================================================== 
LOGIN FUNCTIONALITIES								PROCEDURES/FUNCTION
LOGIN												FN_CHECK_EMP_LOGIN_ACCOUNT, FN_CHECK_CUS_LOGIN_ACCOUNT
============================================================================== 
							**************** 
============================================================================== 
CUSTOMER FUNCTIONALITIES							PROCEDURES/FUNCTIONS
1. Show account information							PR_SHOW_CUSTOMER_ACCOUNT
2. Change account information						PR_SHOW_CUSTOMER_INFO, PR_CHANGE_CUSTOMER_INFO
3. Show balance details								PR_SHOW_ACCOUNT_BALANCE
4. Transfer money									PR_MAKE_TRANSACTION, PR_ADD_BENEFICIARY
5. Transaction history								PR_SHOW_TRANSACTION_HISTORY
6. Beneficiaries settings							PR_ADD_BENEFICIARY, PR_DELETE_BENEFICIARY

==============================================================================
							**************** 
============================================================================== 
EMPLOYEE FUNCTIONALITIES							PROCEDURES/FUNCTIONS
1. Register account (customer) 						PR_REGISTER_ACCOUNT
2. Delete account (customer)						PR_DELETE_ACCOUNT
3. List all customer accounts						Using SQL Statement
4. Select a customer account						FN_CHECK_ACCOUNT_EXIST
    4.1. Show account information					PR_SHOW_CUSTOMER_ACCOUNT
    4.2. Change account information					PR_SHOW_CUSTOMER_INFO, PR_CHANGE_CUSTOMER_INFO 
    4.3. Show balance details						PR_SHOW_ACCOUNT_BALANCE
    4.4. Add money (from real money)				PR_ADD_MONEY
    4.5. Transfer money								PR_MAKE_TRANSACTION, FN_CHECK_ACCOUNT_EXIST
    4.6. Withdraw money (to real money)				PR_WITHDRAW_MONEY		
    4.7. Transaction history						PR_SHOW_TRANSACTION_HISTORY
    
============================================================================== 
 */
/* ==========================================
	THIS PROCEDURE RETURN THE RESULT SET OF CUSTOMER TABLE
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_ADD_BENEFICIARY$$
CREATE PROCEDURE PR_ADD_BENEFICIARY (ACCOUNT_CUS_ID CHAR(9), BENE_ID CHAR(9), ALI VARCHAR(50), OUT MSG INT)
add_benefi: BEGIN
	IF NOT EXISTS (SELECT * FROM ACCOUNT_CUSTOMER WHERE ACCOUNTCS_ID = BENE_ID) THEN
		SET MSG = 1;
        LEAVE add_benefi;
    END IF;
    
    IF EXISTS (SELECT * FROM BENEFICIARY WHERE ACCOUNTCS_ID = ACCOUNT_CUS_ID AND BENEFICIARYACCOUNT_ID = BENE_ID) THEN
		SET MSG = 2;
        LEAVE add_benefi; 
	END IF;
    
    INSERT INTO BENEFICIARY VALUES (ACCOUNT_CUS_ID, BENE_ID, ALI);
	SET MSG = 0;
END$$
DELIMITER ;

/* ==========================================
	THIS PROCEDURE ADD MONEY TO A ACCOUNT
	    SET MSG = 0 IF THE TRANSACTION WAS SUCCESSFULLY
    NOTE:
		ONLY USED BY EMPLOYEE
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_ADD_MONEY$$
CREATE PROCEDURE PR_ADD_MONEY (TRANS_ID CHAR(10), ACCOUNT_CUS_ID CHAR(9), MONEY BIGINT, OUT MSG INT)
BEGIN
	DECLARE CUS_NAME varchar(100);
    
    START TRANSACTION;
    
    SELECT CUSTOMER_NAME INTO CUS_NAME
    FROM CUSTOMER C INNER JOIN ACCOUNT_CUSTOMER AC ON C.CUSTOMER_ID = AC.ACCOUNTCS_LOGIN
    WHERE ACCOUNTCS_ID = ACCOUNT_CUS_ID;
    
    UPDATE ACCOUNT_CUSTOMER
	SET ACCOUNTCS_BALANCE = ACCOUNTCS_BALANCE + MONEY
	WHERE ACCOUNTCS_ID = ACCOUNT_CUS_ID; 
    	
	INSERT INTO E_TRANSACTION VALUES (TRANS_ID, NULL, ACCOUNT_CUS_ID, SYSDATE(), CONCAT('Add money to ', CUS_NAME), MONEY);
	COMMIT;
    SET MSG = 0;
END$$
DELIMITER ;


USE EBANKING;

/* ==========================================
	THIS PROCEDURE CHANGE CUSTOMER INFO
	    SET MSG = 0 IF UPDATE SUCCESSFULLY
	    SET MSG = 1 IF PHONE NUMBER IS INVALID
	    SET MSG = 2 IF PHONE NUMBER IS USED BY ANOTHER CUSTOMER
	    SET MSG = 3 IF EMAIL IS INVALID
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_CHANGE_CUSTOMER_INFO$$
CREATE PROCEDURE PR_CHANGE_CUSTOMER_INFO (CUS_ID CHAR(5), NEW_NAME VARCHAR(100), NEW_PHONE CHAR(10), NEW_EMAIL VARCHAR(100), NEW_ADDRESS VARCHAR(200), NEW_CITY VARCHAR(30), OUT MSG INT)
pr_change_cus_info: BEGIN
	IF NOT NEW_PHONE REGEXP '[0-9]{10}' THEN
		SET MSG = 1;
        LEAVE pr_change_cus_info;
    END IF;
    
    IF EXISTS (SELECT * FROM CUSTOMER WHERE CUSTOMER_ID <> CUS_ID AND CUSTOMER_PHONE = NEW_PHONE) THEN
		SET MSG = 2;
        LEAVE pr_change_cus_info;
    END IF;
    
    IF NOT NEW_EMAIL REGEXP '^[a-zA-Z0-9][a-zA-Z0-9]*@[a-zA-Z]*\\.[a-zA-Z]{2,63}' THEN
		SET MSG = 3;
        LEAVE pr_change_cus_info;
	END IF;
    
    UPDATE CUSTOMER 
    SET CUSTOMER_NAME = NEW_NAME, CUSTOMER_PHONE = NEW_PHONE, CUSTOMER_EMAIL = NEW_EMAIL,
    CUSTOMER_ADDRESS = NEW_ADDRESS, CUSTOMER_CITY = NEW_CITY
    WHERE CUSTOMER_ID = CUS_ID;
    
    SET MSG = 0;
END$$
DELIMITER ;

/* ========================================== 
	THIS PROCEDURE DELETE A ACCOUNT
	    SET MSG = 0 IF THE DELETION IS SUCCESSFUL.
	    SET MSG = 1 IF THE ACCOUNT ID IS NOT IN THE APPLICATION BANK.
    NOTE:
		ONLY USED BY EMPLOYEE
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_DELETE_ACCOUNT$$
CREATE PROCEDURE PR_DELETE_ACCOUNT (ACC_ID CHAR(9), OUT MSG INT)
pr_delete_account: BEGIN
    IF NOT EXISTS (SELECT * FROM ACCOUNT_CUSTOMER WHERE ACCOUNTCS_ID = ACC_ID AND BANK_ID = 'BK001') THEN
		SET MSG = 1; 
		LEAVE pr_delete_account;
    END IF;
     
	DELETE FROM ACCOUNT_CUSTOMER
    WHERE ACCOUNTCS_ID = ACC_ID;
    SET MSG = 0;
END$$
DELIMITER ;

/* ==========================================
	THIS PROCEDURE DELETE A BENEFICIARY
	    SET MSG = 0 IF THE DELETION IS SUCCESSFULLY
	    SET MSG = 1 IF THE BENE_ID IS NOT FOUND IN ACCOUNT_CUS_ID'S LIST OF BENEFICIARIES
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_DELETE_BENEFICIARY$$
CREATE PROCEDURE PR_DELETE_BENEFICIARY (ACCOUNT_CUS_ID CHAR(9), BENE_ID CHAR(9), OUT MSG INT)
pr_delete_beneficiary: BEGIN
	IF NOT EXISTS (SELECT * FROM BENEFICIARY WHERE ACCOUNTCS_ID = ACCOUNT_CUS_ID AND BENEFICIARYACCOUNT_ID = BENE_ID) THEN 
		SET MSG = 1;
        LEAVE pr_delete_beneficiary;
    END IF;
	DELETE FROM BENEFICIARY WHERE ACCOUNTCS_ID = ACCOUNT_CUS_ID AND BENEFICIARYACCOUNT_ID = BENE_ID;
	SET MSG = 0;
END$$
DELIMITER ;

/* ==========================================
	THIS PROCEDURE WILL CREATE A TRANSACTION
	    SET MSG = 0 IF THE TRANSACTION IS SUCCESS
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_MAKE_TRANSACTION$$
CREATE PROCEDURE PR_MAKE_TRANSACTION (TRANS_ID CHAR(10), SENDER_ID CHAR(9), RECEIVER_ID CHAR(9),
									TRANS_DESCRIBE VARCHAR(100), TRANS_AMOUNT BIGINT, OUT MSG INT)
BEGIN
    START TRANSACTION;
	UPDATE ACCOUNT_CUSTOMER
    SET ACCOUNTCS_BALANCE = ACCOUNTCS_BALANCE - TRANS_AMOUNT
    WHERE ACCOUNTCS_ID = SENDER_ID;
    
    UPDATE ACCOUNT_CUSTOMER
    SET ACCOUNTCS_BALANCE = ACCOUNTCS_BALANCE + TRANS_AMOUNT
    WHERE ACCOUNTCS_ID = RECEIVER_ID;
    
	INSERT INTO E_TRANSACTION VALUES (TRANS_ID, SENDER_ID, RECEIVER_ID, SYSDATE(), TRANS_DESCRIBE, TRANS_AMOUNT);
	COMMIT;
    SET MSG = 0;
END$$
DELIMITER ;

/* ==========================================
	THIS PROCEDURE REGISTER NEW ACCOUNT
	    SET MSG = 0 IF THE REGISTRATION IS SUCCESSFUL
	    SET MSG = 1 IF THE PHONE NUMBER IS NOT IN THE DATABASE
	    SET MSG = 2 IF THE PHONE NUMBER IS ALREADY USED BY AN ANOTHER ACCOUNT
	    SET MSG = 3 IF THE BANK ID IS NOT THE APPLICATION BANK ID
    NOTE:
		ONLY USED BY EMPLOYEE
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_REGISTER_ACCOUNT$$
CREATE PROCEDURE PR_REGISTER_ACCOUNT (ACC_ID CHAR(9), CUS_PHONE CHAR(10), ACC_PASS VARCHAR(50), 
									ACC_BAL BIGINT, ACC_DES VARCHAR(100), B_ID CHAR(5), OUT MSG INT)
pr_register_account: BEGIN
	DECLARE CUS_ID CHAR(5);
    SELECT CUSTOMER_ID INTO CUS_ID FROM CUSTOMER WHERE CUSTOMER_PHONE = CUS_PHONE;
    
	IF CUS_ID IS NULL THEN 
		SET MSG = 1;
        LEAVE pr_register_account;
    ELSEIF EXISTS(SELECT * FROM ACCOUNT_CUSTOMER WHERE ACCOUNTCS_LOGIN = CUS_ID AND BANK_ID = B_ID) THEN
		SET MSG = 2;
        LEAVE pr_register_account;
    ELSEIF B_ID <> 'BK001' THEN
		SET MSG = 3; 
		LEAVE pr_register_account;
    END IF;
    
	INSERT INTO ACCOUNT_CUSTOMER VALUES (ACC_ID, CUS_ID, ACC_PASS, ACC_BAL, ACC_DES, SYSDATE(), B_ID);
    SET MSG = 0;
END$$
DELIMITER ;

/* ==========================================
	THIS PROCEDURE RETURN THE RESULT SET OF BALANCE MENU
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_SHOW_ACCOUNT_BALANCE$$
CREATE PROCEDURE PR_SHOW_ACCOUNT_BALANCE (ACCOUNT_CUS_ID CHAR(9))
BEGIN
	SELECT 	ACCOUNTCS_ID AS 'Account ID',
		CUSTOMER_NAME AS 'Customer Name',
		ACCOUNTCS_BALANCE AS 'Current Balance',
		ACCOUNTCS_BALANCE - 50000 AS 'Available Balance'
    FROM CUSTOMER C INNER JOIN ACCOUNT_CUSTOMER AC ON C.CUSTOMER_ID = AC.ACCOUNTCS_LOGIN
    WHERE AC.ACCOUNTCS_ID = ACCOUNT_CUS_ID;
END$$
DELIMITER ;

/* ==========================================
	THIS PROCEDURE RETURN THE RESULT SET OF CUSTOMER ACCOUNT
    NOTE:
		ONLY USE FOR EMPLOYEE
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_SHOW_CUSTOMER_ACCOUNT$$
CREATE PROCEDURE PR_SHOW_CUSTOMER_ACCOUNT (ACCOUNT_CUS_ID CHAR(9))
BEGIN
	SELECT CUSTOMER_NAME AS 'Customer Name', 
	       CUSTOMER_PHONE AS 'Phone Number', 
	       CUSTOMER_EMAIL AS 'Email', 
	       CUSTOMER_ADDRESS AS 'Address', 
	       CUSTOMER_CITY AS 'City', 
	       ACCOUNTCS_ID AS 'Account ID', 
	       ACCOUNTCS_DESC AS 'Account Description', 
	       DATE_FORMAT(ACCOUNTCS_DATE, '%W %D %M %Y') AS 'Account Date'
    FROM ACCOUNT_CUSTOMER AC INNER JOIN CUSTOMER C ON AC.ACCOUNTCS_LOGIN = C.CUSTOMER_ID
    WHERE ACCOUNTCS_ID = ACCOUNT_CUS_ID;
END$$
DELIMITER ;

/* ==========================================
	THIS PROCEDURE RETURN THE RESULT SET OF CUSTOMER TABLE
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_SHOW_CUSTOMER_INFO$$
CREATE PROCEDURE PR_SHOW_CUSTOMER_INFO (CUS_ID CHAR(5))
BEGIN
	SELECT CUSTOMER_NAME AS 'Customer Name', 
	       CUSTOMER_PHONE AS 'Phone Number', 
	       CUSTOMER_EMAIL AS 'Email', 
	       CUSTOMER_ADDRESS AS 'Address', 
	       CUSTOMER_CITY AS 'City'
    FROM CUSTOMER
    WHERE CUSTOMER_ID = CUS_ID;
END$$
DELIMITER ;

/* ==========================================
	THIS PROCEDURE RETURN THE RESULT SET OF TRANSACTION HISTORY
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_SHOW_TRANSACTION_HISTORY$$
CREATE PROCEDURE PR_SHOW_TRANSACTION_HISTORY (ACCOUNT_CUS_ID CHAR(9), FROM_D DATE, TO_D DATE)
BEGIN
	    
	SELECT TRANSACTION_ID AS 'Transaction ID', 
	       TRANSACTION_DATE AS 'Transaction Date', 
	       TRANSACTION_DESC AS 'Transaction Description', 
			IF (ACCOUNTCS_ID1 = ACCOUNT_CUS_ID, -TRANSACTION_AMOUNT, TRANSACTION_AMOUNT) AS 'Amount'
    FROM E_TRANSACTION
    WHERE (ACCOUNTCS_ID1 = ACCOUNT_CUS_ID OR ACCOUNTCS_ID2 = ACCOUNT_CUS_ID) AND TRANSACTION_DATE BETWEEN FROM_D AND TO_D;
END$$
DELIMITER ;

/* ==========================================
	THIS PROCEDURE WITHDRAW MONEY TO A ACCOUNT
	    SET MSG = 0 IF THE TRANSACTION IS SUCCESSFUL
    NOTE:
		ONLY USED BY EMPLOYEE
*/
DELIMITER $$
DROP PROCEDURE IF EXISTS PR_WITHDRAW_MONEY$$
CREATE PROCEDURE PR_WITHDRAW_MONEY (TRANS_ID CHAR(10), ACCOUNT_CUS_ID CHAR(9), MONEY BIGINT, OUT MSG INT)
BEGIN
	DECLARE CUS_NAME varchar(100);
    START TRANSACTION;	
    
    SELECT CUSTOMER_NAME INTO CUS_NAME
    FROM CUSTOMER C INNER JOIN ACCOUNT_CUSTOMER AC ON C.CUSTOMER_ID = AC.ACCOUNTCS_LOGIN
    WHERE ACCOUNTCS_ID = ACCOUNT_CUS_ID;
    
    UPDATE ACCOUNT_CUSTOMER
	SET ACCOUNTCS_BALANCE = ACCOUNTCS_BALANCE - MONEY
	WHERE ACCOUNTCS_ID = ACCOUNT_CUS_ID; 
    	
	INSERT INTO E_TRANSACTION VALUES (TRANS_ID, ACCOUNT_CUS_ID, NULL, SYSDATE(), CONCAT('Withdraw money from ', CUS_NAME), MONEY);
	COMMIT;
    SET MSG = 0;
END$$
DELIMITER ;

/* ==========================================
	THIS FUNCTION RETURN TRUE (1) IF THE ACCOUNT ID EXIST IN DATABASE
*/
DELIMITER $$
DROP FUNCTION IF EXISTS FN_CHECK_ACCOUNT_EXIST$$
CREATE FUNCTION FN_CHECK_ACCOUNT_EXIST (ACC_ID CHAR(9), B_ID CHAR(5))
RETURNS INT
BEGIN
	RETURN EXISTS(SELECT * FROM ACCOUNT_CUSTOMER WHERE ACCOUNTCS_ID = ACC_ID AND BANK_ID = B_ID);
END$$
DELIMITER ;

/* ==========================================
    THIS FUNCTION RETURN CUSTOMER ACCOUNT ID IF EXIST, OTHERWISE RETURN NULL   
    
*/
DELIMITER $$
DROP FUNCTION IF EXISTS FN_CHECK_CUS_LOGIN_ACCOUNT$$
CREATE FUNCTION FN_CHECK_CUS_LOGIN_ACCOUNT (CUS_PHONE CHAR(10), PASS VARCHAR(50))
RETURNS CHAR(9)
BEGIN
	DECLARE CUS_ID CHAR(5);
	DECLARE ACC_ID CHAR(9);
    DECLARE PA VARCHAR(50);
	DECLARE BANK CHAR(5);
    
	SELECT CUSTOMER_ID INTO CUS_ID
	FROM CUSTOMER
	WHERE CUSTOMER_PHONE = CUS_PHONE;

    SELECT ACCOUNTCS_ID, ACCOUNTCS_PASSWORD, BANK_ID INTO ACC_ID, PA, BANK
    FROM ACCOUNT_CUSTOMER
    WHERE ACCOUNTCS_LOGIN = CUS_ID AND BANK_ID = 'BK001';
    
    IF ((CUS_ID IS NOT NULL) AND (PA = PASS)) THEN
		RETURN ACC_ID;
	ELSE
		RETURN NULL;
	END IF;
END$$
DELIMITER ;

/* ==========================================
	THIS FUNCTION RETURN EMPLOYEE ACCOUNT ID IF EXIST, OTHERWISE RETURN NULL
    
*/
DELIMITER $$
DROP FUNCTION IF EXISTS FN_CHECK_EMP_LOGIN_ACCOUNT$$
CREATE FUNCTION FN_CHECK_EMP_LOGIN_ACCOUNT (EMP_ID CHAR(5), PASS VARCHAR(50))
RETURNS CHAR(9)
BEGIN
	DECLARE ACC_ID CHAR(9);
	DECLARE PA VARCHAR(50);

	IF (EMP_ID IN (SELECT EMPLOYEE_ID FROM EMPLOYEE)) THEN
		SELECT ACCOUNTEMP_ID, ACCOUNTEMP_PASSWORD INTO ACC_ID, PA 
		FROM ACCOUNT_EMPLOYEE 
		WHERE ACCOUNTEMP_LOGIN = EMP_ID;

		IF (PA = PASS) THEN
			RETURN ACC_ID;
		END IF;
	END IF;
    
	RETURN NULL;
	
END$$
DELIMITER ;