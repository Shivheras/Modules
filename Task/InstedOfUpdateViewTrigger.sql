CREATE TABLE tblEmployee1  
(  
 Id int Primary Key,  
 Name nvarchar(30),  
 Gender nvarchar(10),  
 DepartmentId int  
)

CREATE TABLE tblDepartment1  
(  
 DeptId int Primary Key,  
 DeptName nvarchar(20)  
)


Insert into tblDepartment1 values (1,'Blog')  
Insert into tblDepartment1 values (2,'Article')  
Insert into tblDepartment1 values (3,'Resource')  
Insert into tblDepartment1 values (4,'Book') 
Insert into tblEmployee1 values (1,'Satya1', 'Male', 3)  
Insert into tblEmployee1 values (2,'Satya2', 'Male', 2)  
Insert into tblEmployee1 values (3,'Satya3', 'Female', 1)  
Insert into tblEmployee1 values (4,'Satya4', 'Male', 4)  
Insert into tblEmployee1 values (5,'Satya5', 'Female', 1)  
Insert into tblEmployee1 values (6,'Satya6', 'Male', 3) 


select * from tblDepartment1  
  
select * from tblEmployee1 


Create view ViewEmployeeDetails1  
as  
Select Id, Name, Gender, DeptName  
from tblEmployee1  
join tblDepartment1  
on tblEmployee1.DepartmentId = tblDepartment1.DeptId 


Create Trigger tr_ViewEmployeeDetails1_InsteadOfUpdate  
on ViewEmployeeDetails1  
instead of update  
as  
Begin  
 if(Update(Id))  
 Begin  
  Raiserror('Id cannot be changed', 16, 1)  
  Return  
 End  
   
 if(Update(DeptName))   
 Begin  
  Declare @DeptId int  
  
  Select @DeptId = DeptId  
  from tblDepartment1  
  join inserted  
  on inserted.DeptName = tblDepartment1.DeptName  
    
  if(@DeptId is NULL )  
  Begin  
   Raiserror('Invalid Department Name', 16, 1)  
   Return  
  End  
    
  Update tblEmployee1 set DepartmentId = @DeptId  
  from inserted  
  join tblEmployee1  
  on tblEmployee1.Id = inserted.id  
 End  
   
 if(Update(Gender))  
 Begin  
  Update tblEmployee1 set Gender = inserted.Gender  
  from inserted  
  join tblEmployee1  
  on tblEmployee1.Id = inserted.id  
 End  
   
 if(Update(Name))  
 Begin  
  Update tblEmployee1 set Name = inserted.Name  
  from inserted  
  join tblEmployee1  
  on tblEmployee1.Id = inserted.id  
 End  
End 


Select * from ViewEmployeeDetails1

Update ViewEmployeeDetails1   
set Name = 'Satya11'   
where Id = 1