use patientschurn;
select * from patient_churn_dataset;

select patientid from patient_churn_dataset;

alter table  patient_churn_dataset
rename column patientid to Patient_id;

alter table patient_churn_dataset add column churned_status varchar(20);

update patient_churn_dataset
set churned_status =case
when churned =1 then "Yes"
when churned = 0 then "No"
end;


/*1.Find the total number of churned patients.*/

select count(*) from patient_churn_dataset
where churned=1;

/*2.Find the total number of active (non-churned) patients*/
select count(*) from patient_churn_dataset
where churned=0;

/*3.Display the churn count by gender.*/

select  gender,count(gender)as count_gender from patient_churn_dataset
where churned=1
group by gender;

/*4.Calculate the churn percentage for each state.*/

select state , 
COUNT(CASE WHEN Churned = 1 THEN 1 END) * 100.0 / COUNT(*) AS churn_percentage
from patient_churn_dataset
group by state;

/*5.Find the average age of churned patients.*/

select  avg(age)as Avg_age from patient_churn_dataset
where churned =1;

/*6.Analyze whether patients with low tenure (Tenure_Months) are more likely to churn.*/

alter table patient_churn_dataset add column Tenure_Months_status varchar(20);

update patient_churn_dataset
set Tenure_Months_status = case
when Tenure_months between 1 and 24 then "Low Tenure"
when Tenure_months between 25 and 60 then "Medium Tenure"
when Tenure_months between 61 and  120 then "high Tenure"
end;

SELECT
Tenure_Months_Status,
COUNT(*) AS total_patients,
SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) AS churned_patients
FROM patient_churn_dataset
GROUP BY Tenure_Months_Status;

SELECT
Tenure_months_Status,
ROUND(
SUM(CASE WHEN Churned = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2
) AS churn_percentage
FROM patient_churn_dataset
GROUP BY Tenure_Months_Status;

/*7.Find the churn count for patients with Visits_Last_Year ≤ 2.*/

SELECT COUNT(*) AS churn_count
FROM patient_churn_dataset
WHERE Visits_Last_Year <= 2
AND Churned = 1;

/* 8.Find the churn count for patients with high missed appointments.*/

alter table patient_churn_dataset add column missed_appointments_status varchar(20);

update patient_churn_dataset
set missed_appointments_status =case
when Missed_Appointments between 0 and 1 then "Low"
when Missed_Appointments between 2 and 3 then "Medium"
when Missed_Appointments between 4 and 5 then "high"
end;
select count(*) from patient_churn_dataset
where missed_appointments_status= "high " and churned= 1 ;

/* 9.Find the number of churned patients with Overall_Satisfaction less than 3.*/

select count(*) from patient_churn_dataset
where Overall_Satisfaction<3 and churned=1;

/*10.Perform churn analysis by Insurance_Type.*/


select count(*),insurance_type from patient_churn_dataset
where churned=1
group by insurance_type;

SELECT
insurance_type,
COUNT(*) AS total_patients,
SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_patients,
ROUND(SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*), 2) AS churn_percentage
FROM patient_churn_dataset
GROUP BY insurance_type;


/*11.Find the churn rate for each Specialty.*/
select Specialty, count(*) as total_speciality from patient_churn_dataset
where churned=1
group by Specialty;


/*12.Find how many patients with Billing_Issues have churned.*/

select Billing_Issues, count(*)
from patient_churn_dataset
where churned = 1
and Billing_Issues=1;

/*13.Find the churn count for patients who do not use the portal.*/

select Portal_Usage, count(*) from patient_churn_dataset
where churned=1 and portal_usage=0
group by Portal_Usage;

/* 14.Compare the average out-of-pocket cost between churned and non-churned patients.*/

select  avg(Avg_Out_Of_Pocket_Cost) ,churned from patient_churn_dataset 
group by churned;

/* 15.Find the churn count for patients whose distance to the facility is greater than 15 miles.*/

select  churned,count(*) from patient_churn_dataset 
where Distance_To_Facility_Miles >15 and churned=1
group by  churned;

/*16.Find patients who churned and have Days_Since_Last_Visit greater than 180.*/

select  patient_id,Days_Since_Last_Visit from patient_churn_dataset 
where Days_Since_Last_Visit >180 and churned=1;

/* 17.Display the top 5 states with the highest churn count.*/

select  State,count(*)  from patient_churn_dataset 
where churned=1
group by state
order by count(*) desc
limit 5;

/*18.Find the churn rate for patients with Provider_Rating less than 3.*/

SELECT
Provider_Rating,
COUNT(*) AS total_patients,
SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_patients,
ROUND(
SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END)*100.0/COUNT(*),
2
) AS churn_rate
FROM patient_churn_dataset
WHERE Provider_Rating < 3
GROUP BY Provider_Rating;

/* 19.Analyze the relationship between Wait_Time_Satisfaction and churn.*/

SELECT
Wait_Time_Satisfaction,
COUNT(*) AS total_patients,
SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) AS churned_patients,
ROUND(
SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
2
) AS churn_percentage
FROM patient_churn_dataset
GROUP BY Wait_Time_Satisfaction
ORDER BY Wait_Time_Satisfaction; 	

/*20.Create a summary report showing Overall_Satisfaction, Visits_Last_Year, and churn status.*/

select  Overall_Satisfaction,  Visits_Last_Year,churned_status, count(*)as Total_count from patient_churn_dataset
group by Overall_Satisfaction,  Visits_Last_Year,churned_status
order by  Overall_Satisfaction,  Visits_Last_Year ;


/* 21.Rank genders based on churn count using RANK().*/

select gender, count(*),
rank() over(order by gender) from patient_churn_dataset
group by gender ;

/* 22.Rank insurance types based on churn percentage (highest first).*/

SELECT
Insurance_Type,
COUNT(*) AS total_patients,
ROUND(
SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*),
2
) AS churn_percentage,
RANK() OVER (
ORDER BY
SUM(CASE WHEN churned = 1 THEN 1 ELSE 0 END) * 1.0 / COUNT(*) DESC
) AS insurance_rank
FROM patient_churn_dataset
GROUP BY Insurance_Type;






