update RM00101 set USERDEF2=NewCUSTNMBR  from RM00101 a inner join (select rtrim(PrimaryKeyField1) CUSTNMBR,rtrim(NewPKField1) NewCUSTNMBR from DYNAMICS..ottDataMapping where MappingType in (1,2,3) 
and (PrimaryKeyField1<>NewPKField1) /*Do not attempt to change ID's that don't need to change*/
and INTERID=db_name()
and DataTypeID='CUST') b 
on a.USERDEF2=b.CUSTNMBR