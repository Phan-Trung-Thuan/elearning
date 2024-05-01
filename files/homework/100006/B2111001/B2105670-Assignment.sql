/*
    University management
    UM_STUDENT(stu_id, stu_name, gender, phone_number, stu_email)       
    UM_DEPARTMENT(dept_id, dept_name)
    UM_INSTRUCTOR(ins_id, ins_name, ins_email, dept_id)
    UM_COURSE(crs_id, crs_name, credits, dept_id)    
    UM_SECTION(sec_id, crs_id, ins_id, room)
    UM_ENROLLMENT(stu_id, sec_id, academic_year, semester, grade) (NOTE: student can improve a course's grade by enrolling that course again)
*/
--UM_STUDENT(stu_id, stu_name, gender, phone_number, stu_email)

CREATE USER university IDENTIFIED BY "123"
DEFAULT TABLESPACE USERS
QUOTA UNLIMITED ON USERS;
GRANT ALL PRIVILEGES TO university;

/*CONNECT TO user "university"*/

CREATE TABLE UM_STUDENT(
    stu_id char(8) primary key check(regexp_like(stu_id, '[A-Z]\d{7}')), 
    stu_name varchar2(100) not null, 
    gender char(1) not null check(gender = 'M' or gender = 'F'),
    phone_number char(12) check(regexp_like(phone_number, '\d{4}-\d{3}-\d{3}')), 
    stu_email varchar2(50) check(regexp_like(stu_email, '[a-z0-9]+@student.ctu.edu.vn'))
);

--UM_DEPARTMENT(dept_id, dept_name)
CREATE TABLE UM_DEPARTMENT(
    dept_id char(2) primary key, 
    dept_name varchar2(100) not null
);

--UM_INSTRUCTOR(ins_id, ins_name, ins_email, dept_id)
CREATE TABLE UM_INSTRUCTOR(
    ins_id char(6) primary key check(regexp_like(ins_id, '\d{6}')), 
    ins_name varchar2(100) not null, 
    ins_email varchar2(50) check(regexp_like(ins_email, '[a-z0-9]+@ctu.edu.vn')), 
    dept_id char(2) constraint ins_fk_dep references UM_DEPARTMENT(dept_id)
);

--UM_COURSE(crs_id, crs_name, credits, dept_id)
CREATE TABLE UM_COURSE(
    crs_id char(5) primary key, 
    crs_name varchar2(100) not null, 
    credits smallint check(credits >= 0 and credits <= 4), 
    dept_id char(2) constraint crs_fk_dep references UM_DEPARTMENT(dept_id)
);

--UM_SECTION(sec_id, crs_id, ins_id, room)
CREATE TABLE UM_SECTION(
    sec_id varchar2(10) primary key, 
    crs_id char(5) constraint sec_fk_crs references UM_COURSE(crs_id), 
    ins_id char(6) constraint src_fk_crs references UM_INSTRUCTOR(ins_id), 
    room varchar2(10) check(regexp_like(room, '\d{3}/[A-Z0-9]+'))
);

--UM_ENROLLMENT(stu_id, sec_id, academic_year, semester, grade)
CREATE TABLE UM_ENROLLMENT(
    stu_id char(8) constraint en_fk_stu references UM_STUDENT(stu_id), 
    sec_id varchar2(10) constraint en_fk_sec references UM_SECTION(sec_id), 
    academic_year char(9) not null check(regexp_like(academic_year, '[0-9]{4}-[0-9]{4}')), 
    semester char(1) check(semester = '1' or semester = '2' or semester = '3'),
    grade number(4,2),
    primary key(stu_id, sec_id, academic_year, semester)
);

--------------------------------TABLES FOR TRIGGERS------------------------------------
CREATE TABLE UM_GRADE_ENROLLMENT_LOG(
    editUser varchar2(100),
    editTime timestamp,
    stu_id char(8),
    sec_id varchar2(10),
    academic_year char(9),
    semester char(1),
    oldGrade number(4,2),
    newGrade number(4,2)
);

CREATE TABLE UM_ROOM_SECTION_LOG(
    editUser varchar2(100),
    editTime timestamp,
    sec_id varchar2(10),
    oldRoom varchar2(10),
    newRoom varchar2(10)
);

CREATE TABLE UM_DEL_SECTION_LOG(
    editUser varchar2(100),
    editTime timestamp,
    sec_id varchar2(10),
    crs_id char(5),
    ins_id char(6),
    room varchar2(10)
);


--------------------------------INSERT DATA----------------------------------------
INSERT INTO UM_STUDENT VALUES('B2001247', 'Nguyen Thanh Nam', 'M', '0989-277-461', 'namb2001247@student.ctu.edu.vn');
INSERT INTO UM_STUDENT VALUES('B2004579', 'Nguyet Anh Giang', 'F', '0929-147-554', 'giangB2004579@student.ctu.edu.vn');
INSERT INTO UM_STUDENT VALUES('B2021668', 'Vo Thi Anh Thu', 'F', '0909-288-925', 'thub2021668@student.ctu.edu.vn');
INSERT INTO UM_STUDENT VALUES('B2100247', 'Vo Van Cuong', 'M', '0292-657-774', 'cuongb2100247@student.ctu.edu.vn');
INSERT INTO UM_STUDENT VALUES('B2105911', 'Tran Thi Tu Nhu', 'F', '0876-014-057', 'nhub2105911@student.ctu.edu.vn');
INSERT INTO UM_STUDENT VALUES('B2107501', 'Duong Van Sau', 'M', '0939-180-246', 'saub2107501@student.ctu.edu.vn');

INSERT INTO UM_DEPARTMENT VALUES('DI', 'Khoa Cong Nghe Thong Tin Va Truyen Thong');
INSERT INTO UM_DEPARTMENT VALUES('FL', 'Khoa Ngoai Ngu');
INSERT INTO UM_DEPARTMENT VALUES('KT', 'Khoa Kinh Te');
INSERT INTO UM_DEPARTMENT VALUES('MT', 'Khoa Chinh Tri');
INSERT INTO UM_DEPARTMENT VALUES('KL', 'Khoa Luat');

INSERT INTO UM_INSTRUCTOR VALUES('001236', 'Nguyen Van Cang', 'cang001236@ctu.edu.vn', 'DI');
INSERT INTO UM_INSTRUCTOR VALUES('004671', 'Vo Van Thuong', 'thuong004671@ctu.edu.vn', 'FL');
INSERT INTO UM_INSTRUCTOR VALUES('005286', 'Do Thi Nguyet Anh', 'anh005286@ctu.edu.vn', 'KT');
INSERT INTO UM_INSTRUCTOR VALUES('007414', 'Le Truc Quynh', 'quynh007414@ctu.edu.vn', 'MT');
INSERT INTO UM_INSTRUCTOR VALUES('012498', 'Tran Thi Truc Linh', 'linh012498@ctu.edu.vn', 'KL');
INSERT INTO UM_INSTRUCTOR VALUES('013632', 'Tran Dang Khoa', 'khoa013632@ctu.edu.vn', 'DI');
INSERT INTO UM_INSTRUCTOR VALUES('014987', 'Pham Thi Tu', 'tu014987@ctu.edu.vn', 'KL');

INSERT INTO UM_COURSE VALUES('CT305', 'Mang may tinh', 3, 'DI');
INSERT INTO UM_COURSE VALUES('CT207', 'Tin hoc can ban A', 2, 'DI');
INSERT INTO UM_COURSE VALUES('FL002', 'Tieng Anh can ban 2', 2, 'FL');
INSERT INTO UM_COURSE VALUES('FL201', 'Tieng Anh quoc te', 4, 'FL');
INSERT INTO UM_COURSE VALUES('KT307', 'Kinh te luong', 3, 'KT');
INSERT INTO UM_COURSE VALUES('ML016', 'Triet hoc Mac-Lenin', 2, 'MT');
INSERT INTO UM_COURSE VALUES('ML018', 'Kinh te chinh tri Mac-Lenin', 2, 'MT');
INSERT INTO UM_COURSE VALUES('KL001', 'Phap luat dai cuong', 2, 'KL');

INSERT INTO UM_SECTION VALUES('CT305M01', 'CT305', '001236', '210/DI');
INSERT INTO UM_SECTION VALUES('CT207M02', 'CT207', '013632', '212/DI');
INSERT INTO UM_SECTION VALUES('FL002D01', 'FL002', '005286', '107/B1');
INSERT INTO UM_SECTION VALUES('FL201D03', 'FL201', '005286', '212/C1');
INSERT INTO UM_SECTION VALUES('KT307A01', 'KT307', '005286', '101/KSP');
INSERT INTO UM_SECTION VALUES('ML016F01', 'ML016', '007414', '108/C2');
INSERT INTO UM_SECTION VALUES('ML016F02', 'ML016', '007414', '210/C1');
INSERT INTO UM_SECTION VALUES('ML018F01', 'ML018', '007414', '211/A2');
INSERT INTO UM_SECTION VALUES('KL001D01', 'KL001', '012498', '212/MT');
INSERT INTO UM_SECTION VALUES('KL001D02', 'KL001', '014987', '210/KSP');

INSERT INTO UM_ENROLLMENT VALUES('B2001247', 'CT305M01', '2020-2021', 1, 1.0);
INSERT INTO UM_ENROLLMENT VALUES('B2001247', 'CT207M02', '2020-2021', 1, 5.5);
INSERT INTO UM_ENROLLMENT VALUES('B2001247', 'KL001D02', '2020-2021', 1, 6.5);
INSERT INTO UM_ENROLLMENT VALUES('B2001247', 'CT305M01', '2020-2021', 2, 7.0);
INSERT INTO UM_ENROLLMENT VALUES('B2004579', 'FL002D01', '2021-2022', 2, 2.2);
INSERT INTO UM_ENROLLMENT VALUES('B2004579', 'KL001D01', '2021-2022', 2, 3.2);
INSERT INTO UM_ENROLLMENT VALUES('B2004579', 'ML016F01', '2021-2022', 3, 4.0);
INSERT INTO UM_ENROLLMENT VALUES('B2100247', 'KL001D02', '2021-2022', 3, 9.2);
INSERT INTO UM_ENROLLMENT VALUES('B2100247', 'FL002D01', '2022-2023', 1, 8.7);
INSERT INTO UM_ENROLLMENT VALUES('B2105911', 'KT307A01', '2022-2023', 2, 4.6);

----------------------------SOME PROCEDURES AND FUNCTIONS------------------------------
-- 1) Add a student
CREATE OR REPLACE PROCEDURE UM_PR_ADD_STUDENT(p_stu_id char, p_stu_name varchar2, p_gender char, p_phone_number char, p_stu_email varchar2)
IS
BEGIN
    insert into UM_STUDENT values(p_stu_id, p_stu_name, p_gender, p_phone_number, p_stu_email);
END;

-- 2) Delete an student
CREATE OR REPLACE PROCEDURE UM_PR_DEL_STUDENT(p_stu_id char)
IS
BEGIN
    delete from UM_ENROLLMENT where stu_id = p_stu_id;
    delete from UM_STUDENT where stu_id = p_stu_id;
END;

-- 3) Add an instructor
CREATE OR REPLACE PROCEDURE UM_PR_ADD_INSTRUCTOR(p_ins_id char, p_ins_name varchar2, p_ins_email varchar2, p_dep_id char)
IS
BEGIN
    insert into UM_INSTRUCTOR values(p_ins_id, p_ins_name, p_ins_email, p_dep_id);
END;

-- 4) Delete an instructor
CREATE OR REPLACE PROCEDURE UM_PR_DEL_INSTRUCTOR(p_ins_id char)
IS
    --Find all sections of the instructor
    CURSOR c_sec_ids is (
        select sec_id from UM_SECTION where ins_id = p_ins_id
        );
BEGIN
    --Delete all enrollments which including the instructor's sections
    FOR i in c_sec_ids
    LOOP
        delete from UM_ENROLLMENT where sec_id = i.sec_id;
    END LOOP;

    --Delete all sections
    delete from UM_SECTION where ins_id = p_ins_id;

    --Delete the instructor
    delete from UM_INSTRUCTOR where ins_id = p_ins_id;
END;

-- 5) Check student information
CREATE OR REPLACE PROCEDURE UM_PR_STUDENT_INFO(p_stu_id char)
IS
    v_info UM_STUDENT%ROWTYPE;
BEGIN
    select * into v_info from UM_STUDENT where stu_id = p_stu_id;
    dbms_output.put_line('STUDENT WITH ID = ' || p_stu_id || ' INFORMATION: ');
    dbms_output.put_line('NAME: '           || v_info.stu_name);
    dbms_output.put_line('GENDER: '         || v_info.gender);
    dbms_output.put_line('PHONE NUMBER: '   || v_info.phone_number);
    dbms_output.put_line('EMAIL: '          || v_info.stu_email);
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20028, 'STUDENT NOT FOUND IN DATABASE');
END;

-- 6) Check instructor infromation
CREATE OR REPLACE PROCEDURE UM_PR_INSTRUCTOR_INFO(p_ins_id char)
IS
    v_info UM_INSTRUCTOR%ROWTYPE;
    v_dept_name UM_DEPARTMENT.dept_name%TYPE;
    CURSOR c_course_ids IS (select distinct crs_id from UM_SECTION where ins_id = p_ins_id);
    v_flag BOOLEAN DEFAULT FALSE;
BEGIN
    select * into v_info from UM_INSTRUCTOR where ins_id = p_ins_id;
    select dept_name into v_dept_name from UM_DEPARTMENT where dept_id = v_info.dept_id;
    dbms_output.put_line('INSTRUCTOR WITH ID = ' || p_ins_id || ' INFORMATION: ');
    dbms_output.put_line('NAME: '           || v_info.ins_name);
    dbms_output.put_line('EMAIL: '          || v_info.ins_email);
    dbms_output.put_line('DEPARTMENT: '     || v_dept_name);
    dbms_output.put('COURSE(S) BEING TAUGHT: ');
    FOR i in c_course_ids
    LOOP
        v_flag := TRUE;
        dbms_output.put(i.crs_id || ' || ');
    END LOOP;
    
    IF NOT v_flag THEN
        dbms_output.put_line('NO COURSE FOUND');
    ELSE
        dbms_output.new_line; 
    END IF;
EXCEPTION
    WHEN no_data_found THEN
        raise_application_error(-20023, 'INSTRUCTOR NOT FOUND IN DATABASE');
END;

-- 7) Return total credits of a student
CREATE OR REPLACE FUNCTION UM_FN_TOTAL_CREDITS(p_stu_id char)
RETURN INT
IS
    v_total_credits INT DEFAULT 0;
BEGIN
    select sum(credits) into v_total_credits from 
        (select distinct(en.sec_id), credits
        from UM_ENROLLMENT en join UM_SECTION sec on en.sec_id = sec.sec_id
                            join UM_COURSE crs on sec.crs_id = crs.crs_id
        where stu_id = p_stu_id);
    IF v_total_credits IS NULL THEN RETURN 0;
    END IF;
    RETURN v_total_credits;
END;

-- 8) Return current GPA of a student (4.0 Scale)
CREATE OR REPLACE FUNCTION UM_FN_GPA_STUDENT(p_stu_id char) 
RETURN NUMBER
IS
   v_gpa number(4,2) DEFAULT 0.0;
   v_credit INT;
   v_total_credits INT;
   CURSOR c_sections IS ( select sec_id, max(grade) as m_grade from UM_ENROLLMENT where stu_id = p_stu_id group by sec_id);
   e_student_not_found EXCEPTION;
BEGIN
    v_total_credits := UM_FN_TOTAL_CREDITS(p_stu_id);
    IF v_total_credits = 0 THEN
        RAISE e_student_not_found;
    END IF;
    FOR each_section in c_sections
    LOOP
        select credits into v_credit 
            from UM_SECTION sec join UM_COURSE crs on sec.crs_id = crs.crs_id
            where sec.sec_id = each_section.sec_id;
        v_gpa := v_gpa + each_section.m_grade * v_credit;
    END LOOP;
    v_gpa := v_gpa / v_total_credits;

    RETURN v_gpa * 4 / 10;
EXCEPTION 
    WHEN e_student_not_found THEN
        raise_application_error(-20036, 'THIS STUDENT HAS NOT ENROLLED ANY COURSE');
END;

-- 9) Return rank of a student
CREATE OR REPLACE FUNCTION UM_FN_RANK_STUDENT(p_stu_id char) 
RETURN VARCHAR2
IS
    v_gpa number(4,2);
BEGIN
    v_gpa := UM_FN_GPA_STUDENT(p_stu_id);
    IF v_gpa >= 3.6     THEN    RETURN 'Xuat sac';
    ELSIF v_gpa >= 3.2  THEN    RETURN 'Gioi';
    ELSIF v_gpa >= 2.5  THEN    RETURN 'Kha';
    ELSIF v_gpa >= 2.0  THEN    RETURN 'Trung binh';
    ELSIF v_gpa >= 1.0  THEN    RETURN 'Yeu';
    ELSE                        RETURN 'Kem';
    END IF;
END;

-- 10) Change room of a given section 
CREATE OR REPLACE PROCEDURE UM_PR_CHANGE_ROOM(p_sec_id varchar2, p_new_room varchar2)
IS
BEGIN
    update UM_SECTION set room = p_new_room where sec_id = p_sec_id;
END;

----------------------------------SOME TRIGGERS----------------------------------------
-- 1) Recording the update of student's grade.
CREATE OR REPLACE TRIGGER UM_TR_UPD_GRADE_ENROLLMENT
    AFTER UPDATE OF grade ON UM_ENROLLMENT
    FOR EACH ROW
DECLARE
BEGIN
    insert into UM_GRADE_ENROLLMENT_LOG values(user, sysdate, :old.stu_id, :old.sec_id, :old.academic_year, :old.semester, :old.grade, :new.grade);
END;

-- 2) Check changing room update: 
--      If the new room is the same as the old one, then raise raise_application_error
--      Else write changes to log
CREATE OR REPLACE TRIGGER UM_TR_UPD_ROOM_SECTION
    BEFORE UPDATE OF room ON UM_SECTION
    FOR EACH ROW
DECLARE
BEGIN
    IF :old.room = :new.room THEN
        raise_application_error(-20530, 'THIS SECTION HAS ALREADY ASSIGNED TO THE ROOM ' || :old.room);
    ELSE
        insert into UM_ROOM_SECTION_LOG values(user, sysdate, :old.sec_id, :old.room, :new.room);
    END IF;
END;

-- 3) Recording deleted sections
CREATE OR REPLACE TRIGGER UM_TR_DEL_SECTION
    BEFORE DELETE ON UM_SECTION
    FOR EACH ROW
DECLARE
BEGIN 
    insert into UM_DEL_SECTION_LOG values(user, sysdate, :old.sec_id, :old.crs_id, :old.ins_id, :old.room);
END;    

----------------------------------LIST OF USERS----------------------------------------
/*
admin
manager
employee: employee1(students' information management), employee2(Enrollment management), employee3(instructors' information management), ...
*/
--ADMIN
CREATE USER admin IDENTIFIED BY "admin"
DEFAULT TABLESPACE users
QUOTA 2M on users;
-------System privileges
GRANT   create table,
        create trigger,
        create session,      
        create procedure 
TO ADMIN;

-------Object privileges
GRANT alter, select on UM_COURSE TO admin;
GRANT alter, select on UM_DEPARTMENT TO admin;
GRANT alter, select on UM_ENROLLMENT TO admin;
GRANT alter, select on UM_INSTRUCTOR TO admin;
GRANT alter, select on UM_SECTION TO admin;
GRANT alter, select on UM_STUDENT TO admin;
GRANT select on UM_DEL_SECTION_LOG TO admin;
GRANT select on UM_ROOM_SECTION_LOG TO admin;
GRANT select on UM_GRADE_ENROLLMENT_LOG TO admin;

GRANT execute on UM_FN_GPA_STUDENT TO admin;
GRANT execute on UM_FN_RANK_STUDENT TO admin;
GRANT execute on UM_FN_TOTAL_CREDITS TO admin;
GRANT execute on UM_PR_ADD_INSTRUCTOR TO admin;
GRANT execute on UM_PR_ADD_STUDENT TO admin;
GRANT execute on UM_PR_DEL_INSTRUCTOR TO admin;
GRANT execute on UM_PR_DEL_STUDENT TO admin;
GRANT execute on UM_PR_INSTRUCTOR_INFO TO admin;
GRANT execute on UM_PR_STUDENT_INFO TO admin;
GRANT execute on UM_PR_CHANGE_ROOM TO admin;

--MANAGER
CREATE USER manager IDENTIFIED BY "manager"
DEFAULT TABLESPACE users
QUOTA 2M on users;
-------System privileges
GRANT   
        create table,   
        create trigger,         
        create procedure,
        create role,
        create session
TO manager
WITH ADMIN OPTION;

GRANT 
        alter session, restricted session,
        create user, drop user, alter user, 
        select any table 
TO manager;

GRANT create role TO manager WITH GRANT OPTION;
-------Object privileges
GRANT alter, delete, insert, select, update on UM_COURSE TO manager WITH GRANT OPTION;
GRANT alter, delete, insert, select, update on UM_DEPARTMENT TO manager WITH GRANT OPTION;
GRANT alter, delete, insert, select, update on UM_ENROLLMENT TO manager WITH GRANT OPTION;
GRANT alter, delete, insert, select, update on UM_INSTRUCTOR TO manager WITH GRANT OPTION;
GRANT alter, delete, insert, select, update on UM_SECTION TO manager WITH GRANT OPTION;
GRANT alter, delete, insert, select, update on UM_STUDENT TO manager WITH GRANT OPTION;

GRANT execute on UM_FN_GPA_STUDENT TO manager WITH GRANT OPTION;
GRANT execute on UM_FN_RANK_STUDENT TO manager WITH GRANT OPTION;
GRANT execute on UM_FN_TOTAL_CREDITS TO manager WITH GRANT OPTION;
GRANT execute on UM_PR_ADD_INSTRUCTOR TO manager WITH GRANT OPTION;
GRANT execute on UM_PR_ADD_STUDENT TO manager WITH GRANT OPTION;
GRANT execute on UM_PR_DEL_INSTRUCTOR TO manager WITH GRANT OPTION;
GRANT execute on UM_PR_DEL_STUDENT TO manager WITH GRANT OPTION;
GRANT execute on UM_PR_INSTRUCTOR_INFO TO manager WITH GRANT OPTION;
GRANT execute on UM_PR_STUDENT_INFO TO manager WITH GRANT OPTION;
GRANT execute on UM_PR_CHANGE_ROOM TO manager WITH GRANT OPTION;


--EMPLOYEE
drop role role_employee;
CREATE ROLE role_employee;
-------System privileges
GRANT 
    create table,
    create session,
    create trigger
TO role_employee; 
-------Object privileges (depends on each employee)
--EMPLOYEE EXAMPLES
--employee1 (students' information management)
    CREATE USER employee1 identified by "employee1"
    DEFAULT TABLESPACE users
    QUOTA 2M ON users;

    -------System privileges
    GRANT role_employee TO employee1;

    -------Object privileges
    GRANT select on UM_STUDENT TO employee1;

    GRANT execute on UM_PR_STUDENT_INFO TO employee1;
    GRANT execute on UM_PR_ADD_STUDENT TO employee1;
    GRANT execute on UM_PR_DEL_STUDENT TO employee1;
    
--employee2 (Enrollment management)
    CREATE USER employee2 identified by "employee2"
    DEFAULT TABLESPACE users
    QUOTA 2M ON users;

    -------System privileges
    GRANT role_employee TO employee2;

    -------Object privileges
    GRANT select on UM_ENROLLMENT TO employee2;
    GRANT select on UM_SECTION TO employee2;
    
    GRANT execute on UM_FN_GPA_STUDENT TO employee2;
    GRANT execute on UM_FN_RANK_STUDENT TO employee2;
    GRANT execute on UM_FN_TOTAL_CREDITS TO employee2;

--employee3(instructors' information management)
    CREATE USER employee3 identified by "employee3"
    DEFAULT TABLESPACE users
    QUOTA 2M ON users;

    -------System privileges
    GRANT role_employee TO employee3;

    -------Object privileges
    GRANT select on UM_INSTRUCTOR TO employee3;
    GRANT select on UM_DEPARTMENT TO employee3;

    GRANT execute on UM_PR_ADD_INSTRUCTOR TO employee3;
    GRANT execute on UM_PR_DEL_INSTRUCTOR TO employee3;
    GRANT execute on UM_PR_INSTRUCTOR_INFO TO employee3;

