--create database Barwon_for_Health_system
--create schema mysystem
--go
create table mysystem.doctors(
doctor_id int primary key identity,
doctor_name varchar(255) not null,
doctor_address varchar(255) not null,
doctor_phone varchar(255) not null,
doctor_email varchar(255) not null,
years_experience  int not null,
doctor_specialty varchar(255) not null 
)


create table mysystem.patients(
patient_id int primary key identity,
patient_name varchar(255) not null,
patient_address varchar(255) not null,
patient_phone varchar(255) not null,
patient_email varchar(255) not null,
patient_age  int not null,
medicare_card_num varchar(255) ,
doctor_id int ,
constraint fk_doctor foreign key(doctor_id) references mysystem.doctors (doctor_id)
)

create table mysystem.patient_servictions(
patient_id int ,
doctor_id int ,
 primary key (patient_id , doctor_id),
constraint fk_doctor_service foreign key(doctor_id) references mysystem.doctors (doctor_id)
on update cascade
on delete  NO ACTION,
constraint fk_patient foreign key(patient_id) references mysystem.patients (patient_id)
on update cascade
on delete  NO ACTION
)


create table mysystem.companies(
company_id int primary key identity,
company_name varchar(255) not null,
company_address varchar(255) not null,
company_phone varchar(255) not null,
company_email varchar(255) not null)

create table mysystem.drugs(
trade_name int primary key identity,
drug_name varchar(100) not null,
strength varchar(50) not null,
company_id int,
constraint fk_company foreign key(company_id) references mysystem.companies (company_id)
on update cascade
on delete  cascade,
)


create table mysystem.Prescriptions(
Prescription_id int primary key identity,
Prescription_date date not null,
quantity int,
doctor_id int,
patient_id int ,
constraint fk_doctor_Prescription foreign key(doctor_id) references mysystem.doctors (doctor_id)
on update no action
on delete  no action,
constraint fk_patient_Prescription foreign key(patient_id) references mysystem.patients (patient_id)
on update no action
on delete  no action
)

create table mysystem.Prescription_details(
trade_name int,
Prescription_id int,
constraint fk_drug_Prescription foreign key(trade_name) references mysystem.drugs (trade_name)
on update no action
on delete  no action,
constraint fk_Prescription foreign key(Prescription_id) references mysystem.Prescriptions (Prescription_id)
on update no action
on delete  no action
)




--•	SELECT: Retrieve all columns from the Doctor table.
select *
from mysystem.doctors


--•	ORDER BY: List patients in the Patient table in ascending order of their ages.

select *
from mysystem.patients
order by patient_age asc

--•	OFFSET FETCH: Retrieve the first 10 patients from the Patient table, starting from the 5th record.
select *
from mysystem.patients
order by patient_id
offset 4 rows
fetch next 10 rows only

--•	SELECT TOP: Retrieve the top 5 doctors from the Doctor table.
select top 5 *
from mysystem.doctors

--•	SELECT DISTINCT: Get a list of unique address from the Patient table.
select distinct  patient_address
from mysystem.patients

--•	WHERE: Retrieve patients from the Patient table who are aged 25
select *
from mysystem.patients
where patient_age > 25

--•	NULL: Retrieve patients from the Patient table whose email is not provided.
select *
from mysystem.patients
where patient_address is  null

--•	AND: Retrieve doctors from the Doctor table who have experience greater than 5 years and specialize in 'Cardiology'.
select *
from mysystem.doctors
where years_experience > 5 and doctor_specialty like 'Cardiology'

--•	IN: Retrieve doctors from the Doctor table whose speciality is either 'Dermatology' or 'Oncology'.
select *
from mysystem.doctors
where  doctor_specialty in('Dermatology','Oncology' ) 

--•	BETWEEN: Retrieve patients from the Patient table whose ages are between 18 and 30.
select *
from mysystem.patients
where  patient_age between 18 and 30  

--•	LIKE: Retrieve doctors from the Doctor table whose names start with 'Dr.'.
select *
from mysystem.doctors
where  doctor_name like 'Dr%'

--•	Column & Table Aliases: Select the name and email of doctors, aliasing them as 'DoctorName' and 'DoctorEmail'.
select doctor_name as 'DoctorName' , doctor_email 'DoctorEmail'
from mysystem.doctors

--•	Joins: Retrieve all prescriptions with corresponding patient names
select pr.Prescription_id , pr.Prescription_date , p.patient_id , p.patient_name
from mysystem.Prescriptions pr join mysystem.patients p
on pr.patient_id = p.patient_id

--•	GROUP BY: Retrieve the count of patients grouped by their cities.
select patient_address
from mysystem.patients
group by patient_address

--•	HAVING: Retrieve cities with more than 3 patients
select patient_address
from mysystem.patients
group by patient_address
having count(patient_id) > 3

--•	UNION: Retrieve a combined list of doctors and patients. (Search)

select doctor_id , doctor_name 
from mysystem.doctors
union 
select patient_id , patient_name
from mysystem.patients

--•	Common Table Expression (CTE): Retrieve patients along with their doctors using a CTE.

with patients_along_doctors(patientid ,patientname, doctorid , doctorname ) as(
select p.patient_id , p.patient_name , dr.doctor_id , dr.doctor_name
from mysystem.patient_servictions s join mysystem.patients p
on s.patient_id=p.patient_id
join mysystem.doctors dr
on dr.doctor_id=s.doctor_id)

select *
from patients_along_doctors

--•	INSERT: Insert a new doctor into the Doctor table
insert into mysystem.doctors(doctor_address , doctor_email , doctor_name ,doctor_phone ,doctor_specialty ,years_experience)
values('5 street , fayoum' , 'eng.mohamed@gmail.com' , 'mohamed ahmed', '0101405618' , 'cardiology' , '4')

--•	INSERT Multiple Rows: Insert multiple patients into the Patient table.
insert into mysystem.patients(patients_address , patients_email , patients_name ,patients_phone ,patient_age )
values('5 street , fayoum' , 'eng.mohamed@gmail.com' , 'mohamed ahmed', '0101405618' ,  '40') ,
('10 street , fayoum' , 'eng.ahmed@gmail.com' , 'ahmed alaa', '0101555618' ,  '45')

--•	UPDATE: Update the phone number of a doctor.
update mysystem.doctors
set doctor_phone='01004582198'
where doctor_id=1

--•	UPDATE JOIN: Update the city of patients who have a prescription from a specific doctor.
update mysystem.patients
set patient_address = '15 north cairo'
from mysystem.patients p
join mysystem.Prescriptions pr 
on pr.patient_id = p.patient_id
join mysystem.doctors dr 
on dr.doctor_id=pr.doctor_id
where pr.doctor_id=1

--•	DELETE: Delete a patient from the Patient table.
delete from mysystem.patients
where patient_id=1

--•	Transaction: Insert a new doctor and a patient, ensuring both operations succeed or fail together.
begin transaction 

insert into mysystem.doctors(doctor_address , doctor_email , doctor_name ,doctor_phone ,doctor_specialty ,years_experience)
values('5 street , fayoum' , 'eng.mohamed@gmail.com' , 'mohamed ahmed', '0101405618' , 'cardiology' , '4')

insert into mysystem.patients(patients_address , patients_email , patients_name ,patients_phone ,patient_age )
values('5 street , fayoum' , 'eng.mohamed@gmail.com' , 'mohamed ahmed', '0101405618' ,  '40')

rollback

--•	View: Create a view that combines patient and doctor information for easy access.
create view  mysystem.patient_doctor
as 
select p.patient_id , p.patient_name,dr.doctor_id , dr.doctor_name
from
mysystem.patients p join mysystem.doctors dr
on p.doctor_id=dr.doctor_id


--•	Index: Create an index on the 'phone' column of the Patient table to improve search performance.

CREATE INDEX idxxx_patient_phone
ON mysystem.patients (patient_phone);

--•	Backup: Perform a backup of the entire database to ensure data safety.
BACKUP DATABASE Barwon_for_Health_system
TO DISK = 'C:\Program Files\backup_sql.bak'
WITH FORMAT,
     MEDIANAME = 'BarwonBackupMedia',
     NAME = 'Full Backup of Barwon_for_Health_system';






