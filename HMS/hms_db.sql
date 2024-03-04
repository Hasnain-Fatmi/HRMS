use hms_db;

select * from users;

select * from landing_doctor;
select * from landing_medicalrecord;
select * from landing_patient;
select * from auth_user;

DELETE FROM landing_doctor;
DELETE FROM landing_medicalrecord;
DELETE FROM auth_user;
DELETE FROM users;
DELETE FROM landing_patient;
drop table landing_patient;

#-------------------------------
CREATE TABLE users (
    First_Name VARCHAR(50) NOT NULL,
    Last_Name VARCHAR(50) NOT NULL,
    Gender VARCHAR(10) NOT NULL,
    Email VARCHAR(50) NOT NULL UNIQUE,
    Role VARCHAR(50) NOT NULL,
    PhoneNum VARCHAR(50) NOT NULL,
    Address VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Password VARCHAR(50) NOT NULL
);

#--------------------------------------------------------------------------

DELIMITER //

CREATE PROCEDURE SignInUser(
    IN p_Email VARCHAR(50),
    IN p_Password VARCHAR(50)
)
BEGIN
    DECLARE user_role VARCHAR(20);

    SELECT Role INTO user_role
    FROM users
    WHERE Email = p_Email AND Password = p_Password;

    IF user_role IS NOT NULL THEN
        SELECT 'Login successful' AS Message, user_role AS Role;
    ELSE
        SELECT 'Invalid credentials' AS Message;
    END IF;
END //

DELIMITER ;

#--------------------------------------------------



DELIMITER //

CREATE PROCEDURE SignUpUser(
    IN p_FirstName VARCHAR(50),
    IN p_LastName VARCHAR(50),
    IN p_Gender VARCHAR(10),
    IN p_Email VARCHAR(50),
    IN p_PhoneNum VARCHAR(50),
    IN p_Address VARCHAR(50),
    IN p_Role VARCHAR(20),
    IN p_DOB DATE,
    IN p_Password VARCHAR(50)
)
BEGIN
    DECLARE email_count INT;

    SELECT COUNT(*) INTO email_count FROM users WHERE Email = p_Email;

    IF email_count > 0 THEN
        SELECT 'Email already exists' AS Message;
    ELSE
        INSERT INTO users (First_Name, Last_Name, Gender, Email, PhoneNum, Address, Role,DOB, Password)
        VALUES (p_FirstName, p_LastName, p_Gender, p_Email, p_PhoneNum, p_Address, p_Role,p_DOB, p_Password);
        SELECT 'User created successfully' AS Message;
    END IF;
END //

DELIMITER ;

#-------------------------------------------------------------

CREATE VIEW SignInView AS
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT * FROM users WHERE Email = users.Email AND Password = users.Password
        ) THEN 'Login successful'
        ELSE 'Invalid credentials'
    END AS Message;
    
CREATE VIEW SignUpView AS
SELECT 
    CASE 
        WHEN EXISTS (
            SELECT * FROM users WHERE Email = users.Email
        ) THEN 'Email already exists'
        ELSE 'User created successfully'
    END AS Message;

CALL SignUpUser('John', 'Doe', 'Male', 'john@example.com', '1234567890', '123 Street', 'User', 'password123');
CALL SignInUser('john@example.com', 'password123');
CREATE TABLE Bill (
    billID INT PRIMARY KEY,
    patientID INT,
    doctorID INT,
    total_amount INT,
    bill_date DATE,
    date_of_service DATE,
    FOREIGN KEY (patientID) REFERENCES Patient(patientID),
    FOREIGN KEY (doctorID) REFERENCES Doctor(doctorID)
);

CREATE TABLE patient (
    patient_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dob DATE,
    gender VARCHAR(10),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE doctor (
    doctor_id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(50),
    contact_number VARCHAR(15),
    email VARCHAR(100),
    address VARCHAR(255)
);


CREATE TABLE appointment (
    appointmentID INT PRIMARY KEY,
    patientID INT,
    doctorID INT,
    date DATE,
    time TIME,
    status VARCHAR(100),
    FOREIGN KEY (patientID) REFERENCES Patient(patientID),
    FOREIGN KEY (doctorID) REFERENCES Doctor(doctorID)
);

CREATE TABLE Department (
    departmentID INT PRIMARY KEY,
    department_name VARCHAR(100)
);

CREATE TABLE Medications (
    medicationID INT PRIMARY KEY,
    medication_name VARCHAR(100),
    manufacturer VARCHAR(100),
    quantity VARCHAR(100),
    price FLOAT
);

CREATE TABLE Prescription (
    prescriptionID INT PRIMARY KEY,
    patientID INT,
    doctorID INT,
    medicationID INT,
    dosage VARCHAR(100),
    duration VARCHAR(100),
    FOREIGN KEY (patientID) REFERENCES Patient(patientID),
    FOREIGN KEY (doctorID) REFERENCES Doctor(doctorID),
    FOREIGN KEY (medicationID) REFERENCES Medications(medicationID)
);

DELIMITER //

CREATE PROCEDURE InsertPatient(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_dob DATE,
    IN p_gender VARCHAR(10),
    IN p_contact_number VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_address VARCHAR(255)
)
BEGIN
    INSERT INTO patient (
        first_name,
        last_name,
        dob,
        gender,
        contact_number,
        email,
        address
    ) VALUES (
        p_first_name,
        p_last_name,
        p_dob,
        p_gender,
        p_contact_number,
        p_email,
        p_address
    );
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeletePatient(IN p_patient_id INT)
BEGIN
    DELETE FROM patient WHERE patient_id = p_patient_id;
END //

DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdatePatient(
    IN p_patient_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_dob DATE,
    IN p_gender VARCHAR(10),
    IN p_contact_number VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_address VARCHAR(255)
)
BEGIN
    UPDATE patient
    SET
        first_name = p_first_name,
        last_name = p_last_name,
        dob = p_dob,
        gender = p_gender,
        contact_number = p_contact_number,
        email = p_email,
        address = p_address
    WHERE
        patient_id = p_patient_id;
END //

DELIMITER;

CREATE VIEW patient_view AS
SELECT
    first_name,
    last_name,
    gender,
    contact_number,
    email,
    address
FROM patient;

CALL InsertPatient(
    'John',
    'Doe',
    '1990-01-15',
    'Male',
    '123-456-7890',
    'john.doe@email.com',
    '123 Main St'
);

CALL DeletePatient(1);

CALL UpdatePatient(
    1,
    'UpdatedFirstName',
    'UpdatedLastName',
    '1995-05-20',
    'Female',
    '987-654-3210',
    'updated.email@email.com',
    '456 Updated St'
);

DELIMITER //

CREATE PROCEDURE InsertDoctor(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_specialization VARCHAR(50),
    IN p_contact_number VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_address VARCHAR(255)
)
BEGIN
    INSERT INTO doctor (
        first_name,
        last_name,
        specialization,
        contact_number,
        email,
        address
    ) VALUES (
        p_first_name,
        p_last_name,
        p_specialization,
        p_contact_number,
        p_email,
        p_address
    );
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE DeleteDoctor(IN p_doctor_id INT)
BEGIN
    DELETE FROM doctor WHERE doctor_id = p_doctor_id;
END //

DELIMITER ;


DELIMITER //

CREATE PROCEDURE UpdateDoctor(
    IN p_doctor_id INT,
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_specialization VARCHAR(50),
    IN p_contact_number VARCHAR(15),
    IN p_email VARCHAR(100),
    IN p_address VARCHAR(255)
)
BEGIN
    UPDATE doctor
    SET
        first_name = p_first_name,
        last_name = p_last_name,
        specialization = p_specialization,
        contact_number = p_contact_number,
        email = p_email,
        address = p_address
    WHERE
        doctor_id = p_doctor_id;
END //

DELIMITER ;

CREATE VIEW doctor_patient_view AS
SELECT
    first_name,
    last_name,
    specialization,
    contact_number,
    email,
    address
FROM doctor;


CALL InsertDoctor(
    'Dr. James',
    'Smith',
    'Cardiologist',
    '987-654-3210',
    'dr.james@email.com',
    '789 Heart St'
);


CALL DeleteDoctor(1); 


CALL UpdateDoctor(
    1,
    'Dr. Updated',
    'Smith',
    'Orthopedic',
    '987-654-3210',
    'updated.doctor@email.com',
    '456 Updated St'
);

DELIMITER //

CREATE PROCEDURE InsertBill(
    IN p_patientID INT,
    IN p_doctorID INT,
    IN p_total_amount INT,
    IN p_bill_date DATE,
    IN p_date_of_service DATE
)
BEGIN
    INSERT INTO Bill (patientID, doctorID, total_amount, bill_date, date_of_service)
    VALUES (p_patientID, p_doctorID, p_total_amount, p_bill_date, p_date_of_service);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeleteBill(IN p_billID INT)
BEGIN
    DELETE FROM Bill WHERE billID = p_billID;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE EditBill(
    IN p_billID INT,
    IN p_patientID INT,
    IN p_doctorID INT,
    IN p_total_amount INT,
    IN p_bill_date DATE,
    IN p_date_of_service DATE
)
BEGIN
    UPDATE Bill
    SET
        patientID = p_patientID,
        doctorID = p_doctorID,
        total_amount = p_total_amount,
        bill_date = p_bill_date,
        date_of_service = p_date_of_service
    WHERE billID = p_billID;
END //

DELIMITER ;

CREATE VIEW BillView AS
SELECT
    b.billID,
    p.patientName,
    d.doctorName,
    b.total_amount,
    b.bill_date,
    b.date_of_service
FROM
    Bill b
    JOIN Patient p ON b.patientID = p.patientID
    JOIN Doctor d ON b.doctorID = d.doctorID;

DELIMITER //

CREATE PROCEDURE InsertAppointment(
    IN p_patientID INT,
    IN p_doctorID INT,
    IN p_date DATE,
    IN p_time TIME,
    IN p_status VARCHAR(100)
)
BEGIN
    INSERT INTO appointment (patientID, doctorID, date, time, status)
    VALUES (p_patientID, p_doctorID, p_date, p_time, p_status);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeleteAppointment(IN p_appointmentID INT)
BEGIN
    DELETE FROM appointment WHERE appointmentID = p_appointmentID;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE EditAppointment(
    IN p_appointmentID INT,
    IN p_patientID INT,
    IN p_doctorID INT,
    IN p_date DATE,
    IN p_time TIME,
    IN p_status VARCHAR(100)
)
BEGIN
    UPDATE appointment
    SET
        patientID = p_patientID,
        doctorID = p_doctorID,
        date = p_date,
        time = p_time,
        status = p_status
    WHERE appointmentID = p_appointmentID;
END //

DELIMITER ;

CREATE VIEW AppointmentView AS
SELECT
    a.appointmentID,
    p.patientName,  
    d.doctorName,  
    a.date,
    a.time,
    a.status
FROM
    appointment a
    JOIN Patient p ON a.patientID = p.patientID
    JOIN Doctor d ON a.doctorID = d.doctorID;

DELIMITER //

CREATE PROCEDURE EditPrescription(
    IN p_prescriptionID INT,
    IN p_patientID INT,
    IN p_doctorID INT,
    IN p_medicationID INT,
    IN p_dosage VARCHAR(100),
    IN p_duration VARCHAR(100)
)
BEGIN
    UPDATE Prescription
    SET
        patientID = p_patientID,
        doctorID = p_doctorID,
        medicationID = p_medicationID,
        dosage = p_dosage,
        duration = p_duration
    WHERE prescriptionID = p_prescriptionID;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeletePrescription(IN p_prescriptionID INT)
BEGIN
    DELETE FROM Prescription WHERE prescriptionID = p_prescriptionID;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE InsertPrescription(
    IN p_patientID INT,
    IN p_doctorID INT,
    IN p_medicationID INT,
    IN p_dosage VARCHAR(100),
    IN p_duration VARCHAR(100)
)
BEGIN
    INSERT INTO Prescription (patientID, doctorID, medicationID, dosage, duration)
    VALUES (p_patientID, p_doctorID, p_medicationID, p_dosage, p_duration);
END //

DELIMITER ;

CREATE VIEW PrescriptionView AS
SELECT
    p.prescriptionID,
    pt.patientName,  
    d.doctorName,  
    m.medication_name,
    p.dosage,
    p.duration
FROM
    Prescription p
    JOIN Patient pt ON p.patientID = pt.patientID
    JOIN Doctor d ON p.doctorID = d.doctorID
    JOIN Medications m ON p.medicationID = m.medicationID;

DELIMITER //

CREATE PROCEDURE InsertDepartment(
    IN p_department_name VARCHAR(100)
)
BEGIN
    INSERT INTO Department (department_name)
    VALUES (p_department_name);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeleteDepartment(IN p_departmentID INT)
BEGIN
    DELETE FROM Department WHERE departmentID = p_departmentID;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE EditDepartment(
    IN p_departmentID INT,
    IN p_department_name VARCHAR(100)
)
BEGIN
    UPDATE Department
    SET
        department_name = p_department_name
    WHERE departmentID = p_departmentID;
END //

DELIMITER ;

CREATE VIEW DepartmentView AS
SELECT
    departmentID,
    department_name
FROM
    Department;

DELIMITER //

CREATE PROCEDURE InsertMedication(
    IN p_medication_name VARCHAR(100),
    IN p_manufacturer VARCHAR(100),
    IN p_quantity VARCHAR(100),
    IN p_price FLOAT
)
BEGIN
    INSERT INTO Medications (medication_name, manufacturer, quantity, price)
    VALUES (p_medication_name, p_manufacturer, p_quantity, p_price);
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE DeleteMedication(IN p_medicationID INT)
BEGIN
    DELETE FROM Medications WHERE medicationID = p_medicationID;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE EditMedication(
    IN p_medicationID INT,
    IN p_medication_name VARCHAR(100),
    IN p_manufacturer VARCHAR(100),
    IN p_quantity VARCHAR(100),
    IN p_price FLOAT
)
BEGIN
    UPDATE Medications
    SET
        medication_name = p_medication_name,
        manufacturer = p_manufacturer,
        quantity = p_quantity,
        price = p_price
    WHERE medicationID = p_medicationID;
END //

DELIMITER ;

CREATE VIEW MedicationsView AS
SELECT
    medicationID,
    medication_name,
    manufacturer,
    quantity,
    price
FROM
    Medications;

CREATE TABLE laboratories (
    LabID INT PRIMARY KEY,
    LabName VARCHAR(255),
    Department VARCHAR(255),
    LabManager VARCHAR(255),
    OpeningTime TIME,
    ClosingTime TIME
);
CREATE TABLE medicines (
    MedicineID INT PRIMARY KEY,
    MedicineName VARCHAR(255),
    Manufacturer VARCHAR(255),
    Quantity INT,
    UnitPrice DECIMAL(10 , 2 )
);
CREATE TABLE tests (
    TestID INT PRIMARY KEY,
    TestName VARCHAR(255),
    LabID INT,
    TurnaroundTime VARCHAR(50),
    TestCharges DECIMAL(10 , 2 ),
    CONSTRAINT FK_Tests_LabID FOREIGN KEY (LabID)
        REFERENCES laboratories (LabID)
);
CREATE TABLE records (
    RecordID INT PRIMARY KEY,
    PatientID INT,
    DoctorID INT,
    Diagnosis TEXT,
    Treatment TEXT,
    CONSTRAINT FK_Records_PatientID FOREIGN KEY (PatientID)
        REFERENCES Patient(patientID),
    CONSTRAINT FK_Records_DoctorID FOREIGN KEY (DoctorID)
        REFERENCES Doctor(doctorID)
);

CREATE TABLE reports (
    ReportID INT PRIMARY KEY AUTO_INCREMENT,
    PatientID INT,
    DoctorID INT,
    TestID INT,
    Results VARCHAR(255),
    CONSTRAINT FK_Reports_TestID FOREIGN KEY (TestID)
        REFERENCES tests (TestID),
    CONSTRAINT FK_Records_PatientID FOREIGN KEY (PatientID)
        REFERENCES Patient(patientID),
    CONSTRAINT FK_Records_DoctorID FOREIGN KEY (DoctorID)
        REFERENCES Doctor(doctorID)
);
DELIMITER //
CREATE PROCEDURE InsertLab(
    IN p_LabID INT,
    IN p_LabName VARCHAR(255),
    IN p_Department VARCHAR(255),
    IN p_LabManager VARCHAR(255),
    IN p_OpeningTime TIME,
    IN p_ClosingTime TIME
)
BEGIN
    INSERT INTO laboratories (LabID, LabName, Department, LabManager, OpeningTime, ClosingTime)
    VALUES (p_LabID, p_LabName, p_Department, p_LabManager, p_OpeningTime, p_ClosingTime);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateLab(
    IN p_LabID INT,
    IN p_LabName VARCHAR(255),
    IN p_Department VARCHAR(255),
    IN p_LabManager VARCHAR(255),
    IN p_OpeningTime TIME,
    IN p_ClosingTime TIME
)
BEGIN
    UPDATE laboratories
    SET LabName = p_LabName, Department = p_Department, LabManager = p_LabManager,
        OpeningTime = p_OpeningTime, ClosingTime = p_ClosingTime
    WHERE LabID = p_LabID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteLab(IN p_LabID INT)
BEGIN
    DELETE FROM laboratories WHERE LabID = p_LabID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertMedicine(
    IN p_MedicineID INT,
    IN p_MedicineName VARCHAR(255),
    IN p_Manufacturer VARCHAR(255),
    IN p_Quantity INT,
    IN p_UnitPrice DECIMAL(10, 2)
)
BEGIN
    INSERT INTO medicines (MedicineID, MedicineName, Manufacturer, Quantity, UnitPrice)
    VALUES (p_MedicineID, p_MedicineName, p_Manufacturer, p_Quantity, p_UnitPrice);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateMedicine(
    IN p_MedicineID INT,
    IN p_MedicineName VARCHAR(255),
    IN p_Manufacturer VARCHAR(255),
    IN p_Quantity INT,
    IN p_UnitPrice DECIMAL(10, 2)
)
BEGIN
    UPDATE medicines
    SET MedicineName = p_MedicineName, Manufacturer = p_Manufacturer,
        Quantity = p_Quantity, UnitPrice = p_UnitPrice
    WHERE MedicineID = p_MedicineID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteMedicine(IN p_MedicineID INT)
BEGIN
    DELETE FROM medicines WHERE MedicineID = p_MedicineID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertTest(
    IN p_TestID INT,
    IN p_TestName VARCHAR(255),
    IN p_LabID INT,
    IN p_TurnaroundTime VARCHAR(50),
    IN p_TestCharges DECIMAL(10, 2)
)
BEGIN
    INSERT INTO tests (TestID, TestName, LabID, TurnaroundTime, TestCharges)
    VALUES (p_TestID, p_TestName, p_LabID, p_TurnaroundTime, p_TestCharges);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateTest(
    IN p_TestID INT,
    IN p_TestName VARCHAR(255),
    IN p_LabID INT,
    IN p_TurnaroundTime VARCHAR(50),
    IN p_TestCharges DECIMAL(10, 2)
)
BEGIN
    UPDATE tests
    SET TestName = p_TestName, LabID = p_LabID,
        TurnaroundTime = p_TurnaroundTime, TestCharges = p_TestCharges
    WHERE TestID = p_TestID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteTest(IN p_TestID INT)
BEGIN
    DELETE FROM tests WHERE TestID = p_TestID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE InsertRecord(
    IN p_RecordID INT,
    IN p_PatientID INT,
    IN p_DoctorID INT,
    IN p_Diagnosis TEXT,
    IN p_Treatment TEXT
)
BEGIN
    INSERT INTO records (RecordID, PatientID, DoctorID, Diagnosis, Treatment)
    VALUES (p_RecordID, p_PatientID, p_DoctorID, p_Diagnosis, p_Treatment);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateRecord(
    IN p_RecordID INT,
    IN p_PatientID INT,
    IN p_DoctorID INT,
    IN p_Diagnosis TEXT,
    IN p_Treatment TEXT
)
BEGIN
    UPDATE records
    SET PatientID = p_PatientID, DoctorID = p_DoctorID,
        Diagnosis = p_Diagnosis, Treatment = p_Treatment
    WHERE RecordID = p_RecordID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteRecord(IN p_RecordID INT)
BEGIN
    DELETE FROM records WHERE RecordID = p_RecordID;
END //
DELIMITER ;

CREATE VIEW RecordsView AS
SELECT r.RecordID, r.Diagnosis, r.Treatment, p.patientName AS PatientName, d.doctorName AS DoctorName
FROM records r
JOIN Patient p ON r.PatientID = p.patientID
JOIN Doctor d ON r.DoctorID = d.doctorID;

DELIMITER //
CREATE PROCEDURE InsertReport(
    IN p_PatientID INT,
    IN p_DoctorID INT,
    IN p_TestID INT,
    IN p_Results VARCHAR(255)
)
BEGIN
    INSERT INTO reports (PatientID, DoctorID, TestID, Results)
    VALUES (p_PatientID, p_DoctorID, p_TestID, p_Results);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DeleteReport(IN p_ReportID INT)
BEGIN
    DELETE FROM reports WHERE ReportID = p_ReportID;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE UpdateReport(
    IN p_ReportID INT,
    IN p_PatientID INT,
    IN p_DoctorID INT,
    IN p_TestID INT,
    IN p_Results VARCHAR(255)
)
BEGIN
    UPDATE reports
    SET PatientID = p_PatientID, DoctorID = p_DoctorID, TestID = p_TestID, Results = p_Results
    WHERE ReportID = p_ReportID;
END //
DELIMITER ;

CREATE VIEW ReportView AS
SELECT r.ReportID, r.PatientID, p.patientName AS PatientName,
       r.DoctorID, d.doctorName AS DoctorName,
       r.Results
FROM reports r
JOIN Patient p ON r.PatientID = p.patientID
JOIN Doctor d ON r.DoctorID = d.doctorID;



CALL InsertRecord(1, 101, 201, 'Diagnosis Info', 'Treatment Info');
CALL UpdateRecord(1, 102, 202, 'Updated Diagnosis', 'Updated Treatment');
CALL DeleteRecord(1);

CALL InsertLab(1, 'LabName1', 'Department1', 'Manager1', '08:00:00', '17:00:00');
CALL UpdateLab(1, 'UpdatedLabName', 'UpdatedDepartment', 'UpdatedManager', '08:30:00', '17:30:00');
CALL DeleteLab(1);

CALL InsertMedicine(1, 'MedicineName1', 'Manufacturer1', 50, 25.00);
CALL UpdateMedicine(1, 'UpdatedMedicineName', 'UpdatedManufacturer', 100, 30.00);
CALL DeleteMedicine(1);

CALL InsertTest(1, 'TestName1', 1, '24 hours', 75.00);
CALL UpdateTest(1, 'UpdatedTestName', 2, '48 hours', 100.00);
CALL DeleteTest(1); 


CALL InsertReport(1, 3, 5, 'Some test results');
CALL UpdateReport(3, 1, 4, 6, 'Updated test results');
CALL DeleteReport(1);
