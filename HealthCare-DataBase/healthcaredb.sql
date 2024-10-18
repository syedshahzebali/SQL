Create Database Healthcare;
Use Healthcare;
CREATE TABLE FactTable(
	FactTablePK varchar(255)					Not NULL Primary Key
	,dimPatientPK varchar(255)				Not NULL
	,dimPhysicianPK varchar(255)				Not NULL
	,dimDatePostPK varchar(255)				Not NULL
	,dimDateServicePKTables varchar(255)			Not NULL
	,dimCPTCodePK varchar(255)				Not NULL
	,dimPayerPK varchar(255)					Not NULL
	,dimTransactionPK varchar(255)			Not NULL
	,dimLocationPK varchar(255)				Not NULL
	,PatientNumber varchar(255)				Not NULL
	,dimDiagnosisCodePK varchar(255)			Not NULL
	,CPTUnits decimal(12,2)					NULL Default 0
	,GrossCharge decimal(12,2)				NULL Default 0
	,Payment decimal(12,2)					NULL Default 0
	,Adjustmen decimal(12,2)					NULL Default 0
	,AR decimal(12,2)							NULL Default 0
	);
    drop table FactTable;

CREATE TABLE dimPatient(
	dimPatientPK varchar(255)					Not Null Primary Key
	,PatientNumber varchar(255)				NULL
	,FirstName varchar(255)					NULL
	,LastName varchar(255)					NULL
	,Email varchar(255)						NULL
	,PatientGender varchar(255)				NULL
	,PatientAge int							NULL
	,City varchar(255)						NULL
	,State varchar(255)						NULL);
	drop table dimPatient;


CREATE TABLE dimPhysician(
	dimPhysicianPK varchar(255)				Not NULL Primary Key
	,ProviderNpi varchar(255)					NULL
	,ProviderName varchar(255)				NULL
	,ProviderSpecialty varchar(255)			NULL
	,ProviderFTE decimal(10,2)				NULL Default 0);

CREATE TABLE dimTransaction(
	dimTransactionPK varchar(255)				Not NULL Primary Key
	,TransactionType varchar(255)				NULL
	,Transactionn varchar(255)					NULL
	,AdjustmentReason varchar(255)			NULL);
drop table dimTransaction;

CREATE TABLE dimPayer(
	dimPayerPK varchar(255)					Not NULL Primary Key
	,PayerName varchar(255)					NULL);

CREATE TABLE dimLocation(
	dimLocationPK varchar(255)				Not NULL Primary Key
	,LocationName varchar(255)				NULL);
drop table dimLocation;

CREATE TABLE dimDiagnosisCode(
	dimDiagnosisCodePK varchar(255)			Not NULL Primary Key
	,DiagnosisCode varchar(255)				NULL
	,DiagnosisCodeDescription varchar(255)	NULL
	,DiagnosisCodeGroup varchar(255)			NULL);
drop table dimDiagnosisCode;

CREATE TABLE dimCptCode(
	dimCPTCodePK varchar(255)					Not NULL Primary Key
	,CptCode varchar(255)						NULL
	,CptDesc varchar(255)						NULL
	,CptGrouping varchar(255)					NULL);
drop table dimCptCode;

CREATE TABLE dimDate(
	dimDatePostPK varchar(255)				Not NULL Primary Key
	,Date date								NULL
	,Year  varchar(255)						NULL
	,Month varchar(255)						NULL
	,MonthPeriod varchar(255)					NULL
	,MonthYear varchar(255)					NULL
	,Day varchar(255)							NULL
	,DayName varchar(255)						NULL);
drop table dimDate;
alter table dimdate add primary key(ï»¿dimDatePostPK);
ALTER TABLE dimDate
CHANGE `ï»¿dimDatePostPK` dimDatePostPK VARCHAR(255) NOT NULL;


	Select * from FactTable ;
	Select * from dimPatient;
	Select * from dimPhysician;
	Select * from dimTransaction;
	Select * from dimPayer;
	Select * from dimLocation;
	Select * from dimDiagnosisCode;
	Select * from dimCptCode;
	Select * from dimdate;

   
    Alter Table FactTable
Add  Constraint FK_dimPatientPK Foreign Key(dimPatientPK) References dimPatient(dimPatientPK)
	,Add Constraint FK_dimPhysicianPK Foreign Key(dimPhysicianPK) References dimPhysician(dimPhysicianPK)
	,Add Constraint FK_dimTransactionPK Foreign Key(dimTransactionPK) References dimTransaction(dimTransactionPK)
	,Add Constraint FK_dimPayerPK Foreign Key(dimPayerPK) References dimPayer(dimPayerPK)
	,Add Constraint FK_dimLocationPK Foreign Key(dimLocationPK) References dimLocation(dimLocationPK)
	,Add Constraint FK_dimDiagnosisCodePK Foreign Key(dimDiagnosisCodePK) References dimDiagnosisCode(dimDiagnosisCodePK)
	,Add Constraint FK_dimCptCodePK Foreign Key(dimCptCodePK) References dimCptCode(dimCptCodePK)
	,Add Constraint FK_dimDatePK Foreign Key(dimDatePostPK) References dimDate(dimDatePostPK);
    

-- How many rows of data are in the FactTable that include a Gross Charge lesser than $100?
select count(*) as countrows 
from FactTable
where FactTable.GrossCharge <100;

-- How many unique patients exist is the Healthcare_DB?
select count(distinct dimPatientPK) from dimpatient;

-- How many CptCodes are in each CptGrouping?
select count(CptGrouping) as cptodescount
from dimcptcode;

-- 	How many physicians have submitted a Medicare insurance claim?
select count(distinct dimPhysicianPK) AS NumberOfPhysicians
from FactTable
JOIN dimPayer  ON FactTable.dimPayerPK = dimPayer.dimPayerPK
WHERE dimPayer.PayerName = 'Medicare';

-- Calculate the Gross Collection Rate (GCR) for each
-- LocationName - See Below 
-- GCR = Payments divided GrossCharge
-- Which LocationName has the highest GCR?

SELECT dimlocation.LocationName, 
SUM(FactTable.Payment) / SUM(FactTable.GrossCharge) AS GCR
FROM FactTable
JOIN dimlocation ON FactTable.dimLocationPK = dimlocation.dimLocationPK
GROUP BY dimlocation.LocationName
HAVING SUM(FactTable.GrossCharge) > 0
ORDER BY GCR DESC
LIMIT 1;

-- 	How many CptCodes have more than 100 units?
SELECT COUNT(DISTINCT dimCPTCodePK) AS NumberOfCPTCodes
FROM FactTable 
WHERE CPTUnits > 100;

-- Find the physician specialty that has received the highest
-- amount of payments. Then show the payments by month for this group of physicians. 
SELECT dimPhysician.ProviderSpecialty, 
       SUM(FactTable.Payment) AS TotalPayments
FROM FactTable 
JOIN dimPhysician  ON FactTable.dimPhysicianPK = dimPhysician.dimPhysicianPK
GROUP BY dimPhysician.ProviderSpecialty
ORDER BY TotalPayments DESC
LIMIT 1;

SELECT d.MonthYear, 
       SUM(f.Payment) AS MonthlyPayments
FROM FactTable f
JOIN dimPhysician p ON f.dimPhysicianPK = p.dimPhysicianPK
JOIN dimDate d ON f.dimDatePostPK = d.dimDatePostPK
WHERE p.ProviderSpecialty = (
    SELECT p.ProviderSpecialty
    FROM FactTable f
    JOIN dimPhysician p ON f.dimPhysicianPK = p.dimPhysicianPK
    GROUP BY p.ProviderSpecialty
    ORDER BY SUM(f.Payment) DESC
    LIMIT 1
)
GROUP BY d.MonthYear
ORDER BY d.MonthYear;
    
-- How many CptUnits by DiagnosisCodeGroup are assigned to 
-- a "J code" Diagnosis (these are diagnosis codes with the letter J in the code)?
SELECT d.DiagnosisCodeGroup, 
       SUM(f.CPTUnits) AS TotalCPTUnits
FROM FactTable f
JOIN dimDiagnosisCode d ON f.dimDiagnosisCodePK = d.dimDiagnosisCodePK
WHERE d.DiagnosisCode LIKE '%J%'
GROUP BY d.DiagnosisCodeGroup;

-- You've been asked to put together a report that details 
-- Patient demographics. The report should group patients
-- into three buckets- Under 18, between 18-65, & over 65
-- Please include the following columns:
-- First and Last name in the same column
-- Email
-- Patient Age
-- City and State in the same column

SELECT 
    CONCAT(p.FirstName, ' ', p.LastName) AS FullName,
    p.Email,
    p.PatientAge,
    CONCAT(p.City, ', ', p.State) AS Location,
    CASE
        WHEN p.PatientAge < 18 THEN 'Under 18'
        WHEN p.PatientAge BETWEEN 18 AND 65 THEN '18-65'
        ELSE 'Over 65'
    END AS AgeGroup
FROM 
    dimPatient p
ORDER BY 
    p.PatientAge;
    
-- How many dollars have been written off (adjustments) due
-- to credentialing (AdjustmentReason)? Which location has the 
-- highest number of credentialing adjustments? How many 
-- physicians at this location have been impacted by 
-- credentialing adjustments? What does this mean?

SELECT SUM(f.Adjustmen) AS TotalWrittenOff
FROM FactTable f
JOIN dimTransaction t ON f.dimTransactionPK = t.dimTransactionPK
WHERE t.AdjustmentReason = 'Credentialing';

SELECT l.LocationName, 
       COUNT(f.dimTransactionPK) AS CredentialingCount
FROM FactTable f
JOIN dimTransaction t ON f.dimTransactionPK = t.dimTransactionPK
JOIN dimLocation l ON f.dimLocationPK = l.dimLocationPK
WHERE t.AdjustmentReason = 'Credentialing'
GROUP BY l.LocationName
ORDER BY CredentialingCount DESC
LIMIT 1;

SELECT COUNT(DISTINCT f.dimPhysicianPK) AS ImpactedPhysicians
FROM FactTable f
JOIN dimTransaction t ON f.dimTransactionPK = t.dimTransactionPK
JOIN dimLocation l ON f.dimLocationPK = l.dimLocationPK
WHERE t.AdjustmentReason = 'Credentialing' 
AND l.LocationName = 'Angelstone Community Hospital';

-- What is the average patientage by gender for patients
-- seen at Big Heart Community Hospital with a Diagnosis
-- that included Type 2 diabetes? And how many Patients
-- are included in that average?

SELECT 
    p.PatientGender,
    AVG(p.PatientAge) AS AveragePatientAge,
    COUNT(*) AS PatientCount
FROM 
    dimPatient p
JOIN 
    FactTable f ON p.PatientNumber = f.PatientNumber
JOIN 
    dimDiagnosisCode d ON f.dimDiagnosisCodePK = d.dimDiagnosisCodePK
JOIN 
    dimLocation l ON f.dimLocationPK = l.dimLocationPK
WHERE 
    l.LocationName = 'Big Heart Community Hospital' AND
    d.DiagnosisCodeDescription LIKE '%Type 2 diabetes%'
GROUP BY 
    p.PatientGender;
    
-- There are a two visit types that you have been asked
-- to compare (use CptDesc).
-- Office/outpatient visit est
-- Office/outpatient visit new
-- Show each CptCode, CptDesc and the assocaited CptUnits.
-- What is the Charge per CptUnit? (Reduce to two decimals)
-- What does this mean?

SELECT 
    c.CptCode,
    c.CptDesc,
    SUM(f.CPTUnits) AS TotalCPTUnits,
    ROUND(SUM(f.GrossCharge) / NULLIF(SUM(f.CPTUnits), 0), 2) AS ChargePerCPTUnit
FROM 
    FactTable f
JOIN 
    dimCptCode c ON f.dimCPTCodePK = c.dimCPTCodePK
WHERE 
    c.CptDesc IN ('Office/outpatient visit est', 'Office/outpatient visit new')
GROUP BY 
    c.CptCode, c.CptDesc
ORDER BY 
    c.CptCode;
    
-- Similar to Question 12, you've been asked to analysis
-- the PaymentperUnit (NOT ChargeperUnit). You've been 
-- tasked with finding the PaymentperUnit by PayerName. 
-- Do this analysis on the following visit type (CptDesc)
-- Initial hospital care
-- Show each CptCode, CptDesc and associated CptUnits.
-- Note you will encounter a zero value error. If you
-- can't remember what to do find the ifnull lecture in Section 8. What does this mean?

SELECT 
    c.CptCode,
    c.CptDesc,
    SUM(f.CPTUnits) AS TotalCPTUnits,
    ROUND(SUM(f.Payment) / NULLIF(SUM(f.CPTUnits), 0), 2) AS PaymentPerUnit,
    p.PayerName
FROM 
    FactTable f
JOIN 
    dimCptCode c ON f.dimCPTCodePK = c.dimCPTCodePK
JOIN 
    dimPayer p ON f.dimPayerPK = p.dimPayerPK
WHERE 
    c.CptDesc = 'Initial hospital care'
GROUP BY 
    c.CptCode, c.CptDesc, p.PayerName
ORDER BY 
    c.CptCode, p.PayerName;
    
-- Within the FactTable we are able to see GrossCharges. 
-- You've been asked to find the NetCharge, which means
-- Contractual adjustments need to be subtracted from the
-- GrossCharge (GrossCharges - Contractual Adjustments).
-- after you've found the NetCharge then calculate the 
-- Net Collection Rate (Payments/NetCharge) for each 
-- physician specialty. Which physician specialty has the 
-- worst Net Collection Rate with a NetCharge greater than 
-- $25,000? What is happening here? Where are the other 
-- dollars and why aren't they being collected What does this mean?

SELECT 
    p.ProviderSpecialty,
    SUM(f.GrossCharge) AS TotalGrossCharge,
    SUM(f.Adjustmen) AS TotalContractualAdjustments,
    SUM(f.Payment) AS TotalPayments,
    (SUM(f.GrossCharge) - SUM(f.Adjustmen)) AS NetCharge,
    ROUND(NULLIF(SUM(f.Payment) / NULLIF((SUM(f.GrossCharge) - SUM(f.Adjustmen)), 0), 2), 0) AS NetCollectionRate
FROM 
    FactTable f
JOIN 
    dimPhysician p ON f.dimPhysicianPK = p.dimPhysicianPK
GROUP BY 
    p.ProviderSpecialty
HAVING 
    (SUM(f.GrossCharge) - SUM(f.Adjustmen)) > 25000
ORDER BY 
    NetCollectionRate ASC
LIMIT 1; -- To find the worst Net Collection Rate

-- Build a Table that includes the following elements:
-- LocationName
-- CountofPhysicians
-- CountofPatients
-- GrossCharge
-- AverageChargeperPatients


SELECT 
    l.LocationName,
    COUNT(DISTINCT p.dimPhysicianPK) AS CountOfPhysicians,
    COUNT(DISTINCT f.dimPatientPK) AS CountOfPatients,
    SUM(f.GrossCharge) AS GrossCharge,
    ROUND(SUM(f.GrossCharge) / NULLIF(COUNT(DISTINCT f.dimPatientPK), 0), 2) AS AverageChargePerPatient
FROM 
    (SELECT DISTINCT dimLocationPK, dimPhysicianPK FROM dimPhysician) p
JOIN 
    FactTable f ON p.dimPhysicianPK = f.dim