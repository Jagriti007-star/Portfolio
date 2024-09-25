create database if not exists Project;
use Project ; 

select * from Student;


-- 1 : Effect of Sleep Hours on Exam Scors

Select Sleep_Hours,
	round(avg(Exam_score),2) as "Average_Scors"
From Student
group by Sleep_hours
order by Sleep_hours;


select 
	case
		When Sleep_Hours < 5 then 'Less than 5 Hours'
        When Sleep_Hours between 5 and 7 then '5 to 7 Hours'
        Else 'More than 7 Hours'
	End as Sleep_Category,
Round(Avg(Exam_Score),2) as 'Average Score',
Count(*) as 'Total Students'
from Student
Group by Sleep_Category
Order by Sleep_Category;

/**
The highest average score (67.63) is observed in the group sleeping less than 5 hours, but with a smaller sample size (309), indicating possible variability.
The largest group (5 to 7 hours, with 3,812 students) shows a solid average (67.24), which can be considered more reliable.
The group sleeping more than 7 hours (2,486 students) has the lowest average score (67.19)
**/

-- 2. Influence of Extra Curricular Activites on Results

Select Extracurricular_activities,
	Round(Avg(Previous_Scores),2) as "Previous_Avg_Scores",
	Round(avg(Exam_Score),2) as "Average_Exam_Scores",
    Count(*) as "Number of Student"
from Student
group by Extracurricular_activities;

/**
The analysis indicates a positive correlation between participation in extracurricular activities and both previous scores and present exam scores.
 Students involved in these activities tend to have slightly higher scores.
**/

-- 3. Average Attendance of Students who take part in Extracurricular Activities and get sleep for more tha average hours of sleep

Select avg(Attendance) as "Average Attendence",
	Extracurricular_Activities,
    Count(*) as "Total Students"
from Student 
	where Sleep_hours > 
		( Select avg(Sleep_Hours) from Student)
and Extracurricular_Activities ='Yes'
group by Extracurricular_Activities;
    

-- 4. Effect of Family_Income and Parental_Involvement on Exams

Select Family_Income,
	Exam_Score,
	dense_rank() over (partition by Family_Income order by Exam_Score desc) as Income_rank
from Student;

Select Parental_Involvement,
	Exam_Score,
	dense_rank() over (partition by Parental_Involvement order by Exam_Score desc) as Income_rank
from Student;

-- 5. Impact of Parental Education level on Students attendence and hours of study

With ParentalEffect as (
	select Parental_Education_Level,
	Avg(Attendance) as 'Average Attendence',
    Avg(Hours_Studied) as "Average Hours of Study",
    Count(*) as "Total Students"
from student
group by Parental_Education_Level
)
Select * from ParentalEffect ;

-- 6. Impact of Teacher Quality and Peer Influence on Student's Score

Select Teacher_Quality,
	Peer_Influence,
    Avg(Exam_Score) as "Average_Score"
from Student
group by Teacher_Quality,Peer_Influence
order by Average_Score desc;


-- 7. Average Attendence from each school type

Delimiter &&
Create function AvgAttendance (School varchar(25))
returns decimal(5,2)
DETERMINISTIC
begin
	declare avg_attendance decimal(5,2);
    select avg(Attendance) into avg_attendance
    from student
    where School_Type=School;
    
    return avg_attendance;

End &&
Delimiter ;



SELECT AvgAttendance('Public') as Average_Attendence;
SELECT AvgAttendance('Private') as Average_Attendence;
    
    
    
 
    
    

    




