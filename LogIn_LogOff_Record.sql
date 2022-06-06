********************************************DATABASE LOGON LOGOFF TRIGGER***************************************************
/*you have to use in system admin account*/
drop table user_login_logoff;
create table user_login_logoff(username varchar2(10),system varchar2(20),logindatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

create or replace trigger logon
after logon on database
begin
insert into user_login_logoff  values(user,'LOGGED ON',DEFAULT);
commit;
end;
/
create or replace trigger logoff
before logoff on database
begin
insert into user_login_logoff  values(user,'LOGGED OFF',DEFAULT);
commit;
end;
/
*******************************************SCHEMA LOGON LOGOFF TRIGGER******************************************************
/*you have to use  in user account*/
DROP TABLE LOGON_LOGOFF;
CREATE TABLE LOGON_LOGFF(USERNAME VARCHAR2(30),SYSTEM VARCHAR2(20),LOGIN_LOFOFF_DATETIME TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

CREATE OR REPLACE TRIGGER log_off_audit
BEFORE LOGOFF ON SCHEMA/*you can use user.schema or schema*/
BEGIN
INSERT INTO LOGON_LOGOFF VALUES(user,'LOGGED OFF',SYSDATE);
COMMIT;
END;
/
CREATE OR REPLACE TRIGGER log_on_audit
AFTER LOGON ON SCHEMA/*you can use user.schema or schema*/
BEGIN
INSERT INTO LOGON_LOGOFF VALUES(user,'LOGGED ON',SYSDATE);
COMMIT;
END;
/
