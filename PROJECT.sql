create database JashanEsehat

use JashanEsehat

CREATE TABLE Doctor (
    Dno VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(255),
    Dob DATE,
    Sex CHAR(1),
    Qualifications VARCHAR(255),
    Salary DECIMAL(10, 2),
    Class VARCHAR(255),
    ContactInfo VARCHAR(255)
)

-- Indexing Doctor table on the Dno column
CREATE INDEX IX_Doctor_Dno ON Doctor(Dno);

-- Indexing Doctor table on the BranchID column
CREATE INDEX IX_Doctor_BranchID ON Doctor(BranchID);


ALTER TABLE Doctor
ADD BranchID char(5);

CREATE TABLE Patients (
    Pno VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(255),
    Dob DATE,
    Sex CHAR(1),
    DoctorID VARCHAR(10),
    Disease VARCHAR(255),
    Condition VARCHAR(255),
    ContactInfo VARCHAR(255),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(Dno)
);

-- Indexing Patients table on the Pno column
CREATE INDEX IX_Patients_Pno ON Patients(Pno);

-- Indexing Patients table on the DoctorID column
CREATE INDEX IX_Patients_DoctorID ON Patients(DoctorID);


CREATE TABLE Disease (
    DiseaseID VARCHAR(10) PRIMARY KEY,
    DiseaseSeverity VARCHAR(255),
    Name VARCHAR(255)
);


CREATE TABLE Admin (
    EmpNo VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(255),
    passWord VARCHAR(255)
);

CREATE TABLE Hospital (
    HospitalCode VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(255),
    Address VARCHAR(255),
    ContactInfo VARCHAR(255)
);

CREATE TABLE Medication (
    MedCode VARCHAR(10) PRIMARY KEY,
    Name VARCHAR(255),
    Description VARCHAR(255),
    Cost DECIMAL(10, 2),
    Manufacturer VARCHAR(255)
);

CREATE TABLE Appointment (
    ApptID VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10),
    DoctorID VARCHAR(10),
    Date DATE,
    Time TIME,
    FOREIGN KEY (PatientID) REFERENCES Patients(Pno),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(Dno)
);

-- Indexing Appointment table on the PatientID column
CREATE INDEX IX_Appointment_PatientID ON Appointment(PatientID);

-- Indexing Appointment table on the DoctorID column
CREATE INDEX IX_Appointment_DoctorID ON Appointment(DoctorID);

-- Indexing Appointment table on the Date column
CREATE INDEX IX_Appointment_Date ON Appointment(Date);

-- Indexing Appointment table on the Time column
CREATE INDEX IX_Appointment_Time ON Appointment(Time);


CREATE TABLE Insurance (
    PolicyNo VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10),
    HolderDOB DATE,
    Provider VARCHAR(255),
    PolicyType VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(Pno)
);

-- Indexing Insurance table on the PolicyNo column
CREATE INDEX IX_Insurance_PolicyNo ON Insurance(PolicyNo);

-- Indexing Insurance table on the PatientID column
CREATE INDEX IX_Insurance_PatientID ON Insurance(PatientID);


CREATE TABLE InsuranceDiscount (
    DiscountID VARCHAR(10) PRIMARY KEY,
    InsurancePolicyNo VARCHAR(10),
    DiscountAmount DECIMAL(10, 2),
    DiscountType VARCHAR(255),
    ValidFrom DATE,
    ValidTo DATE,
    FOREIGN KEY (InsurancePolicyNo) REFERENCES Insurance(PolicyNo)
);

CREATE TABLE Prescription (
    PrescriptionID VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10),
    DoctorID VARCHAR(10),
    Date DATE,
    Medication VARCHAR(10),
    Dosage VARCHAR(255),
    Frequency VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(Pno),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(Dno),
    FOREIGN KEY (Medication) REFERENCES Medication(MedCode)
);

CREATE TABLE LabTest (
    TestID VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10),
    DoctorID VARCHAR(10),
    Date DATE,
    TestType VARCHAR(255),
    Results VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(Pno),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(Dno)
);

CREATE TABLE Billing (
    BillID VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10),
    DoctorID VARCHAR(10),
    Date DATE,
    HospitalCode VARCHAR(10),
    TotalAmount DECIMAL(10, 2),
    PaymentStatus VARCHAR(255),
    InsuranceCoverage VARCHAR(10),
    DiscountApplied VARCHAR(10),
    FOREIGN KEY (PatientID) REFERENCES Patients(Pno),
    FOREIGN KEY (InsuranceCoverage) REFERENCES Insurance(PolicyNo),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(Dno),
    FOREIGN KEY (HospitalCode) REFERENCES Hospital(HospitalCode)
);

-- Indexing Billing table on the BillID column
CREATE INDEX IX_Billing_BillID ON Billing(BillID);

-- Indexing Billing table on the PatientID column
CREATE INDEX IX_Billing_PatientID ON Billing(PatientID);

-- Indexing Billing table on the DoctorID column
CREATE INDEX IX_Billing_DoctorID ON Billing(DoctorID);

-- Indexing Billing table on the Date column
CREATE INDEX IX_Billing_Date ON Billing(Date);


CREATE TABLE Surgery (
    SurgeryID VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10),
    DoctorID VARCHAR(10),
    Date DATE,
    Type VARCHAR(255),
    Outcome VARCHAR(255),
    FOREIGN KEY (PatientID) REFERENCES Patients(Pno),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(Dno)
);

-- Indexing Surgery table on the SurgeryID column
CREATE INDEX IX_Surgery_SurgeryID ON Surgery(SurgeryID);

-- Indexing Surgery table on the PatientID column
CREATE INDEX IX_Surgery_PatientID ON Surgery(PatientID);

-- Indexing Surgery table on the DoctorID column
CREATE INDEX IX_Surgery_DoctorID ON Surgery(DoctorID);

-- Indexing Surgery table on the Date column
CREATE INDEX IX_Surgery_Date ON Surgery(Date);


CREATE TABLE MedicalHistory (
    HistoryID VARCHAR(10) PRIMARY KEY,
    PatientID VARCHAR(10),
    Illness VARCHAR(255),
    DiagnosisDate DATE,
    DoctorID VARCHAR(10),
    Outcome VARCHAR(255),
    FollowUpDate DATE,
    FOREIGN KEY (PatientID) REFERENCES Patients(Pno),
    FOREIGN KEY (DoctorID) REFERENCES Doctor(Dno)
);


-- Indexing MedicalHistory table on the HistoryID column
CREATE INDEX IX_MedicalHistory_HistoryID ON MedicalHistory(HistoryID);

-- Indexing MedicalHistory table on the PatientID column
CREATE INDEX IX_MedicalHistory_PatientID ON MedicalHistory(PatientID);

-- Indexing MedicalHistory table on the DoctorID column
CREATE INDEX IX_MedicalHistory_DoctorID ON MedicalHistory(DoctorID);

-- Indexing MedicalHistory table on the DiagnosisDate column
CREATE INDEX IX_MedicalHistory_DiagnosisDate ON MedicalHistory(DiagnosisDate);


-- Doctor table
INSERT INTO Doctor (Dno, Name, Dob, Sex, Qualifications, Salary, Class, ContactInfo, BranchID) VALUES
('D1', 'Dr. John Doe', '1980-05-15', 'M', 'MBBS, MD', 80000.00, 'Senior', '123-456-7890', 'B1'),
('D2', 'Dr. Jane Smith', '1975-12-10', 'F', 'MBBS, MS', 90000.00, 'Senior', '234-567-8901', 'B2'),
('D3', 'Dr. David Johnson', '1990-08-25', 'M', 'MBBS', 60000.00, 'Junior', '345-678-9012', 'B3'),
('D4', 'Dr. Sarah Lee', '1985-03-20', 'F', 'MBBS, MD', 85000.00, 'Senior', '456-789-0123', 'B1'),
('D5', 'Dr. Michael Brown', '1978-11-05', 'M', 'MBBS, MS', 95000.00, 'Senior', '567-890-1234', 'B2');

-- Patients table
INSERT INTO Patients (Pno, Name, Dob, Sex, DoctorID, Disease, Condition, ContactInfo) VALUES
('P1', 'Alice Johnson', '1995-02-28', 'F', 'D3', 'Diabetes', 'Stable', '111-222-3333'),
('P2', 'Bob Smith', '1988-07-12', 'M', 'D1', 'Hypertension', 'Improving', '222-333-4444'),
('P3', 'Eve Brown', '1972-09-20', 'F', 'D2', 'Arthritis', 'Chronic', '333-444-5555'),
('P4', 'Jack Davis', '1980-04-10', 'M', 'D4', 'Asthma', 'Acute', '444-555-6666'),
('P5', 'Mia Wilson', '1990-12-15', 'F', 'D5', 'Migraine', 'Recurring', '555-666-7777');

INSERT INTO Patients (Pno, Name, Dob, Sex, DoctorID, Disease, Condition, ContactInfo) VALUES
('P6', 'James Lee', '1985-06-18', 'M', 'D3', 'Diabetes', 'Stable', '666-777-8888'),
('P7', 'Emily White', '1978-03-25', 'F', 'D1', 'Hypertension', 'Stable', '777-888-9999'),
('P8', 'Oliver Moore', '1965-11-30', 'M', 'D2', 'Arthritis', 'Chronic', '888-999-0000'),
('P9', 'Sophia Anderson', '1982-08-22', 'F', 'D4', 'Asthma', 'Improving', '999-000-1111'),
('P10', 'Daniel Martinez', '1970-01-05', 'M', 'D1', 'Migraine', 'Recurring', '000-111-2222'),
('P11', 'Ava Harris', '1996-09-08', 'F', 'D3', 'Diabetes', 'Stable', '111-222-3333'),
('P12', 'William Clark', '1983-04-14', 'M', 'D1', 'Hypertension', 'Improving', '222-333-4444'),
('P13', 'Ella Rodriguez', '1969-12-02', 'F', 'D2', 'Arthritis', 'Chronic', '333-444-5555'),
('P14', 'Henry Lewis', '1987-07-20', 'M', 'D4', 'Asthma', 'Acute', '444-555-6666'),
('P15', 'Grace King', '1975-02-10', 'F', 'D1', 'Migraine', 'Recurring', '555-666-7777'),
('P16', 'Michael Young', '1980-06-25', 'M', 'D3', 'Diabetes', 'Stable', '666-777-8888'),
('P17', 'Emma Hall', '1977-01-15', 'F', 'D1', 'Hypertension', 'Stable', '777-888-9999'),
('P18', 'Andrew Baker', '1964-08-05', 'M', 'D2', 'Arthritis', 'Chronic', '888-999-0000'),
('P19', 'Samantha Hill', '1981-04-20', 'F', 'D4', 'Asthma', 'Improving', '999-000-1111'),
('P20', 'David Garcia', '1968-11-12', 'M', 'D1', 'Migraine', 'Recurring', '000-111-2222');




-- Disease table
INSERT INTO Disease (DiseaseID, DiseaseSeverity, Name) VALUES
('D1', 'Mild', 'Diabetes'),
('D2', 'Severe', 'Hypertension'),
('D3', 'Chronic', 'Arthritis'),
('D4', 'Acute', 'Asthma'),
('D5', 'Recurring', 'Migraine');

-- Admin table
INSERT INTO Admin (EmpNo, Name, passWord) VALUES
('A1', 'John Doe', 'hello123'),
('A2', 'Admin2', 'hello123'),
('A3', 'Admin3', 'hello123');

-- Hospital table
INSERT INTO Hospital (HospitalCode, Name, Address, ContactInfo) VALUES
('H1', 'City Hospital', '123 Main St, City', '111-222-3333'),
('H2', 'General Hospital', '456 Elm St, Town', '222-333-4444'),
('H3', 'Community Hospital', '789 Oak St, Village', '333-444-5555'),
('H4', 'University Hospital', '101 Pine St, College', '444-555-6666'),
('H5', 'County Hospital', '202 Maple St, County', '555-666-7777');

-- Medication table
INSERT INTO Medication (MedCode, Name, Description, Cost, Manufacturer) VALUES
('M1', 'Aspirin', 'Pain reliever', 10.00, 'ABC Pharmaceuticals'),
('M2', 'Lisinopril', 'Blood pressure medication', 20.00, 'XYZ Pharmaceuticals'),
('M3', 'Metformin', 'Diabetes medication', 15.00, 'DEF Pharmaceuticals'),
('M4', 'Albuterol', 'Asthma inhaler', 30.00, 'GHI Pharmaceuticals'),
('M5', 'Sumatriptan', 'Migraine medication', 25.00, 'JKL Pharmaceuticals');

-- Appointment table
INSERT INTO Appointment (ApptID, PatientID, DoctorID, Date, Time) VALUES
('A1', 'P1', 'D3', '2024-05-01', '10:00:00'),
('A2', 'P2', 'D1', '2024-05-02', '11:00:00'),
('A3', 'P3', 'D2', '2024-05-03', '12:00:00'),
('A4', 'P4', 'D4', '2024-05-04', '13:00:00'),
('A5', 'P5', 'D5', '2024-05-05', '14:00:00');

-- Insurance table
INSERT INTO Insurance (PolicyNo, PatientID, HolderDOB, Provider, PolicyType) VALUES
('I1', 'P1', '1960-01-01', 'InsuranceCo1', 'Health'),
('I2', 'P2', '1970-02-02', 'InsuranceCo2', 'Health'),
('I3', 'P3', '1980-03-03', 'InsuranceCo3', 'Health'),
('I4', 'P4', '1990-04-04', 'InsuranceCo4', 'Health'),
('I5', 'P5', '2000-05-05', 'InsuranceCo5', 'Health');


-- InsuranceDiscount table
INSERT INTO InsuranceDiscount (DiscountID, InsurancePolicyNo, DiscountAmount, DiscountType, ValidFrom, ValidTo) VALUES
('ID1', 'I1', 100.00, 'Annual', '2024-01-01', '2024-12-31'),
('ID2', 'I2', 200.00, 'Annual', '2024-01-01', '2024-12-31'),
('ID3', 'I3', 150.00, 'Annual', '2024-01-01', '2024-12-31'),
('ID4', 'I4', 250.00, 'Annual', '2024-01-01', '2024-12-31'),
('ID5', 'I5', 300.00, 'Annual', '2024-01-01', '2024-12-31');

SELECT * FROM InsuranceDiscount

-- Prescription table
INSERT INTO Prescription (PrescriptionID, PatientID, DoctorID, Date, Medication, Dosage, Frequency) VALUES
('P1', 'P1', 'D3', '2024-05-01', 'M1', '1 tablet', 'Daily'),
('P2', 'P2', 'D1', '2024-05-02', 'M2', '1 tablet', 'Daily'),
('P3', 'P3', 'D2', '2024-05-03', 'M3', '1 tablet', 'Daily'),
('P4', 'P4', 'D4', '2024-05-04', 'M4', '1 puff', 'As needed'),
('P5', 'P5', 'D5', '2024-05-05', 'M5', '1 tablet', 'As needed');

-- LabTest table
INSERT INTO LabTest (TestID, PatientID, DoctorID, Date, TestType, Results) VALUES
('T1', 'P1', 'D3', '2024-05-01', 'Blood Test', 'Normal'),
('T2', 'P2', 'D1', '2024-05-02', 'X-Ray', 'Clear'),
('T3', 'P3', 'D2', '2024-05-03', 'MRI', 'Normal'),
('T4', 'P4', 'D4', '2024-05-04', 'CT Scan', 'Normal'),
('T5', 'P5', 'D5', '2024-05-05', 'Ultrasound', 'Normal');

-- Billing table
INSERT INTO Billing (BillID, PatientID, DoctorID, Date, HospitalCode, TotalAmount, PaymentStatus, InsuranceCoverage, DiscountApplied) VALUES
('B1', 'P1', 'D3', '2024-05-01', 'H1', 1000.00, 'Paid', 'I1', 'ID1'),
('B2', 'P2', 'D1', '2024-05-02', 'H2', 2000.00, 'Unpaid', 'I2', 'ID2'),
('B3', 'P3', 'D2', '2024-05-03', 'H3', 1500.00, 'Paid', 'I3', 'ID3'),
('B4', 'P4', 'D4', '2024-05-04', 'H4', 2500.00, 'Unpaid', 'I4', 'ID4'),
('B5', 'P5', 'D5', '2024-05-05', 'H5', 3000.00, 'Paid', 'I5', 'ID5');

-- Surgery table
INSERT INTO Surgery (SurgeryID, PatientID, DoctorID, Date, Type, Outcome) VALUES
('S1', 'P1', 'D3', '2024-05-01', 'Appendectomy', 'Successful'),
('S2', 'P2', 'D1', '2024-05-02', 'Cholecystectomy', 'Successful'),
('S3', 'P3', 'D2', '2024-05-03', 'Hernia Repair', 'Successful'),
('S4', 'P4', 'D4', '2024-05-04', 'Cataract Surgery', 'Successful'),
('S5', 'P5', 'D5', '2024-05-05', 'Knee Replacement', 'Successful');

-- MedicalHistory table
INSERT INTO MedicalHistory (HistoryID, PatientID, Illness, DiagnosisDate, DoctorID, Outcome, FollowUpDate) VALUES
('MH1', 'P1', 'Diabetes', '2024-01-01', 'D3', 'Stable', '2024-06-01'),
('MH2', 'P2', 'Hypertension', '2024-02-01', 'D1', 'Improving', '2024-07-01'),
('MH3', 'P3', 'Arthritis', '2024-03-01', 'D2', 'Chronic', '2024-08-01'),
('MH4', 'P4', 'Asthma', '2024-04-01', 'D4', 'Acute', '2024-09-01'),
('MH5', 'P5', 'Migraine', '2024-05-01', 'D5', 'Recurring', '2024-10-01');

INSERT INTO MedicalHistory (HistoryID, PatientID, Illness, DiagnosisDate, DoctorID, Outcome, FollowUpDate) VALUES
('MH6', 'P6', 'Fever', '2024-06-15', 'D3', 'Recovered', '2024-07-15'),
('MH7', 'P7', 'Flu', '2024-07-20', 'D1', 'Improving', '2024-08-20'),
('MH8', 'P8', 'Back Pain', '2024-08-25', 'D2', 'Chronic', '2024-09-25'),
('MH9', 'P9', 'Allergies', '2024-09-30', 'D4', 'Stable', '2024-10-30'),
('MH10', 'P10', 'Insomnia', '2024-10-15', 'D1', 'Recurring', '2024-11-15'),
('MH11', 'P11', 'Migraine', '2024-05-25', 'D3', 'Stable', '2024-06-25'),
('MH12', 'P12', 'Headache', '2024-06-10', 'D1', 'Improving', '2024-07-10'),
('MH13', 'P13', 'Joint Pain', '2024-07-15', 'D2', 'Chronic', '2024-08-15'),
('MH14', 'P14', 'Breathing Problems', '2024-08-20', 'D4', 'Acute', '2024-09-20'),
('MH15', 'P15', 'Nausea', '2024-09-25', 'D1', 'Recurring', '2024-10-25'),
('MH16', 'P16', 'Diabetes', '2024-06-15', 'D3', 'Stable', '2024-07-15'),
('MH17', 'P17', 'Hypertension', '2024-07-20', 'D1', 'Improving', '2024-08-20'),
('MH18', 'P18', 'Arthritis', '2024-08-25', 'D2', 'Chronic', '2024-09-25'),
('MH19', 'P19', 'Asthma', '2024-09-30', 'D4', 'Stable', '2024-10-30'),
('MH20', 'P20', 'Migraine', '2024-10-15', 'D1', 'Recurring', '2024-11-15');


CREATE TRIGGER PreventDoctorMultipleBranches
ON Doctor
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    -- Check if the inserted/updated doctor already exists in another branch
    IF EXISTS (
        SELECT 1
        FROM Doctor d
        INNER JOIN inserted i ON d.Dno = i.Dno
        WHERE d.BranchID IS NOT NULL
          AND d.BranchID <> i.BranchID
    )
    BEGIN
        -- Raise an error if the doctor is already registered in another branch
        RAISERROR ('Doctor is already registered in another branch.', 16, 1);
    END
    ELSE
    BEGIN
        -- Perform the insert or update operation if there is no conflict
        IF EXISTS (SELECT 1 FROM inserted)
        BEGIN
            -- If the operation is an insert
            INSERT INTO Doctor (Dno, Name, Dob, Sex, Qualifications, Salary, Class, ContactInfo, BranchID)
            SELECT Dno, Name, Dob, Sex, Qualifications, Salary, Class, ContactInfo, BranchID
            FROM inserted;
        END
        ELSE
        BEGIN
            -- If the operation is an update
            UPDATE d
            SET Name = i.Name,
                Dob = i.Dob,
                Sex = i.Sex,
                Qualifications = i.Qualifications,
                Salary = i.Salary,
                Class = i.Class,
                ContactInfo = i.ContactInfo,
                BranchID = i.BranchID
            FROM Doctor d
            INNER JOIN inserted i ON d.Dno = i.Dno;
        END
    END
END;

-- Attempt to insert a doctor with a conflicting BranchID
INSERT INTO Doctor (Dno, Name, Dob, Sex, Qualifications, Salary, Class, ContactInfo, BranchID)
VALUES ('D7', 'Dr. Emily Brown', '1978-03-12', 'F', 'MBBS, DNB', 110000, 'Cardiologist', 'emily.brown@example.com', 'H3');


select * from Doctor

update Doctor set BranchID = 'H2' where Dno = 'D6'

CREATE TRIGGER CheckHospitalBranchForDoctor
ON Doctor
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    -- Check if the inserted/updated doctor already exists in another branch
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Doctor d ON i.Name = d.Name
        WHERE d.BranchID IS NOT NULL
          AND d.BranchID <> i.BranchID
    )
    BEGIN
        -- Raise an error if the doctor is already registered in another branch
        RAISERROR ('Doctor is already registered in another branch.', 16, 1);
        ROLLBACK TRANSACTION; -- Rollback the transaction to prevent the insert/update
    END
    ELSE
    BEGIN
        -- Perform the insert or update operation if there is no conflict
        IF (SELECT COUNT(*) FROM inserted) > 0
        BEGIN
            -- If the operation is an insert
            INSERT INTO Doctor (Dno, Name, Dob, Sex, Qualifications, Salary, Class, ContactInfo, BranchID)
            SELECT Dno, Name, Dob, Sex, Qualifications, Salary, Class, ContactInfo, BranchID
            FROM inserted;
        END
        ELSE
        BEGIN
            -- If the operation is an update
            UPDATE Doctor
            SET Name = i.Name,
                Dob = i.Dob,
                Sex = i.Sex,
                Qualifications = i.Qualifications,
                Salary = i.Salary,
                Class = i.Class,
                ContactInfo = i.ContactInfo,
                BranchID = i.BranchID
            FROM inserted i
            WHERE Doctor.Dno = i.Dno;
        END
    END
END;


INSERT INTO Doctor (Dno, Name, Dob, Sex, Qualifications, Salary, Class, ContactInfo, BranchID)
VALUES ('D8', 'Dr. Emily Brown', '1978-03-12', 'F', 'MBBS, DNB', 110000, 'Cardiologist', 'emily.brown@example.com', 'H1');



CREATE TRIGGER PreventDoubleBookingForPatient
ON Appointment
INSTEAD OF INSERT
AS
BEGIN
    -- Check if the patient has another appointment at the same date and time with a different doctor
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Appointment a ON i.PatientID = a.PatientID
        WHERE i.Date = a.Date AND i.Time = a.Time AND i.DoctorID <> a.DoctorID
    )
    BEGIN
        -- Raise an error if the patient already has an appointment at the same time with another doctor
        RAISERROR ('Patient already has an appointment at the same time with another doctor.', 16, 1);
        ROLLBACK TRANSACTION; -- Rollback the transaction to prevent the insert
    END
    ELSE
    BEGIN
        -- Perform the insert operation if there is no conflict
        INSERT INTO Appointment (ApptID, PatientID, DoctorID, Date, Time)
        SELECT ApptID, PatientID, DoctorID, Date, Time
        FROM inserted;
    END
END;
GO
select * from Appointment
-- Insert an appointment for a patient with one doctor
INSERT INTO Appointment (ApptID, PatientID, DoctorID, Date, Time)
VALUES ('A6', 'P5', 'D1', '2024-06-01', '09:00:00');

-- Try to insert another appointment for the same patient at the same time with a different doctor
INSERT INTO Appointment (ApptID, PatientID, DoctorID, Date, Time)
VALUES ('A7', 'P5', 'D3', '2024-06-01', '09:00:00');


CREATE TRIGGER CheckInsuranceCoverageBeforeBilling
ON Billing
INSTEAD OF INSERT, UPDATE
AS
BEGIN
    -- Check if the inserted/updated record has valid insurance coverage
    IF EXISTS (
        SELECT 1
        FROM inserted i
        JOIN Insurance ins ON i.InsuranceCoverage = ins.PolicyNo
        WHERE i.Date >= ins.HolderDOB
          AND i.PatientID = ins.PatientID
    )
    BEGIN
        -- Perform the insert or update operation if insurance coverage is valid
        IF EXISTS (SELECT 1 FROM inserted)
        BEGIN
            INSERT INTO Billing (BillID, PatientID, DoctorID, Date, HospitalCode, TotalAmount, PaymentStatus, InsuranceCoverage, DiscountApplied)
            SELECT BillID, PatientID, DoctorID, Date, HospitalCode, TotalAmount, PaymentStatus, InsuranceCoverage, DiscountApplied
            FROM inserted;
        END
        ELSE
        BEGIN
            UPDATE b
            SET PatientID = i.PatientID,
                DoctorID = i.DoctorID,
                Date = i.Date,
                HospitalCode = i.HospitalCode,
                TotalAmount = i.TotalAmount,
                PaymentStatus = i.PaymentStatus,
                InsuranceCoverage = i.InsuranceCoverage,
                DiscountApplied = i.DiscountApplied
            FROM Billing b
            JOIN inserted i ON b.BillID = i.BillID;
        END
    END
    ELSE
    BEGIN
        -- Raise an error if insurance coverage is not valid
        RAISERROR ('Patient does not have valid insurance coverage for the billing date.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO


INSERT INTO Billing (BillID, PatientID, DoctorID, Date, HospitalCode, TotalAmount, PaymentStatus, InsuranceCoverage, DiscountApplied)
VALUES ('B6', 'P6', 'D6', '2024-05-04', 'H4', 2500.00, 'Unpaid', 'I4', 'ID4');

INSERT INTO Billing (BillID, PatientID, DoctorID, Date, HospitalCode, TotalAmount, PaymentStatus, InsuranceCoverage, DiscountApplied)
VALUES ('B7', 'P7', 'D7', '2024-05-05', 'H5', 3000.00, 'Paid', 'I5', 'ID5');


-- Stored Procedure to Get Doctor's Details by BranchID
CREATE PROCEDURE GetDoctorsByBranchID
    @BranchID CHAR(5)
AS
BEGIN
    SELECT Dno, Name, Dob, Sex, Qualifications, Salary, Class, ContactInfo
    FROM Doctor
    WHERE BranchID = @BranchID;
END;
GO

-- Stored Procedure to Get Patient's Medical History
CREATE PROCEDURE GetPatientMedicalHistory
    @PatientID VARCHAR(10)
AS
BEGIN
    SELECT MH.HistoryID, MH.PatientID, MH.Illness, MH.DiagnosisDate, MH.DoctorID, MH.Outcome, MH.FollowUpDate, D.Name AS DoctorName
    FROM MedicalHistory MH
    JOIN Doctor D ON MH.DoctorID = D.Dno
    WHERE MH.PatientID = @PatientID;
END;
GO


-- View for Doctor Information
CREATE VIEW DoctorInfo AS
SELECT D.Dno, D.Name, D.Dob, D.Sex, D.Qualifications, D.Salary, D.Class, D.ContactInfo, B.Name AS BranchName
FROM Doctor D
JOIN Hospital B ON D.BranchID = B.HospitalCode;
GO

-- View for Appointment Schedule
CREATE VIEW AppointmentSchedule AS
SELECT A.ApptID, P.Name AS PatientName, D.Name AS DoctorName, A.Date, A.Time
FROM Appointment A
JOIN Patients P ON A.PatientID = P.Pno
JOIN Doctor D ON A.DoctorID = D.Dno;
GO


ALTER TABLE Doctor
ADD Password VARCHAR(255) DEFAULT 'hello123';

UPDATE Doctor
SET Password = 'hello123';


SELECT * FROM Doctor


ALTER TABLE Patients
ADD Password VARCHAR(255) DEFAULT 'hello123';

UPDATE Patients
SET Password = 'hello123';


SELECT * FROM Patients




