/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     4/2/2024 8:56:17 PM                          */
/*==============================================================*/
DROP DATABASE IF EXISTS ELEARNING;
CREATE DATABASE ELEARNING CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE ELEARNING;
SET character_set_results = 'utf8', character_set_client = 'utf8', character_set_connection = 'utf8', character_set_database = 'utf8', character_set_server = 'utf8';

/*==============================================================*/
create table CELL
(
   CELL_ID              char(6) not null  comment '',
   CLASS_ID             char(5)  comment '',
   CELL_TITLE           varchar(50)  comment '',
   CELL_DESCRIPTION     varchar(500)  comment '',
   CELL_CREATEDDATE     datetime  comment '',
   primary key (CELL_ID)
);


/*==============================================================*/
create table CLASS
(
   CLASS_ID             char(5) not null  comment '',
   INSTRUCTOR_ID        char(6)  comment '',
   CLASS_NAME           varchar(100)  comment '',
   primary key (CLASS_ID)
);

/*==============================================================*/
create table ENROLLMENT
(
   CLASS_ID             char(5) not null  comment '',
   STUDENT_ID           char(8) not null  comment '',
   primary key (CLASS_ID, STUDENT_ID)
);

/*==============================================================*/
create table HOMEWORK
(
   CELL_ID              char(6) not null  comment '',
   HOMEWORK_EXPIRATIONDATE datetime  comment '',
   primary key (CELL_ID)
);

/*==============================================================*/
create table INSTRUCTOR
(
   INSTRUCTOR_ID        char(6) not null  comment '',
   INSTRUCTOR_NAME      varchar(50)  comment '',
   INSTRUCTOR_DATEOFBIRTH date  comment '',
   INSTRUCTOR_PASSWORD  varchar(255)  comment '',
   primary key (INSTRUCTOR_ID)
);

/*==============================================================*/
create table NOTIFICATION
(
   CELL_ID              char(6) not null  comment '',
   NOTIFICATION_NOTE    varchar(200)  comment '',
   primary key (CELL_ID)
);

/*==============================================================*/
create table STUDENT
(
   STUDENT_ID           char(8) not null  comment '',
   STUDENT_NAME        varchar(50)  comment '',
   STUDENT_DATEOFBIRTH  date  comment '',
   STUDENT_PASSWORD     varchar(255)  comment '',
   primary key (STUDENT_ID)
);

alter table CELL add constraint FK_CELL_BELONGS_CLASS foreign key (CLASS_ID)
      references CLASS (CLASS_ID);

alter table CLASS add constraint FK_CLASS_MANAGES_INSTRUCT foreign key (INSTRUCTOR_ID)
      references INSTRUCTOR (INSTRUCTOR_ID);

alter table ENROLLMENT add constraint FK_ENROLLME_ENROLLS2_STUDENT foreign key (STUDENT_ID)
      references STUDENT (STUDENT_ID);

alter table ENROLLMENT add constraint FK_ENROLLME_IS_JOINED_CLASS foreign key (CLASS_ID)
      references CLASS (CLASS_ID);

alter table HOMEWORK add constraint FK_HOMEWORK_IS_A_HW_CELL foreign key (CELL_ID)
      references CELL (CELL_ID);

alter table NOTIFICATION add constraint FK_NOTIFICA_IS_A_HW2_CELL foreign key (CELL_ID)
      references CELL (CELL_ID);

/*==============================================================*/

-- INSERT INTO STUDENT VALUES ('B2111001', 'Nguyen Van A', '2003-01-01', 'pass001');
-- INSERT INTO STUDENT VALUES ('B2111002', 'Tran Thi B', '2003-05-01', 'pass002');
-- INSERT INTO STUDENT VALUES ('B2111003', 'Phan Van C', '2003-11-01', 'pass003');

-- INSERT INTO INSTRUCTOR VALUES ('GV001', 'Thai Ha X', '1986-01-01', 'pass001');
-- INSERT INTO INSTRUCTOR VALUES ('GV002', 'Huu Van Y', '1980-03-01', 'pass002');
-- INSERT INTO INSTRUCTOR VALUES ('GV003', 'Huynh Van Z', '1989-12-01', 'pass003');

INSERT INTO CLASS VALUES ('10001', 'GV001', 'CL001 - Lớp lập trình căn bản (HK1, năm 2023-2024)');
INSERT INTO CLASS VALUES ('10002', 'GV003', 'CL002 - Lớp lập trình hướng đối tượng (HK2, năm 2022-2023)');
INSERT INTO CLASS VALUES ('10003', 'GV002', 'CL003 - Lớp lập trình nâng cao (HK1, năm 2023-2023)');
INSERT INTO CLASS VALUES ('10004', 'GV002', 'CL004 - Lớp hệ quản trị cơ sở dữ liệu (HK2, năm 2023-2024)');
INSERT INTO CLASS VALUES ('10005', 'GV003', 'CL005 - Lớp phân tích và thiết kế hệ thống (HK1, năm 2024-2025)');
INSERT INTO CLASS VALUES ('10006', 'GV001', 'CL006 - Lớp phân tích và thiết kế thuật toán (HK2, năm 2024-2025)');
INSERT INTO CLASS VALUES ('10007', 'GV002', 'CL007 - Lớp mạng máy tính (HK1, năm 2022-2023)');
INSERT INTO CLASS VALUES ('10008', 'GV003', 'CL008 - Lớp mạng máy tính (HK1, năm 2023-2024)');
INSERT INTO CLASS VALUES ('10009', 'GV001', 'CL009 - Lớp lập trình web (HK2, năm 2023-2024)');

INSERT INTO ENROLLMENT VALUES ('10001', 'B2111001');
INSERT INTO ENROLLMENT VALUES ('10002', 'B2111001');
INSERT INTO ENROLLMENT VALUES ('10003', 'B2111001');
INSERT INTO ENROLLMENT VALUES ('10001', 'B2111002');
INSERT INTO ENROLLMENT VALUES ('10001', 'B2111003');
INSERT INTO ENROLLMENT VALUES ('10002', 'B2111002');
INSERT INTO ENROLLMENT VALUES ('10002', 'B2111003');

INSERT INTO CELL VALUES ('100001', '10001', 'Thông tin học phần CL001', 
'Chào mừng đến với lớp lập trình căn bản! Lớp này là một bước đầu tuyệt vời để khám phá và nắm vững những kiến thức cơ bản về lập trình. 
Trong khoá học này, chúng tôi sẽ khám phá các nguyên tắc căn bản của lập trình và hướng dẫn bạn cách sử dụng ngôn ngữ lập trình phổ biến 
như Python, Java hoặc C++. Bạn sẽ học cách viết mã, đặt tên biến, sử dụng các cấu trúc điều khiển như rẽ nhánh và vòng lặp, 
và tổ chức mã của mình để tạo ra các chương trình hoạt động một cách logic và hiệu quả.',
now());

INSERT INTO CELL VALUES ('100002', '10001', 'Nộp bài tập nhóm đợt 1',
'Sinh viên vui lòng nộp bài tập nhóm đã được giao ở tuần 7 tại đây',
now());

INSERT INTO CELL VALUES ('100003', '10001', 'Về lịch học', 
'Thứ 2: 13h30 hàng tuần tại phòng 210/DI',
now());

INSERT INTO NOTIFICATION VALUES ('100001', 'Đây là dòng ghi chú. Chỉ có giảng viên thấy');
INSERT INTO NOTIFICATION VALUES ('100003', 'Đây là dòng ghi chú. Chỉ có giảng viên thấy');
INSERT INTO HOMEWORK values ('100002', '2024-05-10 10:00:00');

SELECT NOW();
SELECT * FROM STUDENT;
SELECT * FROM INSTRUCTOR;
SELECT * FROM CLASS;
SELECT * FROM ENROLLMENT;
SELECT * FROM CELL;
SELECT * FROM NOTIFICATION;
SELECT * FROM HOMEWORK;

SELECT cell_title, cell_description, cell_createddate, notification_note, homework_expirationdate 
FROM CELL C LEFT JOIN NOTIFICATION N on C.cell_id = N.cell_id 
LEFT JOIN HOMEWORK H on C.cell_id = H.cell_id
where class_id = 'CL001';

SELECT cell_title, cell_description, cell_createddate, notification_note FROM cell C INNER JOIN notification N on C.cell_id = N.cell_id where class_id = 'CL001';
SELECT cell_title, cell_description, cell_createddate, homework_expirationdate FROM cell C INNER JOIN homework H on C.cell_id = H.cell_id;
SELECT C.cell_id, cell_title, cell_description, cell_createddate, notification_note, homework_expirationdate FROM CELL C LEFT JOIN NOTIFICATION N on C.cell_id = N.cell_id LEFT JOIN HOMEWORK H on C.cell_id = H.cell_id WHERE C.cell_id = "100001";

-- delete from HOMEWORK;
-- delete from NOTIFICATION;
-- delete from CELL;
-- delete from STUDENT;
-- delete from INSTRUCTOR;