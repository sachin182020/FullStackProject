create database OPD;
use OPD;




	
	--Creating a helper table for getting available slots .	
	create table Slots(SlotId int Primary Key identity(1,1) ,StartTime time(0),EndTime time(0));
Begin
	DECLARE @st time(0) ='09:00:00';
	declare @et time(0) ='9:30:00';
	declare @slot int =1;
	while @slot<17

	begin
		
		Insert into Slots(StartTime ,EndTime) values(@st,@et);
		set @st=DATEADD(minute,30,@st);
		set @et =DATEADD(minute,30,@et);
		set @slot +=1;
		if(@st='13:00:00')
			begin
				set @st='14:00:00';
				set @et ='14:30:00';
			
			END
	end
	end
	select * from Slots;
	
	




/*
create trigger ensureAppointmentDoesNotClash on Appointment instead of Insert 
as
begin
set nocount on;
declare @currentDate date ;
declare @startTime time(0);
declare @docId int;

select @currentDate = i.AppointmentDate ,@startTime = i.StartTime ,@docId= i.DoctorId from inserted i;
if(dbo.udfIsSlotAvailable(@docId,@currentDate,@startTime)=1)
	insert into Appointment select * from inserted
else
RAISERROR( 'slot is already booked', 16, 1) 
end

create Trigger ensureNewAppointmentDoesNotClash on Appointment  after insert
as
begin
declare @currentDate date ;
declare @startTime time(0);
declare @docId int;
select * from inserted;
select @currentDate = i.AppointmentDate ,@startTime = i.StartTime ,@docId= i.DoctorID from inserted i;

if( dbo.udfIsSlotAvailable(@docId,@currentDate,@startTime)=0)
	Rollback transaction 
end
*/










create table Doctor(DId int identity(1,1) ,DoctorId as 'D'+right('000000'+cast(DId as varchar(10)),6) PERSISTED, FirstName varchar(20) not null, LastName varchar(20) not null, Address text not null, Email varchar(50) not null, PhoneNumber varchar(15) not null, City varchar(30) not null, State varchar(30) not null, Gender varchar(20), DOB date not null, SSN char(11) not null unique, Speciality varchar(100) constraint PK_Doctor Primary Key(DoctorId));

	select * from doctor;

Create Table Appointment(AId int identity(1,1), AppointmentId as 'A'+right('00000000'+cast(AId as varchar(10)),8) PERSISTED,PatientId varchar(255)  not null,AffectedOrgan varchar(20) not null, DoctorId varchar(7)  not null, DoctorName varchar(50)  not null, AppointmentDate date not null, StartTime time(0) not null,EndTime time(0) not null, BookingStatus Bit default 1,    
    constraint PK_AppointmentId Primary Key(AppointmentId), 
    constraint FK_Appointment_Patient Foreign Key(PatientId) references Patient(PatientId), 
    constraint FK_Appointment_Doctor foreign key(DoctorId) references Doctor(DoctorId),
   
    constraint UNQ_DocID_ApDate_AppSlot UNIQUE(DoctorID,AppointmentDate,StartTime)
    );

	select * from Doctor;

	select * from Slots;









select * from Patient;
select * from Appointment;
select * from PatientMedicalHistory;