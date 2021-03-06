/****** Script for SelectTopNRows command from SSMS  ******/
Select * into #coredata from [dbo].[diabetic_data]

---------------------------------- Pre-Processing -------------------------------------------------

------ Medical Speciality Numerical ----------
Drop table #temy 

select distinct [medical_specialty] into #temy from #coredata

ALTER TABLE #temy ADD Medical_Specaility_No INT

DECLARE @id INT 
SET @id = 0
UPDATE #temy 
SET @id = Medical_Specaility_No = @id + 1 

Select a.*,b.Medical_Specaility_No  into #Maindata from #coredata a,#temy b
where b.medical_specialty = a.medical_specialty

--- ----------- Removing the missing values from the dataset which makes easy and cleaning the data --------
ALTER TABLE #Maindata DROP COLUMN [weight]
ALTER TABLE #Maindata DROP COLUMN [payer_code]
ALTER TABLE #Maindata DROP COLUMN [medical_specialty]
ALTER TABLE #Maindata DROP COLUMN [admission_type_id]
ALTER TABLE #Maindata DROP COLUMN [discharge_disposition_id]
ALTER TABLE #Maindata DROP COLUMN [admission_source_id]
ALTER TABLE #Maindata DROP COLUMN [citoglipton]
ALTER TABLE #Maindata DROP COLUMN [examide]

-------------- collecting minimum encounter id  grouping by patient id ----- --------

select min([encounter_id])  as en  into #d from #Maindata
group by [patient_nbr]




--------     Table Joining -----------

Drop table #dt
select a.* into #dt from #Maindata a, #d b
where a.[encounter_id] = b.en




-------------- Race should be numerized for the data ----------------- 

update #dt
set race = '0' where race = 'AfricanAmerican'
update #dt
set race = '1' where race = 'Hispanic'
update #dt
set race = '2' where race = 'Caucasian'
update #dt
set race = '3' where race = 'Asian'
update #dt
set race = '4'  where  race = '?' or race = 'Other'


--------Age-------------- 

update #dt
Set age = '0' where age = '[0-10)' 
update #dt
Set age = '1' where age = '[10-20)' 
update #dt
Set age = '2' where age = '[20-30)'
update #dt
Set age = '3' where age = '[30-40)'
update #dt
Set age = '4' where age = '[40-50)'
update #dt
Set age = '5' where age = '[50-60)'
update #dt
Set age = '6' where age = '[60-70)'
update #dt
Set age = '7' where age = '[70-80)'
update #dt
Set age = '8' where age = '[80-90)'
update #dt
Set age = '9' where age = '[90-100)'



-----------Grouping the diagnosis based on ICD9 categories-------------------------


update #dt
set diag_1 = 'Circulatory' where diag_1 between '390' and  '459' or diag_1 = '785'
update #dt
set diag_2 = 'Circulatory' where diag_2 between '390' and  '459' or diag_2 = '785'
update #dt
set diag_3 = 'Circulatory' where diag_3 between '390' and  '459' or diag_3 = '785'
update #dt
set diag_1 = 'Respiratory' where diag_1 between '460' and  '519' or diag_1 = '786'
update #dt
set diag_2 = 'Respiratory' where diag_2 between '460' and  '519' or diag_2 = '786'
update #dt
set diag_3 = 'Respiratory' where diag_3 between '460' and  '519' or diag_3 = '786'
update #dt
set diag_1 = 'Digestive' where diag_1 between '520' and  '579' or diag_1 = '787'
update #dt
set diag_2 = 'Digestive' where diag_2 between '520' and  '579' or diag_2 = '787'
update #dt
set diag_3 = 'Digestive' where diag_3 between '520' and  '579' or diag_3 = '787'
update #dt
set diag_1 = 'Diabetes' where diag_1 like '%250%' 
update #dt
set diag_2 = 'Diabetes' where diag_2 like '%250%' 
update #dt
set diag_3 = 'Diabetes' where diag_3 like '%250%' 
update #dt
set diag_1 = 'Injury' where diag_1 between '800' and  '999' 
update #dt
set diag_2 = 'Injury' where diag_2 between '800' and  '999' 
update #dt
set diag_3 = 'Injury' where diag_3 between '800' and  '999' 
update #dt
set diag_1 = 'Musculoskeletal' where diag_1 between '710' and  '739' 
update #dt
set diag_2 = 'Musculoskeletal' where diag_2 between '710' and  '739' 
update #dt
set diag_3 = 'Musculoskeletal' where diag_3 between '710' and  '739' 
update #dt
set diag_1 = 'Genitourinary' where diag_1 between '580' and  '629' or diag_1 = '788'
update #dt
set diag_2 = 'Genitourinary' where diag_2 between '580' and  '629' or diag_2 = '788'
update #dt
set diag_3 = 'Genitourinary' where diag_3 between '580' and  '629' or diag_3 = '788'
update #dt
set diag_1 = 'Neoplasms' where diag_1 between '140' and  '239'
update #dt
set diag_2 = 'Neoplasms' where diag_2 between '140' and  '239' 
update #dt
set diag_3 = 'Neoplasms' where diag_3 between '140' and  '239' 

update #dt
set diag_1 = 'Other' where diag_1 not like  'Circulatory' and  diag_1 not like 'Respiratory' and diag_1 not like 'Digestive' and diag_1 not like 'Diabetes'
and diag_1 not like 'Genitourinary' and diag_1 not like  'Neoplasms' and diag_1 not like  'Injury' and diag_1 not like  'Musculoskeletal'

update #dt
set diag_2 = 'Other' where diag_2 not like  'Circulatory' and  diag_2 not like 'Respiratory' and diag_2 not like 'Digestive' and diag_2 not like 'Diabetes'
and diag_2 not like 'Genitourinary' and diag_2 not like  'Neoplasms' and diag_2 not like  'Injury' and diag_2 not like  'Musculoskeletal'


update #dt
set diag_3 = 'Other' where diag_3 not like  'Circulatory' and  diag_3 not like 'Respiratory' and diag_3 not like 'Digestive' and diag_3 not like 'Diabetes'
and diag_3 not like 'Genitourinary' and diag_3 not like  'Neoplasms' and diag_3 not like  'Injury' and diag_3 not like  'Musculoskeletal'




----------- Numberising  the features  for medications-------------

drop table #tmpydt

Select [encounter_id],
CASE WHEN gender = 'Male' THEN '0' ELSE '1' END AS Gender, 
CASE WHEN max_glu_serum = 'None' THEN '0' WHEN max_glu_serum = '>200' THEN '1' WHEN max_glu_serum = '>300' THEN '2' ELSE '3' END AS max_glu_serum,
CASE WHEN A1Cresult = 'None' THEN '0' WHEN A1Cresult = '>7' THEN '2' WHEN A1Cresult = '>8' THEN '2' Else '3' END AS A1Cresult,
CASE WHEN metformin = 'No' THEN '0'  WHEN metformin = 'Down' THEN '2'  WHEN metformin = 'Steady' THEN '1'ELSE '3' END AS metformin,
CASE WHEN [repaglinide] = 'No' THEN '0'WHEN [repaglinide] = 'Down' THEN '2'  WHEN [repaglinide] = 'Steady' THEN '1'ELSE '3' END AS [repaglinide],
CASE WHEN [nateglinide] = 'No' THEN '0' WHEN [nateglinide] = 'Down' THEN '2'  WHEN [nateglinide] = 'Steady' THEN '1'ELSE '3' END AS [nateglinide],
CASE WHEN [chlorpropamide] = 'No' THEN '0' WHEN [chlorpropamide] = 'Down' THEN '2'  WHEN [chlorpropamide] = 'Steady' THEN '1'ELSE '3' END AS [chlorpropamide],
CASE WHEN [glimepiride] = 'No' THEN '0' WHEN [glimepiride] = 'Down' THEN '2'  WHEN [glimepiride] = 'Steady' THEN '1'ELSE '3' END AS [glimepiride],
CASE WHEN [acetohexamide] = 'No' THEN '0' ELSE '1' END AS [acetohexamide],
CASE WHEN [glipizide] = 'No' THEN '0' WHEN [glipizide] = 'Down' THEN '2'  WHEN [glipizide] = 'Steady' THEN '1'ELSE '3' END AS [glipizide],
CASE WHEN [glyburide] = 'No' THEN '0' WHEN [glyburide] = 'Down' THEN '2'  WHEN [glyburide] = 'Steady' THEN '1'ELSE '3' END AS [glyburide],
CASE WHEN [tolbutamide] = 'No' THEN '0' ELSE '1' END AS [tolbutamide],
CASE WHEN [pioglitazone] = 'No' THEN '0' WHEN [pioglitazone] = 'Down' THEN '2'  WHEN [pioglitazone] = 'Steady' THEN '1'ELSE '3' END AS [pioglitazone],
CASE WHEN [rosiglitazone] = 'No' THEN '0' WHEN [rosiglitazone] = 'Down' THEN '2'  WHEN [rosiglitazone] = 'Steady' THEN '1'ELSE '3' END AS [rosiglitazone],
CASE WHEN [acarbose] =  'No' THEN '0' WHEN [acarbose] = 'Down' THEN '2'  WHEN [acarbose] = 'Steady' THEN '1'ELSE '3' END AS [acarbose],
CASE WHEN [miglitol] =  'No' THEN '0' WHEN [miglitol] = 'Down' THEN '2'  WHEN [miglitol] = 'Steady' THEN '1'ELSE '3' END AS [miglitol],
CASE WHEN [troglitazone] =  'No' THEN '0' ELSE '1' END AS [troglitazone],
CASE WHEN [insulin] =  'No' THEN '0' WHEN [insulin] = 'Down' THEN '2'  WHEN [insulin] = 'Steady' THEN '1'ELSE '3' END AS [insulin],
CASE WHEN [glyburide-metformin] =  'No' THEN '0' WHEN [glyburide-metformin] = 'Down' THEN '2'  WHEN [glyburide-metformin] = 'Steady' THEN '1'ELSE '3' END AS [glyburide-metformin],
CASE WHEN [glipizide-metformin] =  'No' THEN '0' ELSE '1' END AS [glipizide-metformin],
CASE WHEN [glimepiride-pioglitazone] =  'No' THEN '0' ELSE '1' END AS [glimepiride-pioglitazone],
CASE WHEN [metformin-rosiglitazone] =  'No' THEN '0' ELSE '1' END AS [metformin-rosiglitazone],
CASE WHEN [metformin-pioglitazone] =  'No' THEN '0' ELSE '1' END AS [metformin-pioglitazone],
CASE WHEN change = 'No' THEN '0' ELSE '1' END AS change,
CASE WHEN diabetesMed =  'No' THEN '0' ELSE '1' END AS diabetesMed,
CASE WHEN readmitted =  'No' THEN '0' ELSE '1' END AS readmitted
into #tmpydt
from #dt

--- Binarizing  the features  for diagonisis -------------


Drop table #tdt2

select d.[encounter_id],
case when d.diag_1 = 'Circulatory' or d.diag_2 = 'Circulatory'  or  d.diag_3 = 'Circulatory' then 1 else 0 end as Circulatory,
case when d.diag_1 = 'Respiratory' or d.diag_2 = 'Respiratory'  or  d.diag_3 = 'Respiratory'then 1 else 0 end as Respiratory,
case when d.diag_1 = 'Digestive' or d.diag_2 = 'Digestive'  or  d.diag_3 = 'Digestive'then 1 else 0 end as Digestive,
case when d.diag_1 = 'Diabetes' or d.diag_2 = 'Diabetes'  or  d.diag_3 = 'Diabetes' then 1 else 0 end as Diabetes,
case when d.diag_1 = 'Neoplasms' or d.diag_2 = 'Neoplasms'  or  d.diag_3 = 'Neoplasms' then 1 else 0 end as Neoplasms,
case when d.diag_1 = 'Injury' or d.diag_2 = 'Injury'  or  d.diag_3 = 'Injury'then 1 else 0 end as Injury,
case when d.diag_1 = 'Musculoskeletal' or d.diag_2 = 'Musculoskeletal'  or  d.diag_3 = 'Musculoskeletal' then 1 else 0 end as Musculoskeletal,
case when d.diag_1 = 'Genitourinary'or d.diag_2 = 'Genitourinary'  or  d.diag_3 = 'Genitourinary'  then 1 else 0 end as Genitourinary,
case when d.diag_1 = 'Other' or d.diag_2 = 'Other'  or  d.diag_3 = 'Other' then 1 else 0 end as Other
into #tdt2
from #dt as d, #dt as c
where c.[encounter_id] = d.[encounter_id] 


select b.*,c.race,c.age, c.time_in_hospital,c.num_lab_procedures,c.num_procedures,c.num_medications,
c.number_outpatient,c.number_emergency,c.number_inpatient,c.number_diagnoses,a.Gender,a.[max_glu_serum],a.[A1Cresult],
a.[metformin],a.[repaglinide],a.[nateglinide],a.[chlorpropamide],a.[glimepiride],a.[acetohexamide],a.[glipizide],a.[glyburide],
a.[tolbutamide],a.[pioglitazone],a.[rosiglitazone],a.[acarbose],a.[miglitol],a.[troglitazone],a.[insulin],a.[glyburide-metformin],
a.[glipizide-metformin],a.[metformin-rosiglitazone],a.[metformin-pioglitazone],a.[change]
,a.[diabetesMed],a.[readmitted]  into dbo.dt1 from #tdt a , #tdt2 b,#data c
where a.encounter_id = b.encounter_id and b.encounter_id = c.encounter_id




select * from dbo.dt1
	.









