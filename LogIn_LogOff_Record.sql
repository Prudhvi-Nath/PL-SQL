drop table user_login_logoff;
create table user_login_logoff(username varchar2(10),system varchar2(20),logindatetime TIMESTAMP DEFAULT CURRENT_TIMESTAMP);

create or replace trigger logoff
before logoff on database
begin
dbms_output.put_line('LOGOFF TRIGGER ACTIVATED');
insert into user_login_logoff  values(user,'LOGGED OFF',DEFAULT);
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
