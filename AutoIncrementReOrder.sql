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
                                                           for x in  (select * from customers) loop
                                                           dbms_output.put_line(x.id||'--'||x.name);
                                                            i:=i+1;
                                                           dbms_output.put_line(i);
                                                           update customers set id=i where name=x.name;
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
                 end;
/
insert into customers values(autoincrreorder(),’prudhvi’);
