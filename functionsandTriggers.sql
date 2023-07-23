-- table function for getting available slots 
 alter function udfGetAllAvailableSlots(@PId varchar(255),@DocId varchar(7),@AppointmentDate date)
    returns table
    as
    return
        select @DocId as DoctorId ,@PId as PatientId, @AppointmentDate as AppointmentDate,StartTime ,EndTime from Slots where slots.StartTime  not in (select StartTime from Appointment where (DoctorID  =@DocId and AppointmentDate=@AppointmentDate) or (PatientId=@PId and AppointmentDate=@AppointmentDate)  );


-- trigger for deleting appointments and patient medical history associated with the deleted patient
create trigger trg_onDelete_Patient
ON Patient
Instead of DELETE
AS 
begin
set NOCOUNT ON;
Declare @pid varchar(255);
Select @pid = PatientId from deleted;
if( (select Count(*) from Appointment where PatientId=@pid)>0)
delete from Appointment where PatientId=@pid
if( (select Count(*) from PatientMedicalHistory where PatientId=@pid)>0)
Delete from PatientMedicalHistory where PatientId=@pid;
Delete from Patient where PatientId = @pid;
end


