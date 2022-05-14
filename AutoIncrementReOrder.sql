drop table customers  purge;
create table customers(id number(30),name varchar2(37));
alter table customers add  constraint pk_name_customers primary key(name);

create or replace function autoincrreorder
                                         return number  is
                          begin
 
                                   declare
                                               counter number(30);
                                     table_does_not_exist exception;
                                    compile_error exception;
                                     PRAGMA  EXCEPTION_INIT(compile_error, -06550);
                                   PRAGMA EXCEPTION_INIT(table_does_not_exist, -942);
                                 begin
                                   dbms_output.put_line('begin starts');
                                    EXECUTE IMMEDIATE 'select count(*) from customers' into counter;
                                       counter:=counter+1;
                                       dbms_output.put_line(counter);
                                        if (counter>1)then
                                                 dbms_output.put_line('If loop Executing');
                    
                                                        EXECUTE IMMEDIATE q'{
                                                        declare
                                                           i number(37):=0;
                                                         begin
                                                           for x in  (select rowid,customers.* from customers) loop
                                                           dbms_output.put_line(x.rowid||'--'||x.id||'--'||x.name);
                                                            i:=i+1;
                                                           dbms_output.put_line(i);
                                                           update customers set id=i where rowid=x.rowid;
                                                           end loop;
                                                         end;}';
                                        end if;
                                   return counter;
                                  EXCEPTION
                                       
                                        WHEN table_does_not_exist then
                                        dbms_output.put_line('table dose not exists');
                                         return 1;
                                         WHEN NO_DATA_FOUND THEN
                                          dbms_output.put_line('No data found');
                                          return 1;
                               end;
         /*call the function after deleting the any rows in between the records,by calling the function it will rearrange the records in table by update statement */
                 end;
                
/

insert into customers values(autoincrreorder(),’prudhvi’);
insert into customers values(autoincrreorder(),’Ram’);
insert into customers values(autoincrreorder(),’Vijay’);
insert into customers values(autoincrreorder(),’vamsi’);
insert into customers values(autoincrreorder(),’sreekanth’);
insert into customers values(autoincrreorder(),’Ravinder’);
insert into customers values(autoincrreorder(),’sahiti’);
insert into customers values(autoincrreorder(),’Lakshmi’);
commit;
delete from customers where id=3;
commit;
variable n1 number;
exec :n1:=autoincrreorder();
