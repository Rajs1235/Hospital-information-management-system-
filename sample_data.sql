-- Departments
INSERT INTO Departments (DepartmentID, DepartmentName) VALUES
(1, 'Cardiology'),
(2, 'Orthopedics'),
(3, 'Dermatology'),
(4, 'Neurology'),
(5, 'Pediatrics');

-- Patients
INSERT INTO Patients (PatientID, Name, Gender, DateOfBirth, Contact, Address) VALUES
(1, 'Ravi Kumar', 'Male', '1991-05-15', '9876543210', 'Bhopal, MP'),
(2, 'Anjali Sharma', 'Female', '1997-11-20', '9123456789', 'Indore, MP'),
(3, 'Amit Verma', 'Male', '1980-03-30', '9812345678', 'Jabalpur, MP'),
(4. 'Sunita Patel', 'Female', '2005-07-10', '9988776655', 'Bhopal, MP'),
(5. 'Vikram Singh', 'Male', '1965-01-25', '9223344556', 'Indore, MP'),
(6. 'Priya Das', 'Female', '2019-12-01', '9334455667', 'Rewa, MP');

-- Doctors
INSERT INTO Doctors (DoctorID, Name, Specialization, DepartmentID, Contact) VALUES
(1, 'Dr. Mehta', 'Cardiologist', 1, '9870001111'),
(2, 'Dr. Singh', 'Orthopedic Surgeon', 2, '9870002222'),
(3, 'Dr. Roy', 'Dermatologist', 3, '9870003333'),
(4, 'Dr. Gupta', 'Neurologist', 4, '9870004444'),
(5, 'Dr. Bose', 'Pediatrician', 5, '9870005555');

-- DoctorSchedules
INSERT INTO DoctorSchedules (ScheduleID, DoctorID, DayOfWeek, StartTime, EndTime) VALUES
(1, 1, 'Monday', '10:00:00', '14:00:00'),
(2, 1, 'Wednesday', '10:00:00', '14:00:00'),
(3, 1, 'Friday', '10:00:00', '14:00:00'),
(4, 2, 'Tuesday', '14:00:00', '17:00:00'),
(5, 2, 'Thursday', '14:00:00', '17:00:00'),
(6, 3, 'Tuesday', '11:00:00', '15:00:00'),
(7, 3, 'Thursday', '11:00:00', '15:00:00'),
(8, 4, 'Monday', '09:00:00', '13:00:00'),
(9, 4, 'Wednesday', '09:00:00', '13:00:00'),
(10, 5, 'Monday', '10:00:00', '16:00:00'),
(11, 5, 'Tuesday', '10:00:00', '16:00:00');

-- Appointments (Note: Dates are in the future for the 'upcoming' query)
INSERT INTO Appointments (AppointmentID, PatientID, DoctorID, Date, TimeSlot) VALUES
(101, 1, 1, '2025-11-10', '10:30AM'),
(102, 2, 3, '2025-11-12', '11:00AM'),
(103, 3, 2, '2025-11-12', '03:00PM'),
(104, 4, 4, '2025-11-10', '09:30AM'),
(105, 6, 5, '2025-11-11', '11:00AM'),
(106, 1, 1, '2025-11-17', '11:00AM'); -- Ravi Kumar's follow-up

-- Admissions (For In-Patients)
INSERT INTO Admissions (AdmissionID, PatientID, DoctorID, AdmissionDate, DischargeDate, RoomNumber) VALUES
(2001, 5, 2, '2025-10-20 14:30:00', '2025-10-25 11:00:00', 'R-101'),
(2002, 1, 1, '2025-11-01 18:00:00', NULL, 'ICU-05'), -- Ravi Kumar is currently admitted
(2003, 6, 5, '2025-11-02 10:00:00', '2025-11-04 12:00:00', 'P-202');

-- Treatments
INSERT INTO Treatments (TreatmentID, AppointmentID, Diagnosis, Prescription) VALUES
(1001, 101, 'Hypertension', 'Amlodipine 5mg daily'),
(1002, 102, 'Eczema', 'Topical Corticosteroid'),
(1003, 103, 'Knee Sprain', 'Ibuprofen 400mg & RICE'),
(1004, 104, 'Migraine', 'Sumatriptan 50mg'),
(1005, 105, 'Fever', 'Paracetamol 250mg syrup');
-- Note: You could add more treatments and link them to AdmissionID

-- Billing
INSERT INTO Billing (BillID, TreatmentID, Amount, PaymentStatus) VALUES
(201, 1001, 500.00, 'Paid'),
(202, 1002, 300.00, 'Unpaid'),
(203, 1003, 700.00, 'Paid'),
(204, 1004, 650.00, 'Paid'),
(205, 1005, 400.00, 'Unpaid');
-- Note: You could add more bills and link them to AdmissionID
