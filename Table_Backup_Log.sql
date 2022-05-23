Drop table emp_backup purge;
Drop table emp;

set pagesize 300
set lines 300
set num 4

set serveroutput on

CREATE TABLE EMP
       (EMPNO NUMBER(4) NOT NULL,
        ENAME VARCHAR2(10),
        JOB VARCHAR2(9),
        MGR NUMBER(4),
        HIREDATE DATE,
        SAL NUMBER(7, 2),
        COMM NUMBER(7, 2),
        DEPTNO NUMBER(2));

INSERT INTO EMP VALUES
        (7369, 'SMITH',  'CLERK',     7902,
        TO_DATE('17-DEC-1980', 'DD-MON-YYYY'),  800, NULL, 20);
INSERT INTO EMP VALUES
        (7499, 'ALLEN',  'SALESMAN',  7698,
        TO_DATE('20-FEB-1981', 'DD-MON-YYYY'), 1600,  300, 30);
INSERT INTO EMP VALUES
        (7521, 'WARD',   'SALESMAN',  7698,
        TO_DATE('22-FEB-1981', 'DD-MON-YYYY'), 1250,  500, 30);
INSERT INTO EMP VALUES
        (7566, 'JONES',  'MANAGER',   7839,
        TO_DATE('2-APR-1981', 'DD-MON-YYYY'),  2975, NULL, 20);
INSERT INTO EMP VALUES
        (7654, 'MARTIN', 'SALESMAN',  7698,
        TO_DATE('28-SEP-1981', 'DD-MON-YYYY'), 1250, 1400, 30);
INSERT INTO EMP VALUES
        (7698, 'BLAKE',  'MANAGER',   7839,
        TO_DATE('1-MAY-1981', 'DD-MON-YYYY'),  2850, NULL, 30);
INSERT INTO EMP VALUES
        (7782, 'CLARK',  'MANAGER',   7839,
        TO_DATE('9-JUN-1981', 'DD-MON-YYYY'),  2450, NULL, 10);
INSERT INTO EMP VALUES
        (7788, 'SCOTT',  'ANALYST',   7566,
        TO_DATE('09-DEC-1982', 'DD-MON-YYYY'), 3000, NULL, 20);
INSERT INTO EMP VALUES
        (7839, 'KING',   'PRESIDENT', NULL,
        TO_DATE('17-NOV-1981', 'DD-MON-YYYY'), 5000, NULL, 10);
INSERT INTO EMP VALUES
        (7844, 'TURNER', 'SALESMAN',  7698,
        TO_DATE('8-SEP-1981', 'DD-MON-YYYY'),  1500,    0, 30);
INSERT INTO EMP VALUES
        (7876, 'ADAMS',  'CLERK',     7788,
        TO_DATE('12-JAN-1983', 'DD-MON-YYYY'), 1100, NULL, 20);
INSERT INTO EMP VALUES
        (7900, 'JAMES',  'CLERK',     7698,
        TO_DATE('3-DEC-1981', 'DD-MON-YYYY'),   950, NULL, 30);
INSERT INTO EMP VALUES
        (7902, 'FORD',   'ANALYST',   7566,
        TO_DATE('3-DEC-1981', 'DD-MON-YYYY'),  3000, NULL, 20);
INSERT INTO EMP VALUES
        (7934, 'MILLER', 'CLERK',     7782,
        TO_DATE('23-JAN-1982', 'DD-MON-YYYY'), 1300, NULL, 10);

COMMIT;
        
create table emp_backup(empno_old number(4),empno_new number(4),ename_old varchar2(10),ename_new varchar2(10),job_old varchar2(9),job_new varchar2(9),mgr_old number(4),mgr_new number(4),hiredate_old date,hiredate_new date,sal_old number(7,2),sal_new number(7,2),comm_old number(7,2),comm_new number(7,2),deptno_old number(2),deptno_new number(2),updated_time TIMESTAMP DEFAULT SYSTIMESTAMP,username varchar2(20));

create or replace trigger emp_log
before INSERT OR UPDATE OR DELETE on emp
for each row
begin
IF INSERTING then
insert into emp_backup values(:old.empno,:new.empno,:old.ename,:new.ename,:old.job,:new.job,:old.mgr,:new.mgr,:old.hiredate,:new.hiredate,:old.sal,:new.sal,:old.comm,:new.comm,:old.deptno,:new.deptno,DEFAULT,user);
dbms_output.put_line('Inserting the Record:'||'---'||:new.empno||'--'||:new.ename||'--'||:new.job||'--'||:new.mgr||'--'||:new.hiredate||'--'||:new.sal||'--'||:new.comm||'--'||:new.deptno);
ELSIF UPDATING THEN
insert into emp_backup values(:old.empno,:new.empno,:old.ename,:new.ename,:old.job,:new.job,:old.mgr,:new.mgr,:old.hiredate,:new.hiredate,:old.sal,:new.sal,:old.comm,:new.comm,:old.deptno,:new.deptno,DEFAULT,user);
dbms_output.put_line('Inserting the Record:'||'---'||:new.empno||'--'||:new.ename||'--'||:new.job||'--'||:new.mgr||'--'||:new.hiredate||'--'||:new.sal||'--'||:new.comm||'--'||:new.deptno);
ELSIF DELETING THEN
insert into emp_backup values(:old.empno,:new.empno,:old.ename,:new.ename,:old.job,:new.job,:old.mgr,:new.mgr,:old.hiredate,:new.hiredate,:old.sal,:new.sal,:old.comm,:new.comm,:old.deptno,:new.deptno,DEFAULT,user);
dbms_output.put_line('Deleting the Record:'||'---'||:new.empno||'--'||:new.ename||'--'||:new.job||'--'||:new.mgr||'--'||:new.hiredate||'--'||:new.sal||'--'||:new.comm||'--'||:new.deptno);
ELSE
dbms_output.put_line('Invalid Operation Done');
end if;
end;
/

create or replace procedure empbackup is
begin
  declare
                                  table_does_not_exist exception;
                                    compile_error exception;
                                     PRAGMA  EXCEPTION_INIT(compile_error, -06550);
                                   PRAGMA EXCEPTION_INIT(table_does_not_exist, -00942);
   begin
    EXECUTE IMMEDIATE q'{
         declare
cursor cur_empbackup is select * from emp_backup;
         begin
            open cur_empbackup;
         for x in (select * from emp_backup) loop
             if (x.empno_old=x.empno_new and x.ename_old=x.ename_new and x.job_old=x.job_new and x.mgr_old=x.mgr_new and x.hiredate_old=x.hiredate_new and x.sal_old=x.sal_new and x
.comm_old=x.comm_new and x.deptno_old=x.deptno_new) then
             delete from emp_backup where (x.empno_new=x.empno_new and x.ename_old=x.ename_new and x.job_old=x.job_new and x.mgr_old=x.mgr_new and x.hiredate_old=x.hiredate_new and
 x.sal_old=x.sal_new and x.comm_old=x.comm_new and x.deptno_old=x.deptno_new);
             dbms_output.put_line(x.empno_old||'==='||x.empno_new);
           else
              if(x.empno_old=x.empno_new and (x.empno_old IS NOT NULL  and x.empno_new IS NOT NULL )) then
 dbms_output.put_line(x.empno_old||'==='||x.empno_new);
                  update emp_backup set empno_old=NULL,empno_new=NULL;
                  COMMIT;
                dbms_output.put_line('Updated for empno');
                 end if;
                 if(x.ename_old=x.ename_new and (x.ename_old IS NOT NULL  and x.ename_new IS NOT NULL )) then
 dbms_output.put_line(x.ename_old||'==='||x.ename_new);
                  update emp_backup set ename_old=NULL,ename_new=NULL;
            COMMIT;
                    dbms_output.put_line('Updated for ename');
                  end if;
                  if(x.job_old=x.job_new and (x.job_old IS NOT NULL  and x.job_new IS NOT NULL )) then
 dbms_output.put_line(x.job_old||'==='||x.job_new);
                              update emp_backup set job_old=NULL,job_new=NULL;
                             COMMIT;
                    dbms_output.put_line('Updated for job');
                  end if;
                            if(x.mgr_old=x.mgr_new and (x.mgr_old IS NOT NULL  and x.mgr_new IS NOT NULL )) then
                               dbms_output.put_line(x.mgr_old||'==='||x.mgr_new);
                                update emp_backup set mgr_old=NULL,mgr_new=NULL;
                          COMMIT;
                           dbms_output.put_line('Updated for mgr');
                              end if;
                                  if(x.hiredate_old=x.hiredate_new and (x.hiredate_old IS NOT NULL  and x.hiredate_new IS NOT NULL )) then
                dbms_output.put_line(x.hiredate_old||'==='||x.hiredate_new);
                                      update emp_backup set hiredate_old=NULL,hiredate_new=NULL;
                               COMMIT;
                               dbms_output.put_line('Updated for hiredate');
                                   end if;
                                      if(x.sal_old=x.sal_new and (x.sal_old IS NOT NULL and x.sal_new IS NOT null)) then
                 dbms_output.put_line(x.sal_old||'==='||x.sal_new);
                                           update emp_backup set sal_old=NULL,sal_new=NULL;
                                  COMMIT;
                                   dbms_output.put_line('Updated for sal');
                                       end if;
                                          if(x.comm_old=x.comm_new and (x.comm_old IS NOT NULL and x.comm_new IS NOT NULL )) then
                         dbms_output.put_line(x.comm_old||'==='||x.comm_new);
                                             update emp_backup set comm_old=NULL,comm_new=NULL;
                                     COMMIT;
                                       dbms_output.put_line('Updated for comm');
                                             end if;
                                                 if(x.deptno_old=x.deptno_new and (x.deptno_old IS NOT NULL and x.deptno_new IS NOT NULL))  then
                         dbms_output.put_line(x.deptno_old||'==='||x.deptno_new);
                                                      update emp_backup set deptno_old=NULL,deptno_new=NULL;
                                              COMMIT;
                                             dbms_output.put_line('Updated for deptno');
                                                    end if;
             dbms_output.put_line('No Duplicate Records');
             end if;
           end loop;
        close cur_empbackup;
       end;}';
                                 EXCEPTION
                                        WHEN table_does_not_exist then
                                        dbms_output.put_line('table dose not exists');
                                         WHEN NO_DATA_FOUND THEN
                                          dbms_output.put_line('No data found');
 end;
end;
/
update emp set sal=sal+100;
exec empbackup;
