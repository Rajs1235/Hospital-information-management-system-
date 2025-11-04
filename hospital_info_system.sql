-- ========= SCHEMA (V2) =========

-- 1. Patients Table (Modified)
CREATE TABLE Patients (
  PatientID INT PRIMARY KEY,
  Name VARCHAR(100),
  Gender VARCHAR(10),
  DateOfBirth DATE, -- Changed from Age
  Contact VARCHAR(15),
  Address TEXT
);

-- 2. Departments Table (New)
CREATE TABLE Departments (
  DepartmentID INT PRIMARY KEY,
  DepartmentName VARCHAR(100)
);

-- 3. Doctors Table (Modified)
CREATE TABLE Doctors (
  DoctorID INT PRIMARY KEY,
  Name VARCHAR(100),
  Specialization VARCHAR(100),
  DepartmentID INT, -- Replaced 'Availability'
  Contact VARCHAR(15),
  FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- 4. DoctorSchedules Table (New)
CREATE TABLE DoctorSchedules (
  ScheduleID INT PRIMARY KEY,
  DoctorID INT,
  DayOfWeek VARCHAR(10), -- e.g., 'Monday', 'Tuesday'
  StartTime TIME,
  EndTime TIME,
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- 5. Appointments Table (Unchanged, for Out-Patients)
CREATE TABLE Appointments (
  AppointmentID INT PRIMARY KEY,
  PatientID INT,
  DoctorID INT,
  Date DATE,
  TimeSlot VARCHAR(20),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- 6. Admissions Table (New, for In-Patients)
CREATE TABLE Admissions (
  AdmissionID INT PRIMARY KEY,
  PatientID INT,
  DoctorID INT, -- Admitting Doctor
  AdmissionDate DATETIME,
  DischargeDate DATETIME, -- Can be NULL if currently admitted
  RoomNumber VARCHAR(10),
  FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
  FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID)
);

-- 7. Treatments Table (Unchanged)
CREATE TABLE Treatments (
  TreatmentID INT PRIMARY KEY,
  AppointmentID INT, -- For Out-Patient treatments
  -- We could also add AdmissionID here for In-Patient treatments
  Diagnosis TEXT,
  Prescription TEXT,
  FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID)
);

-- 8. Billing Table (Unchanged)
CREATE TABLE Billing (
  BillID INT PRIMARY KEY,
  TreatmentID INT,
  Amount DECIMAL(10,2),
  PaymentStatus VARCHAR(20),
  FOREIGN KEY (TreatmentID) REFERENCES Treatments(TreatmentID)
);
-- Sample Queries
-- 1. List all patients treated by a specific doctor
SELECT P.Name, D.Name AS Doctor, A.Date
FROM Patients P
JOIN Appointments A ON P.PatientID = A.PatientID
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE D.Name = 'Dr. Mehta';

-- 2. Total revenue collected by month
SELECT strftime('%Y-%m', A.Date) AS Month, SUM(B.Amount) AS Revenue
FROM Billing B
JOIN Treatments T ON B.TreatmentID = T.TreatmentID
JOIN Appointments A ON T.AppointmentID = A.AppointmentID
WHERE B.PaymentStatus = 'Paid'
GROUP BY Month;

-- 3. Find patients with unpaid bills
SELECT P.Name, B.Amount
FROM Patients P
JOIN Appointments A ON P.PatientID = A.PatientID
JOIN Treatments T ON A.AppointmentID = T.AppointmentID
JOIN Billing B ON T.TreatmentID = B.TreatmentID
WHERE B.PaymentStatus = 'Unpaid';

-- 4. Upcoming appointments
SELECT P.Name, D.Name AS Doctor, A.Date, A.TimeSlot
FROM Appointments A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE A.Date >= DATE('now')
ORDER BY A.Date ASC;
-- Query 5: Find all currently admitted patients
-- This checks for NULL in the DischargeDate
SELECT P.Name, A.AdmissionDate, A.RoomNumber, D.Name AS AdmittingDoctor
FROM Admissions A
JOIN Patients P ON A.PatientID = P.PatientID
JOIN Doctors D ON A.DoctorID = D.DoctorID
WHERE A.DischargeDate IS NULL;

-- Query 6: Find a specific doctor's weekly schedule
-- This joins the new DoctorSchedules table
SELECT D.Name, S.DayOfWeek, S.StartTime, S.EndTime
FROM DoctorSchedules S
JOIN Doctors D ON S.DoctorID = D.DoctorID
WHERE D.Name = 'Dr. Mehta';

-- Query 7: Calculate Patient Age (SQLite syntax)
-- Uses the new DateOfBirth column
SELECT Name, DateOfBirth, 
       strftime('%Y', 'now') - strftime('%Y', DateOfBirth) AS Age
FROM Patients;

-- Query 8: Total Revenue by Department
-- This is a complex join across 5 tables
SELECT Dp.DepartmentName, SUM(B.Amount) AS TotalRevenue
FROM Billing B
JOIN Treatments T ON B.TreatmentID = T.TreatmentID
JOIN Appointments A ON T.AppointmentID = A.AppointmentID
JOIN Doctors D ON A.DoctorID = D.DoctorID
JOIN Departments Dp ON D.DepartmentID = D.DepartmentID
WHERE B.PaymentStatus = 'Paid'
GROUP BY Dp.DepartmentName
ORDER BY TotalRevenue DESC;

-- Query 9: Find all doctors available on Monday morning (e.g., at 10:30 AM)
-- This shows queryable schedules, which is much better than a text field
SELECT D.Name, Dp.DepartmentName, S.StartTime, S.EndTime
FROM Doctors D
JOIN DoctorSchedules S ON D.DoctorID = S.DoctorID
JOIN Departments Dp ON D.DepartmentID = D.DepartmentID
WHERE S.DayOfWeek = 'Monday' 
  AND S.StartTime <= '10:30:00'
  AND S.EndTime >= '10:30:00';

-- Query 10: Find patients with more than one appointment (using Subquery/HAVING)
-- This helps identify follow-up patients
SELECT P.Name, COUNT(A.AppointmentID) AS AppointmentCount
FROM Patients P
JOIN Appointments A ON P.PatientID = A.PatientID
GROUP BY P.PatientID, P.Name
HAVING COUNT(A.AppointmentID) > 1;
