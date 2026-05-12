DROP SCHEMA IF EXISTS HospitalManagement;
CREATE SCHEMA HospitalManagement;
USE HospitalManagement;

DROP TABLE IF EXISTS `Staff`;

CREATE TABLE IF NOT EXISTS `Staff` (
    `AMKA` CHAR(11) NOT NULL UNIQUE,
    `Staff_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `first_name` VARCHAR(45) NOT NULL,
    `last_name` VARCHAR(45) NOT NULL,
    `date_of_birth` DATE NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(12) NOT NULL,
    `hire_date` DATE NOT NULL,
    `staff_type` VARCHAR(45) NOT NULL CHECK (`staff_type` IN ('Doctor', 'Nurse', 'Administrative Staff')),
    PRIMARY KEY (`AMKA`, `Staff_id`)
);

DROP TABLE IF EXISTS `Department`;

CREATE TABLE IF NOT EXISTS `Department` (
    `department_code` INT NOT NULL UNIQUE,
    `name` VARCHAR(45) NOT NULL UNIQUE,
    `description` VARCHAR(255) NOT NULL,
    `number_of_beds` INT NOT NULL,
    `building_floor` VARCHAR(45) NOT NULL,
    `building` VARCHAR(255) NOT NULL,
    `department_head_AMKA` CHAR(11) UNIQUE,
    PRIMARY KEY (`department_code`)
);

DROP TABLE IF EXISTS `Doctor`;

CREATE TABLE IF NOT EXISTS `Doctor` (
    `AMKA` CHAR(11) NOT NULL,
    `Staff_id` INT NOT NULL,
    `medical_association_license_number` VARCHAR(30) NOT NULL UNIQUE,
    `specialty` VARCHAR(45) NOT NULL,
    `rank` VARCHAR(45) NOT NULL CHECK (`rank` IN ('Intern', 'Registrar', 'Senior Registrar', 'Head Physician')),
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT,
    `consecutive_night_shifts` INT,
    `supervisor_AMKA` CHAR(11) CHECK (`supervisor_AMKA` <> `AMKA`),
    PRIMARY KEY (`AMKA`, `Staff_id`, `department_code`),
    CONSTRAINT `fk_doctor_AMKA` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_Staff_id` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_supervisor` FOREIGN KEY (`supervisor_AMKA`) REFERENCES `Doctor` (`AMKA`) ON DELETE SET NULL,
    CONSTRAINT `fk_doctor_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`)
);

DROP TABLE IF EXISTS `Nurse`;

CREATE TABLE IF NOT EXISTS `Nurse` (
    `AMKA` CHAR(11) NOT NULL UNIQUE,
    `Staff_id` INT NOT NULL UNIQUE,
    `rank` VARCHAR(45) NOT NULL CHECK (`rank` IN ('Assistant Nurse', 'Nurse', 'Head Nurse')),
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT,
    `consecutive_night_shifts` INT,
    PRIMARY KEY (`AMKA`, `Staff_id`),
    CONSTRAINT `fk_nurse_AMKA` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_nurse_Staff_id` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_nurse_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`)
);

DROP TABLE IF EXISTS `Administrative_staff`;

CREATE TABLE IF NOT EXISTS `Administrative_staff` (
    `AMKA` CHAR(11) NOT NULL UNIQUE,
    `Staff_id` INT NOT NULL UNIQUE,
    `role` VARCHAR(45) NOT NULL,
    `office` VARCHAR(45) NOT NULL,
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT,
    `consecutive_night_shifts` INT,
    PRIMARY KEY (`AMKA`, `Staff_id`),
    CONSTRAINT `fk_Admin_Staff` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_Admin_Staff_id` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_Administrator_Department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`)
);

DROP TABLE IF EXISTS `Beds`;

CREATE TABLE IF NOT EXISTS `Beds` (
    `id_number` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `type` VARCHAR(45) NOT NULL,
    `status` VARCHAR(45) NOT NULL CHECK (`status` IN ('Occupied', 'Available', 'Under Maintenance')),
    `department_code` INT NOT NULL,
    PRIMARY KEY (`id_number`),
    CONSTRAINT `fk_Beds_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `Cost_Calculation`;

CREATE TABLE IF NOT EXISTS `Cost_Calculation` (
    `KEN` VARCHAR(5) NOT NULL,
    `base_cost` INT NOT NULL,
    `MDN` INT NOT NULL,    
    PRIMARY KEY (`KEN`)
);

DROP TABLE IF EXISTS `Patient`;

CREATE TABLE IF NOT EXISTS `Patient` (
    `AMKA` CHAR(11) NOT NULL UNIQUE,
    `first_name` VARCHAR(45) NOT NULL,
    `last_name` VARCHAR(45) NOT NULL,
    `fathers_name` VARCHAR(45) NOT NULL,
    `date_of_birth` DATE NOT NULL,
    `sex` VARCHAR(1) NOT NULL,
    `weight` DECIMAL(5,2) NOT NULL,
    `height` DECIMAL(5,2) NOT NULL,
    `address` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(12) NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `occupation` VARCHAR(45) NOT NULL,
    `nationality` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`AMKA`)
);

-- lookup table
DROP TABLE IF EXISTS Diagnoses;

CREATE TABLE IF NOT EXISTS Diagnoses(
    code_idc10 VARCHAR(11) UNIQUE NOT NULL,
    diagnoses_description TEXT NOT NULL,
    PRIMARY KEY(code_idc10)
);


DROP TABLE IF EXISTS `Hospitalization`;

CREATE TABLE IF NOT EXISTS `Hospitalization` (
    `hospitalization_id` INT NOT NULL AUTO_INCREMENT,
    `AMKA` CHAR(11) NOT NULL,
    `department_code` INT NOT NULL,
    `bed_id_number` INT NOT NULL UNIQUE,
    `admission_date` DATE NOT NULL,
    `discharge_date` DATE,
    `KEN` VARCHAR(5) NOT NULL,
    `admission_diagnosis_ICD` VARCHAR(11) NOT NULL,
    `discharge_diagnosis_ICD` VARCHAR(11),
    `admission_diagnosis_description` VARCHAR(255) NOT NULL,
    `discharge_diagnosis_description` VARCHAR(255),
    `hospitalization_cost` DECIMAL(8, 2),
    PRIMARY KEY (`hospitalization_id`,`AMKA`, `admission_date`),
    CONSTRAINT `fk_Hospitalization_AMKA` FOREIGN KEY (`AMKA`) REFERENCES `Patient` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_Hospitalization_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`),
    CONSTRAINT `fk_Hospitalization_cost_calculation` FOREIGN KEY (`KEN`) REFERENCES `Cost_Calculation` (`KEN`),
    CONSTRAINT `fk_Hospitalization_bed` FOREIGN KEY (`bed_id_number`) REFERENCES `Beds` (`id_number`),
    CONSTRAINT `fk_Hospitalization_admission_diagnosis` FOREIGN KEY (`admission_diagnosis_ICD`) REFERENCES `Diagnoses` (code_idc10),
    CONSTRAINT `fk_Hospitalization_discharge_diagnosis` FOREIGN KEY (`discharge_diagnosis_ICD`) REFERENCES `Diagnoses` (code_idc10)
);

DROP TABLE IF EXISTS `Insurance_Type`;

CREATE TABLE IF NOT EXISTS `Insurance_Type`(
    `patient_AMKA` CHAR(11) NOT NULL UNIQUE,
    `insurance_provider` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`patient_AMKA`),
    CONSTRAINT `fk_insurance_type_AMKA` FOREIGN KEY (`patient_AMKA`) REFERENCES `Patient` (`AMKA`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `Shifts`;

CREATE TABLE IF NOT EXISTS `Shifts` (
    `shift_id` INT NOT NULL AUTO_INCREMENT,
    `shift_type` VARCHAR(20) NOT NULL CHECK (`shift_type` IN ('Morning', 'Afternoon', 'Night')),
    `shift_status` VARCHAR(45) CHECK (`shift_status` IN ('Scheduled', 'Draft')),
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
   `start_date` DATE NOT NULL,
   `staff_AMKA` CHAR(11) NOT NULL,
    `staff_id` INT NOT NULL,
    PRIMARY KEY (`shift_id`),
    CONSTRAINT `fk_on_duty_staff` FOREIGN KEY (`staff_AMKA`, `staff_id`) REFERENCES `Staff` (`AMKA`, `Staff_id`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `On_Duty`;

CREATE TABLE IF NOT EXISTS `On_Duty` (
    `on_duty_id` INT NOT NULL AUTO_INCREMENT,
    `department_code` INT NOT NULL,
    `shift_id` INT NOT NULL,
    PRIMARY KEY (`on_duty_id`, `department_code`, `shift_id`),
    CONSTRAINT `fk_on_duty_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`) ON DELETE CASCADE,
    CONSTRAINT `fk_on_duty_shifts` FOREIGN KEY (`shift_id`) REFERENCES `Shifts` (`shift_id`) ON DELETE CASCADE
);

--epeigonta peristatika - dialogh
DROP TABLE IF EXISTS Outcome;

CREATE TABLE IF NOT EXISTS Outcome (
  outcome_id INT NOT NULL AUTO_INCREMENT,
  outcome_description VARCHAR(45) NOT NULL DEFAULT 'Waiting',
  outcome_odhgies TEXT DEFAULT NULL,
  CONSTRAINT chk_outcome_description CHECK (outcome_description in ('Admitted', 'Discharged', 'Waiting')),
  PRIMARY KEY (outcome_id)
);

DROP TABLE IF EXISTS Triage;

CREATE TABLE IF NOT EXISTS Triage (
  triage_id INT NOT NULL AUTO_INCREMENT, 
  patient_AMKA VARCHAR(11) NOT NULL,
  nurse_id VARCHAR(11) NOT NULL,
  arrival_time DATETIME NOT NULL,
  symptoms TEXT NOT NULL, 
  urgency_level INT NOT NULL,
  position INT DEFAULT NULL,
  outcome INT NOT NULL,
  hospitalization_id VARCHAR(11) DEFAULT NULL,
  department VARCHAR(45) NOT NULL,
  PRIMARY KEY(triage_id),
  CONSTRAINT fk_Nurse FOREIGN KEY (nurse_id) REFERENCES Nurse(nurse_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_patient FOREIGN KEY (patient_AMKA) REFERENCES Patient(patient_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_outcome FOREIGN KEY (outcome) REFERENCES Outcome(outcome_id),
  CONSTRAINT fk_triage_hospitalization FOREIGN KEY (hospitalization_id) 
  REFERENCES Hospitalization(hospitalization_id),
  CONSTRAINT fk_department_triage FOREIGN KEY (department) REFERENCES Department(department_id),
  CONSTRAINT chk_urgency_level CHECK(urgency_level in(1,2,3,4,5))
);

--Lab_work

DROP TABLE IF EXISTS Lab_work_info;
--lookup table
--(id: auto inc kathe fora pou vazoume neo eidos ejetashs, lab_type: px aimatologikes, apeikonistikes, cost: einai standard gia kathe ejetash)
CREATE TABLE IF NOT EXISTS Lab_work_info(
  id INT NOT NULL AUTO_INCREMENT,
  lab_code VARCHAR(45) NOT NULL UNIQUE,
  lab_description VARCHAR(255) NOT NULL,
  cost DECIMAL(10,2) NOT NULL, --gia to apo panw mporei to nosokomeio na exei 2 kwdikous gia aimtologikes px aimatologikes 01 kai aimatologikes 02, opote auto apo mono tou na deixnei oti einai alles ejetaseia
  PRIMARY KEY (id)
  );


DROP TABLE IF EXISTS Lab_Work;

CREATE TABLE IF NOT EXISTS Lab_Work(
  lab_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  hospitalization_id VARCHAR(11) NOT NULL,
  lab_type_id INT NOT NULL,
  date_ordered DATETIME NOT NULL,
  ordered_doctor_id VARCHAR(11) NOT NULL,
  lab_result_value DECIMAL(10,3),
  lab_result_units VARCHAR(45),
  lab_result_text TEXT,
  CONSTRAINT fk_lab_hospitalization FOREIGN KEY (hospitalization_id) REFERENCES Hospitalization(hospitalization_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_lab_doctor FOREIGN KEY (ordered_doctor_id) REFERENCES Doctor(doctor_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_lab_type FOREIGN KEY (lab_type_id) REFERENCES Lab_work_info(id) ON DELETE RESTRICT ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Operation_info;
--lookup table
CREATE TABLE IF NOT EXISTS Operation_info(
  id INT NOT NULL AUTO_INCREMENT,
  operation_code VARCHAR(45) NOT NULL UNIQUE,
  operation_name VARCHAR(255) NOT NULL,
  description_text VARCHAR(255),
  category VARCHAR(45) NOT NULL,
  expected_duration INT NOT NULL, 
  cost DECIMAL(10,2) NOT NULL,
  room_type VARCHAR(45) NOT NULL,
  CONSTRAINT chk_room_type CHECK (room_type in ('Χειρουργείο', 'Αίθουσα Επεμβάσεων')),
  CONSTRAINT chk_category CHECK (category in ('Χειρουργική', 'Διαγνωστική', 'Θεραπευτική')),
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS Operation_room;

CREATE TABLE IF NOT EXISTS Operation_room(
  room_id INT NOT NULL AUTO_INCREMENT,
  room_number VARCHAR(11) NOT NULL UNIQUE,
  room_type VARCHAR(45) NOT NULL,
  CONSTRAINT chk_room_type CHECK (room_type in ('Χειρουργείο', 'Αίθουσα Επεμβάσεων')),
  PRIMARY KEY (room_id)
);


DROP TABLE IF EXISTS Operation;

CREATE TABLE IF NOT EXISTS Operation(
  operation_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  hospitalization_id VARCHAR(11) NOT NULL,
  operation_type_id INT NOT NULL,
  start_time DATETIME, 
  expected_end_time DATETIME,
  room_id INT NOT NULL, 
  surgeon_id VARCHAR(11),
  CONSTRAINT fk_operation_hospitalization FOREIGN KEY (hospitalization_id) REFERENCES Hospitalization(hospitalization_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_operation_type FOREIGN KEY (operation_type_id) REFERENCES Operation_info(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_surgeon FOREIGN KEY (surgeon_id) REFERENCES Doctor(doctor_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_operation_room FOREIGN KEY (room_id) REFERENCES Operation_room(room_id) ON DELETE RESTRICT ON UPDATE CASCADE,
  CHECK (start_time < expected_end_time)
);

DROP TABLE IF EXISTS Assistant_Staff;

CREATE TABLE IF NOT EXISTS Assistant_Staff(
  operation_id INT NOT NULL,
  assistant_staff_id VARCHAR(11) NOT NULL,
  PRIMARY KEY (operation_id, assistant_staff_id),
  CONSTRAINT fk_operation FOREIGN KEY (operation_id) REFERENCES Operation(operation_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_assistant_staff FOREIGN KEY (assistant_staff_id) REFERENCES Staff(staff_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE --Tha boruse na bei staff id  
);

--ratings

DROP TABLE IF EXISTS Hospital_Evaluation;

CREATE TABLE IF NOT EXISTS Hospital_Evaluation(
  hospital_evaluation_id INT NOT NULL AUTO_INCREMENT,
  hospitalization_id VARCHAR(11) NOT NULL UNIQUE,
  nurse_qualty INT NOT NULL, --1-5 OPOTE PAEI KAI TINYINT?
  cleanliness INT NOT NULL,
  food_quality INT NOT NULL,
  overall_experience INT NOT NULL,
  eval_date DATETIME NOT NULL, --gia ta triggers logika
  CONSTRAINT fk_hospitalization_evaluation FOREIGN KEY (hospitalization_id) REFERENCES Hospitalization(hospitalization_id) ON DELETE CASCADE ON UPDATE CASCADE,
  PRIMARY KEY (hospital_evaluation_id),
  CHECK (nurse_qualty in (1, 2, 3, 4, 5)),
  CHECK (cleanliness in (1, 2, 3, 4, 5)),
  CHECK (food_quality in (1, 2, 3, 4, 5)),
  CHECK (overall_experience in (1, 2, 3, 4, 5))
);

DROP TABLE IF EXISTS Doctor_Evaluation;

CREATE TABLE IF NOT EXISTS Doctor_Evaluation(
  doctor_evaluation_id INT NOT NULL AUTO_INCREMENT,
  hospitalization_id VARCHAR(11) NOT NULL,
  quality_of_care INT NOT NULL,
  doctor_id VARCHAR(11) NOT NULL,
  UNIQUE(doctor_id, hospitalization_id),
  CONSTRAINT fk_hospitalization_doctor_evaluation FOREIGN KEY (hospitalization_id) REFERENCES Hospitalization(hospitalization_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_doctor_evaluation FOREIGN KEY (doctor_id) REFERENCES Doctor(doctor_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE,
  CHECK (quality_of_care in (1, 2, 3, 4, 5)),
  PRIMARY KEY (doctor_evaluation_id)
);

DROP TABLE IF EXISTS Drug_Info_Active_Substance;
--isws na vgalw to id giati sto prescription exw to product name pou zhtaei h ekfwnhsh
CREATE TABLE IF NOT EXISTS Drug_Info_Active_Substance(
  id INT NOT NULL AUTO_INCREMENT,
  product_name VARCHAR(45) NOT NULL, --prepei na megalwsei to onoma
  active_substance VARCHAR(45) NOT NULL, 
  route_of_administration VARCHAR(255) NOT NULL,
  product_authorization_country VARCHAR(45) NOT NULL,
  marketing_authorization_holder VARCHAR(255) NOT NULL,
  pharmacovigilance_system_master_file_location VARCHAR(255) NOT NULL,
  pharmacovigilance_enquires_email_address VARCHAR(255) NOT NULL,
  pharmacovigilance_enquires_phone_number VARCHAR(255) NOT NULL,
  PRIMARY KEY(id), --or PRIMARY KEY(product_name, country)
  UNIQUE(product_name, active_substance, product_authorization_country)
);

--diaforetikes allergies -> diaforetikes katagrafes
DROP TABLE IF EXISTS Patient_Allergy;

CREATE TABLE IF NOT EXISTS Patient_Allergy(
  allergy_id INT NOT NULL AUTO_INCREMENT,
  patient_id VARCHAR(11) NOT NULL,
  active_subastance_allergy_name VARCHAR(45) NOT NULL,
  PRIMARY KEY(allergy_id),
  CONSTRAINT `fk_patient_id_allergy` FOREIGN KEY (patient_id) REFERENCES Patient(patient_AMKA) ON DELETE CASCADE ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Prescription;

CREATE TABLE IF NOT EXISTS Prescription (
    prescription_id INT NOT NULL AUTO_INCREMENT, ---kalutera int gia na meiwnetai o xronos sugkrishs, varchar pio argo
    hospitalization_id INT NOT NULL,
    dosage VARCHAR(45) NOT NULL,
    frequency VARCHAR(45) NOT NULL,
    starting_date DATETIME NOT NULL,
    end_date DATETIME,
    patient_AMKA CHAR(11) NOT NULL,
    doctor_AMKA CHAR(11) NOT NULL,
    medicine_id INT NOT NULL,
    product_autorization_country VARCHAR(255) NOT NULL,
    UNIQUE(doctor_AMKA, patient_AMKA, medicine_id, starting_date),
    PRIMARY KEY(prescription_id), -- OR PRIMARY KEY(doctor_AMKA, patient_AMKA, medicine_id, starting_date)
    CONSTRAINT `fk_patient_id_prescription` FOREIGN KEY(patient_AMKA) REFERENCES Patient(patient_AMKA),
    CONSTRAINT `fk_doctor_id_prescription` FOREIGN KEY(doctor_AMKA) REFERENCES Doctor(doctor_AMKA),
    CONSTRAINT `fk_medicine_id_prescription` FOREIGN KEY(medicine_id) REFERENCES Drug_Info_Active_Substance(id),
    CONSTRAINT `fk_hospitalization_id_prescription` FOREIGN KEY(hospitalization_id) REFERENCES Hospitalization(hospitalization_id),
    CHECK(starting_date < end_date)
);

DELIMITER $$

DROP TRIGGER IF EXISTS is_doctor_ins;

CREATE TRIGGER `is_doctor_ins` BEFORE INSERT ON `Department`
FOR EACH ROW
BEGIN
    IF (SELECT staff_type FROM Staff WHERE AMKA = NEW.department_head_AMKA) <> 'Doctor' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Department head must be a doctor.';
    END IF; 
END

DROP TRIGGER IF EXISTS is_doctor_upd;

CREATE TRIGGER `is_doctor_upd` BEFORE UPDATE ON `Department`
FOR EACH ROW
BEGIN
    IF (SELECT staff_type FROM Staff WHERE AMKA = NEW.department_head_AMKA) <> 'Doctor' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Department head must be a doctor.';
    END IF; 
END

DROP TRIGGER IF EXISTS check_department_head_ins;

CREATE TRIGGER `check_department_head_ins` BEFORE INSERT ON `Department`
FOR EACH ROW
BEGIN
    DECLARE dept_head CHAR(11);
    SELECT department_head_AMKA INTO dept_head FROM Department WHERE department_code = NEW.department_code;
    
    IF (NEW.department_head_AMKA IS NULL) AND (dept_head IS NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Department head not set. Please assign a doctor as the department head before adding doctors.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_department_head_upd`;

CREATE TRIGGER `check_department_head_upd` BEFORE UPDATE ON `Department`
FOR EACH ROW
BEGIN
    DECLARE dept_head CHAR(11);
    SELECT department_head_AMKA INTO dept_head FROM Department WHERE department_code = NEW.department_code;
    
    IF (NEW.department_head_AMKA IS NULL) AND (dept_head IS NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Error: Department head not set. Please assign a doctor as the department head before adding doctors.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_if_doctor_exists`;

CREATE TRIGGER `check_if_doctor_exists` BEFORE INSERT ON `Doctor`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE AMKA = new.AMKA AND staff_type = 'Doctor') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The AMKA provided does not correspond to an existing staff member. Please insert into "Staff" first.';
    END IF;
END;

DROP TRIGGER IF EXISTS `check_if_nurse_exists`;

CREATE TRIGGER `check_if_nurse_exists` BEFORE INSERT ON `Nurse`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE AMKA = new.AMKA AND staff_type = 'Nurse') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The AMKA provided does not correspond to an existing staff member. Please insert into "Staff" first.';
    END IF;
END;

DROP TRIGGER IF EXISTS `check_if_admin_exists`;

CREATE TRIGGER `check_if_admin_exists` BEFORE INSERT ON `Administrative_staff`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE AMKA = new.AMKA AND staff_type = 'Administrative Staff') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The AMKA provided does not correspond to an existing staff member. Please insert into "Staff" first.';
    END IF;
END;

DROP TRIGGER IF EXISTS `check_is_intern_supervisor`;

CREATE TRIGGER `check_is_intern_supervisor` BEFORE DELETE ON `Doctor`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Doctor WHERE supervisor_AMKA = old.AMKA AND rank = 'Inter') THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot delete a doctor who supervises an intern. Please change the Intern"s supervisor first.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_rank_ins`;

CREATE TRIGGER `check_rank_ins` BEFORE INSERT ON `Doctor`
FOR EACH ROW
BEGIN
    IF (new.rank = 'Intern') AND (new.supervisor_AMKA IS NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Intern doctors must have a supervisor.';
    END IF;
    IF (new.rank = 'Head Physician') AND (new.supervisor_AMKA IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Head Physicians cannot have a supervisor.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_rank_upd`;

CREATE TRIGGER `check_rank_upd` BEFORE UPDATE ON `Doctor`
FOR EACH ROW
BEGIN
    IF (new.rank = 'Intern') AND (new.supervisor_AMKA IS NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Intern doctors must have a supervisor.';
    END IF;
    IF (new.rank = 'Head Physician') AND (new.supervisor_AMKA IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Head Physicians cannot have a supervisor.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_supervision_chain_ins`;

CREATE TRIGGER `check_supervision_chain_ins` BEFORE INSERT ON `Doctor`
FOR EACH ROW
BEGIN
    IF(SELECT AMKA, supervisor_AMKA FROM Doctor WHERE AMKA = new.supervisor_AMKA AND supervisor_AMKA = new.AMKA) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Circular supervision chains are not allowed.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_supervision_chain_upd`;

CREATE TRIGGER `check_supervision_chain_upd` BEFORE UPDATE ON `Doctor`
FOR EACH ROW
BEGIN
    IF(SELECT AMKA, supervisor_AMKA FROM Doctor WHERE AMKA = new.supervisor_AMKA AND supervisor_AMKA = new.AMKA) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Circular supervision chains are not allowed.';
    END IF;
END

DROP TRIGGER IF EXISTS `increase_bed_count`;

CREATE TRIGGER `increase_bed_count` AFTER INSERT ON `Beds`
FOR EACH ROW
BEGIN
    UPDATE Department
    SET number_of_beds = number_of_beds + 1
    WHERE department_code = new.department_code;
END

DROP TRIGGER IF EXISTS `decrease_bed_count`;

CREATE TRIGGER `decrease_bed_count` AFTER DELETE ON `Beds`
FOR EACH ROW
BEGIN
    UPDATE Department
    SET number_of_beds = number_of_beds - 1
    WHERE department_code = old.department_code;
END

DROP TRIGGER IF EXISTS `check_hospitalization_dates_ins`;

CREATE TRIGGER `check_hospitalization_dates_ins` BEFORE INSERT ON `Hospitalization`
FOR EACH ROW
BEGIN
    IF new.admission_date > new.discharge_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Hospitalization admission date must be before discharge date.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_hospitalization_dates_upd`;

CREATE TRIGGER `check_hospitalization_dates_upd` BEFORE UPDATE ON `Hospitalization`
FOR EACH ROW
BEGIN
    IF new.admission_date > new.discharge_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Hospitalization admission date must be before discharge date.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_discharge_data`;

CREATE TRIGGER `check_discharge_data` BEFORE UPDATE ON `Hospitalization`
FOR EACH ROW
BEGIN
    IF new.discharge_date IS NOT NULL AND old.discharge_date IS NULL THEN
        IF new.discharge_diagnosis_ICD IS NULL OR new.discharge_diagnosis_description IS NULL THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Discharge diagnosis code and description must be provided when discharge date is set.';
        END IF;
    END IF;
END

DROP TRIGGER IF EXISTS `set_bed_occupied`;

CREATE TRIGGER `set_bed_occupied` AFTER INSERT ON `Hospitalization`
FOR EACH ROW
BEGIN
    UPDATE Beds
    SET status = 'Occupied'
    WHERE id_number = new.bed_id_number;
END

DROP TRIGGER IF EXISTS `set_bed_available`;

CREATE TRIGGER `set_bed_available` AFTER UPDATE ON `Hospitalization`
FOR EACH ROW
BEGIN
    IF new.discharge_date IS NOT NULL THEN
        UPDATE Beds
        SET status = 'Available'
        WHERE id_number = new.bed_id_number;
    END IF;
END

DROP TRIGGER IF EXISTS `check_bed_availability`;

CREATE TRIGGER `check_bed_availability` BEFORE INSERT ON `Hospitalization`
FOR EACH ROW
BEGIN
    IF (SELECT status FROM Beds where id_number = new.bed_id_number) <> 'Available' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The selected bed is not available.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_medicine_upd`;

CREATE TRIGGER `check_medicine_upd` BEFORE UPDATE ON `Medicine`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code = new.ema_code AND product_name <> new.product_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No two medicines can have the same EMA code but different product names.';
    END IF;
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code <> new.ema_code AND product_name = new.product_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No two medicines can have the same product name but different EMA codes.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_medicine_ins`;

CREATE TRIGGER `check_medicine_ins` BEFORE INSERT ON `Medicine`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code = new.ema_code AND product_name <> new.product_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No two medicines can have the same EMA code but different product names.';
    END IF;
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code <> new.ema_code AND product_name = new.product_name) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'No two medicines can have the same product name but different EMA codes.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_prescription_dates_upd`;

CREATE TRIGGER `check_prescription_dates_upd` BEFORE UPDATE ON `Prescription`
FOR EACH ROW
BEGIN
    IF new.start_date > new.end_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prescription start date must be before end date.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_prescription_dates_ins`;

CREATE TRIGGER `check_prescription_dates_ins` BEFORE INSERT ON `Prescription`
FOR EACH ROW
BEGIN
    IF new.start_date > new.end_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Prescription start date must be before end date.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_allergies_upd`;

CREATE TRIGGER `check_allergies_upd` BEFORE UPDATE ON `Prescription`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT (SELECT medicine_ema_code FROM Allergy WHERE patient_AMKA = new.patient_AMKA)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot Prescribe medicine the patient is allergic to.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_allergies_ins`;

CREATE TRIGGER `check_allergies_ins` BEFORE INSERT ON `Prescription`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT (SELECT medicine_ema_code FROM Allergy WHERE patient_AMKA = new.patient_AMKA)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot Prescribe medicine the patient is allergic to.';
    END IF;
END

DROP FUNCTION IF EXISTS `calculate_shift_members`;

CREATE FUNCTION `calculate_shift_members` (p_shift_id INT, p_start_time TIME, p_start_date DATE) RETURNS TINYINT(1)
BEGIN
    DECLARE doctor_count INT;
    DECLARE nurse_count INT;
    DECLARE admin_count INT;
    DECLARE dept INT;

    SELECT department_code INTO dept FROM On_Duty WHERE shift_id = p_shift_id;

    SELECT COUNT(*) INTO doctor_count FROM Shifts sh JOIN Doctor d ON sh.staff_AMKA = d.AMKA WHERE sh.start_time = p_start_time AND sh.start_date = p_start_date AND d.department_code = dept;
    SELECT COUNT(*) INTO nurse_count FROM Shifts sh JOIN Nurse n ON sh.staff_AMKA = n.AMKA WHERE sh.start_time = p_start_time AND sh.start_date = p_start_date AND n.department_code = dept;
    SELECT COUNT(*) INTO admin_count FROM Shifts sh JOIN Administrative_Staff ad ON sh.staff_AMKA = ad.AMKA WHERE sh.start_time = p_start_time AND sh.start_date = p_start_date AND ad.department_code = dept;
    IF doctor_count >= 3 AND nurse_count >= 6 AND admin_count >= 2 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END

DROP FUNCTION IF EXISTS `exists_senior_doctor`;

CREATE FUNCTION `exists_senior_doctor`(p_start_time TIME, p_start_date DATE, p_dept_code INT) RETURNS TINYINT(1)
BEGIN
    DECLARE senior_doctor_count INT;

    SELECT COUNT(*) INTO senior_doctor_count
    FROM Shifts s
    JOIN Doctor d ON s.staff_id = d.Staff_id
    WHERE s.start_time = p_start_time AND s.start_date = p_start_date AND d.rank IN ('Senior Registrar', 'Head Physician') AND d.department_code = p_dept_code;

    IF senior_doctor_count >= 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END

DROP FUNCTION IF EXISTS `is_intern`;

CREATE FUNCTION `is_intern` (p_staff_id INT) RETURNS TINYINT(1)
BEGIN
      IF (SELECT rank FROM Doctor WHERE Staff_id = p_staff_id) = 'Intern' THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END

DROP FUNCTION IF EXISTS `f_check_for_senior_doctor`;

CREATE FUNCTION `f_check_for_senior_doctor`(p_staff_id INT, p_start_time TIME, p_start_date DATE, p_dept_code INT) RETURNS TINYINT(1)
BEGIN
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = p_staff_id;

    IF s_type <> 'Doctor' THEN
        RETURN TRUE;
    END IF;

    IF NOT is_intern(p_staff_id) THEN
        RETURN TRUE;
    END IF;

    RETURN exists_senior_doctor(p_start_time, p_start_date, p_dept_code);
END

DROP TRIGGER IF EXISTS `update_shift_count_ins`;

CREATE TRIGGER `update_shift_count_ins` AFTER INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA; 

    IF (SELECT shift_status FROM Shifts WHERE shift_id = NEW.shift_id) = 'Scheduled' THEN
        IF s_type = 'Doctor' THEN
            UPDATE Doctor
            SET monthly_shifts_worked = IFNULL(monthly_shifts_worked, 0) + 1,
                consecutive_night_shifts = 
                    CASE WHEN NEW.shift_type = 'Night' 
                        THEN IFNULL(consecutive_night_shifts, 0) + 1
                        ELSE 0
                    END CASE;
            WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        ELSEIF s_type = 'Nurse' THEN
            UPDATE Nurse
            SET monthly_shifts_worked = IFNULL(monthly_shifts_worked, 0) + 1,
                consecutive_night_shifts = 
                    CASE WHEN NEW.shift_type = 'Night' 
                        THEN IFNULL(consecutive_night_shifts, 0) + 1
                        ELSE 0
                    END CASE;
            WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        ELSEIF s_type = 'Administrative Staff' THEN
            UPDATE Administrative_Staff
            SET monthly_shifts_worked = IFNULL(monthly_shifts_worked, 0) + 1,
                consecutive_night_shifts = 
                    CASE WHEN NEW.shift_type = 'Night' 
                        THEN IFNULL(consecutive_night_shifts, 0) + 1
                        ELSE 0
                    END CASE;
            WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        END IF; 
    END IF;
END

DROP TRIGGER IF EXISTS `update_shift_count_upd`;

CREATE TRIGGER `update_shift_count_upd` AFTER UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA; 

    IF (SELECT shift_status FROM Shifts WHERE shift_id = NEW.shift_id) = 'Scheduled' THEN
        IF s_type = 'Doctor' THEN
            UPDATE Doctor
            SET monthly_shifts_worked = IFNULL(monthly_shifts_worked, 0) + 1,
                consecutive_night_shifts = 
                    CASE WHEN NEW.shift_type = 'Night' 
                        THEN IFNULL(consecutive_night_shifts, 0) + 1
                        ELSE 0
                    END CASE;
            WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        ELSEIF s_type = 'Nurse' THEN
            UPDATE Nurse
            SET monthly_shifts_worked = IFNULL(monthly_shifts_worked, 0) + 1,
                consecutive_night_shifts = 
                    CASE WHEN NEW.shift_type = 'Night' 
                        THEN IFNULL(consecutive_night_shifts, 0) + 1
                        ELSE 0
                    END CASE;
            WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        ELSEIF s_type = 'Administrative Staff' THEN
            UPDATE Administrative_Staff
            SET monthly_shifts_worked = IFNULL(monthly_shifts_worked, 0) + 1,
                consecutive_night_shifts = 
                    CASE WHEN NEW.shift_type = 'Night' 
                        THEN IFNULL(consecutive_night_shifts, 0) + 1
                        ELSE 0
                    END CASE;
            WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        END IF; 
    END IF;
END 

DROP TRIGGER IF EXISTS `schedule_shift_on_duty_ins`;

CREATE TRIGGER `schedule_shift_on_duty_ins` AFTER INSERT ON `On_Duty`
FOR EACH ROW
BEGIN
    IF calculate_shift_members(NEW.shift_id, NEW.start_time, NEW.start_date) THEN
        UPDATE Shifts
        SET shift_status = 'Scheduled'
        WHERE start_time = NEW.start_time AND start_date = NEW.start_date AND shift_id IN (SELECT shift_id FROM On_duty WHERE department_code = dept);
    END IF;
END

DROP TRIGGER IF EXISTS `schedule_shift_on_duty_upd`;

CREATE TRIGGER `schedule_shift_on_duty_upd` AFTER UPDATE ON `On_Duty`
FOR EACH ROW
BEGIN
    IF calculate_shift_members(NEW.shift_id, NEW.start_time, NEW.start_date) THEN
        UPDATE Shifts
        SET shift_status = 'Scheduled'
        WHERE start_time = NEW.start_time AND start_date = NEW.start_date AND shift_id IN (SELECT shift_id FROM On_duty WHERE department_code = dept);
    END IF;
END

DROP TRIGGER IF EXISTS `check_for_senior_doctor_upd`;

CREATE TRIGGER `check_for_senior_doctor_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE v_dept INT;
    SELECT department_code INTO v_dept FROM Doctor WHERE AMKA = NEW.staff_AMKA;

    IF NOT f_check_for_senior_doctor(NEW.staff_id, NEW.start_time, NEW.start_date, v_dept) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add an Intern Doctor to a shift without atleast one Senior Registrar or Head Physician present.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_for_senior_doctor_ins`;

CREATE TRIGGER `check_for_senior_doctor_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE v_dept INT;
    SELECT department_code INTO v_dept FROM Doctor WHERE AMKA = NEW.staff_AMKA;

    IF NOT f_check_for_senior_doctor(NEW.staff_id, NEW.start_time, NEW.start_date, v_dept) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot add an Intern Doctor to a shift without atleast one Senior Registrar or Head Physician present.';
    END IF;
END

DROP TRIGGER IF EXISTS `set_shift_validity_ins`;

CREATE TRIGGER `set_shift_validity_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    IF CURDATE() > NEW.start_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Shift start date cannot be in the past.';
    END IF;

    SET NEW.shift_status = 'Draft';
END

DROP TRIGGER IF EXISTS `set_shift_validity_upd`;

CREATE TRIGGER `set_shift_validity_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    IF CURDATE() > NEW.start_date THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Shift start date cannot be in the past.';
    END IF;
    
    SET NEW.shift_status = 'Draft';
END

DROP TRIGGER IF EXISTS `check_max_shifts_upd`;

CREATE TRIGGER `check_max_shifts_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE last_shift_date DATE;
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    SELECT MAX(start_date) INTO last_shift_date FROM Shifts WHERE staff_AMKA = NEW.staff_AMKA AND staff_id = NEW.staff_id;

    IF last_shift_date IS NOT NULL AND (MONTH(last_shift_date) <> MONTH(NEW.start_date) OR YEAR(last_shift_date) <> YEAR(NEW.start_date)) THEN
        CASE 
            WHEN s_type = 'Doctor' THEN UPDATE Doctor SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
            WHEN s_type = 'Nurse' THEN UPDATE Nurse SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
            ELSE UPDATE Administrative_Staff SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        END CASE;     
    END IF;    
    
    CASE
        WHEN s_type = 'Doctor' THEN
            IF (SELECT monthly_shifts_worked FROM Doctor WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 15 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A doctor cannot work more than 15 shifts per month.';
            END IF;
        WHEN s_type = 'Nurse' THEN
            IF (SELECT monthly_shifts_worked FROM Nurse WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 20 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A nurse cannot work more than 20 shifts per month.';
            END IF;
        WHEN s_type = 'Administrative Staff' THEN
            IF (SELECT monthly_shifts_worked FROM Administrative_staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 25 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'An administrative staff member cannot work more than 25 shifts per month.';
            END IF; 
    END CASE;    
END

DROP TRIGGER IF EXISTS `check_max_shifts_ins`;

CREATE TRIGGER `check_max_shifts_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE last_shift_date DATE;
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    SELECT MAX(start_date) INTO last_shift_date FROM Shifts WHERE staff_AMKA = NEW.staff_AMKA AND staff_id = NEW.staff_id;

   IF last_shift_date IS NOT NULL AND (MONTH(last_shift_date) <> MONTH(NEW.start_date) OR YEAR(last_shift_date) <> YEAR(NEW.start_date)) THEN
        CASE 
            WHEN s_type = 'Doctor' THEN UPDATE Doctor SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
            WHEN s_type = 'Nurse' THEN UPDATE Nurse SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
            ELSE UPDATE Administrative_Staff SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        END CASE;       
    END IF;
    
    CASE
        WHEN s_type = 'Doctor' THEN
            IF (SELECT monthly_shifts_worked FROM Doctor WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 15 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A doctor cannot work more than 15 shifts per month.';
            END IF;
        WHEN s_type = 'Nurse' THEN
            IF (SELECT monthly_shifts_worked FROM Nurse WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 20 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A nurse cannot work more than 20 shifts per month.';
            END IF;
        WHEN s_type = 'Administrative Staff' THEN
            IF (SELECT monthly_shifts_worked FROM Administrative_staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 25 THEN
                SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'An administrative staff member cannot work more than 25 shifts per month.';
            END IF; 
    END CASE;   
END

DROP TRIGGER IF EXISTS `check_if_shift_exists`;

CREATE TRIGGER `check_if_shift_exists` BEFORE INSERT ON `On_Duty`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Shifts WHERE NEW.shift_id = shift_id) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The shift_id provided does not correspond to an existing shift. Please insert into "Shifts" first.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_shift_type_ins`;

CREATE TRIGGER `check_shift_type_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW FOLLOWS `set_shift_validity_ins` PRECEDES `check_night_shift_validity_ins`
BEGIN
    IF HOUR(NEW.start_time) >= 7 AND HOUR(NEW.start_time) < 15 THEN
        SET NEW.shift_type = 'Morning';
    ELSEIF HOUR(NEW.start_time) >= 15 AND HOUR(NEW.start_time) < 23 THEN
        SET NEW.shift_type = 'Afternoon';
    ELSEIF HOUR(NEW.start_time) = 23 OR HOUR(NEW.start_time) < 7 THEN
        SET NEW.shift_type = 'Night';
    ELSE
        SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Invalid start time for shift. Please ensure the start time falls within the defined shift hours.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_shift_type_upd`;

CREATE TRIGGER `check_shift_type_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW FOLLOWS `set_shift_validity_upd` PRECEDES `check_night_shift_validity_upd`
BEGIN
    IF HOUR(NEW.start_time) >= 7 AND HOUR(NEW.start_time) < 15 THEN
        SET NEW.shift_type = 'Morning';
    ELSEIF HOUR(NEW.start_time) >= 15 AND HOUR(NEW.start_time) < 23 THEN
        SET NEW.shift_type = 'Afternoon';
    ELSEIF HOUR(NEW.start_time) = 23 OR HOUR(NEW.start_time) < 7 THEN
        SET NEW.shift_type = 'Night';
    ELSE
        SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Invalid start time for shift. Please ensure the start time falls within the defined shift hours.';
    END IF;
END

DROP TRIGGER IF EXISTS `check_consecutive_shifts_ins`;

CREATE TRIGGER `check_consecutive_shifts_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE last_shift DATETIME;

    SELECT TIMESTAMP(start_date, end_time) INTO last_shift FROM Shifts WHERE staff_id = NEW.staff_id AND staff_AMKA = NEW.staff_AMKA AND TIMESTAMP(start_date, end_time) < TIMESTAMP(NEW.start_date, NEW.start_time) ORDER BY TIMESTAMP(start_date, end_time) DESC LIMIT 1;

    IF last_shift IS NOT NULL THEN
        IF TIMESTAMPDIFF(HOUR, last_shift, TIMESTAMP(NEW.start_date, NEW.start_time)) < 8 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Could not register shift: an 8-hour rest is required between shifts.';
        END IF;
    END IF;
END

DROP TRIGGER IF EXISTS `check_consecutive_shifts_upd`;

CREATE TRIGGER `check_consecutive_shifts_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE last_shift DATETIME;

    SELECT TIMESTAMP(start_date, end_time) INTO last_shift FROM Shifts WHERE staff_id = NEW.staff_id AND staff_AMKA = NEW.staff_AMKA AND shift_id <> NEW.shift_id AND TIMESTAMP(start_date, end_time) < TIMESTAMP(NEW.start_date, NEW.start_time) ORDER BY TIMESTAMP(start_date, end_time) DESC LIMIT 1;

    IF last_shift IS NOT NULL THEN
        IF TIMESTAMPDIFF(HOUR, last_shift, TIMESTAMP(NEW.start_date, NEW.start_time)) < 8 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Could not register shift: an 8-hour rest is required between shifts.';
        END IF;
    END IF;
END

DROP TRIGGER IF EXISTS `check_night_shift_validity_ins`;

CREATE TRIGGER `check_night_shift_validity_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW FOLLOWS `check_shift_type_ins`
BEGIN
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    
    IF NEW.shift_type = 'Night' THEN
        CASE
            WHEN s_type = 'Doctor' THEN 
                IF (SELECT consecutive_night_shifts FROM Doctor WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Doctors cannot work more than 3 consecutive night shifts.';
                END IF;
            WHEN s_type = 'Nurse' THEN
                IF (SELECT consecutive_night_shifts FROM Nurse WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Nurses cannot work more than 3 consecutive night shifts.';
                END IF;
            WHEN s_type = 'Administrative Staff' THEN
                IF (SELECT consecutive_night_shifts FROM Administrative_Staff WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Administrative Staff cannot work more than 3 consecutive night shifts.';
                END IF;
        END CASE;
    END IF;    
END

DROP TRIGGER IF EXISTS `check_night_shift_validity_upd`;

CREATE TRIGGER `check_night_shift_validity_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW FOLLOWS `check_shift_type_upd`
BEGIN
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    
    IF NEW.shift_type = 'Night' THEN
        CASE
            WHEN s_type = 'Doctor' THEN 
                IF (SELECT consecutive_night_shifts FROM Doctor WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Doctors cannot work more than 3 consecutive night shifts.';
                END IF;
            WHEN s_type = 'Nurse' THEN
                IF (SELECT consecutive_night_shifts FROM Nurse WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Nurses cannot work more than 3 consecutive night shifts.';
                END IF;
            WHEN s_type = 'Administrative Staff' THEN
                IF (SELECT consecutive_night_shifts FROM Administrative_Staff WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000'
                        SET MESSAGE_TEXT = 'Administrative Staff cannot work more than 3 consecutive night shifts.';
                END IF;
        END CASE;
    END IF;    
END

DROP TRIGGER IF EXISTS `reschedule_shift_del`;

CREATE TRIGGER `reschedule_shift_del` AFTER DELETE ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE v_dept INT;
    DECLARE s_type VARCHAR(45);

    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = OLD.staff_id AND AMKA = OLD.staff_AMKA; 
    SELECT department_code INTO v_dept FROM On_Duty WHERE shift_id = OLD.shift_id;

    IF NOT calculate_shift_members(OLD.shift_id, OLD.start_time, OLD.start_date) THEN
        UPDATE Shifts
        SET shift_status = 'Draft'
        WHERE start_time = OLD.start_time AND start_date = OLD.start_date AND shift_id IN (SELECT shift_id FROM On_duty WHERE department_code = v_dept);
    END IF;

    IF s_type = 'Doctor' THEN
        UPDATE Doctor
        SET monthly_shifts_worked = monthly_shifts_worked - 1,
            consecutive_night_shifts = 
                CASE WHEN OLD.shift_type = 'Night' 
                    THEN consecutive_night_shifts - 1
                    ELSE calculate_consecutive_night_shifts(OLD.staff_id, OLD.start_date)
                END CASE;
        WHERE staff_id = OLD.staff_id AND AMKA = OLD.staff_AMKA;
    ELSEIF s_type = 'Nurse' THEN
        UPDATE Nurse
        SET monthly_shifts_worked = monthly_shifts_worked - 1,
            consecutive_night_shifts = 
                CASE WHEN OLD.shift_type = 'Night' 
                    THEN consecutive_night_shifts - 1
                    ELSE calculate_consecutive_night_shifts(OLD.staff_id, OLD.start_date)
                END CASE;
        WHERE staff_id = OLD.staff_id AND AMKA = OLD.staff_AMKA;
    ELSEIF s_type = 'Administrative Staff' THEN
        UPDATE Administrative_Staff
        SET monthly_shifts_worked = monthly_shifts_worked - 1,
            consecutive_night_shifts = 
                CASE WHEN OLD.shift_type = 'Night' 
                    THEN consecutive_night_shifts - 1
                    ELSE calculate_consecutive_night_shifts(OLD.staff_id, OLD.start_date)
                END CASE;
        WHERE staff_id = OLD.staff_id AND AMKA = OLD.staff_AMKA;
    END IF; 
END

DROP FUNCTION IF EXISTS `calculate_consecutive_night_shifts`;

CREATE FUNCTION `calculate_consecutive_night_shifts`(p_staff_id INT, p_start_date DATE) RETURNS INT
BEGIN
    DECLARE v_count INT;
    DECLARE v_last_non_night_shift DATE;
    SELECT MAX(start_date) INTO v_last_non_night_shift FROM Shifts WHERE staff_id = p_staff_id AND shift_type <> 'Night'AND start_date < p_start_date;
    SELECT COUNT(*) INTO v_count FROM Shifts WHERE staff_id = p_staff_id AND start_date < p_start_date AND (v_last_non_night_shift IS NULL OR start_date > v_last_non_night_shift) AND shift_type = 'Night';
    RETURN v_count;
END

DROP TRIGGER IF EXISTS `calculate_total_cost`;

CREATE TRIGGER `calculate_total_cost` BEFORE UPDATE ON `Hospitalization`
FOR EACH ROW
BEGIN
    DECLARE v_total_hospitalization_days DATE;
    DECLARE v_mdn INT;
    DECLARE v_base_cost DECIMAL(10, 2);
    DECLARE v_daily_cost DECIMAL(10, 2);
    DECLARE v_lab_costs DECIMAL(10, 2);
    DECLARE v_operation_costs DECIMAL(10, 2);

    SELECT MDN INTO v_mdn FROM Cost_Calculation WHERE KEN = NEW.KEN;
    SELECT base_cost INTO v_base_cost FROM Cost_Calculation WHERE KEN = NEW.KEN;
    SELECT SUM(cost) INTO v_lab_costs FROM Lab_work_info WHERE id IN (SELECT lab_id FROM Lab_Work WHERE hospitalization_id = NEW.hospitalization.id); 
    SELECT SUM(cost) INTO v_operation_costs FROM Operation_Info WHERE id IN (SELECT operation_type FROM Operation WHERE hospitalization_id = NEW.hospitalization_id);

    SET v_total_hospitalization = DATEDIFF(NEW.discharge_date - NEW.admission_date);
    SET V_daily_cost = v_base_cost / v_mdn;

    IF NEW.total_hospitalization_days = v_mdn THEN
        SET hospitalization_cost = v_base_cost + IFNULL(v_lab_costs, 0) + IFNULL(v_operation_costs, 0) WHERE KEN = NEW.KEN;
    ELSE
        SET hospitalization_cost = v_base_cost + (v_total_hospitalization_days - v_mdn) * v_daily_cost/2 + IFNULL(v_lab_costs, 0) + IFNULL(v_operation_costs, 0) WHERE KEN = NEW.KEN;
    END IF;
END

CREATE TRIGGER `check_if_on_call_surgeon_ins` BEFORE INSERT ON `Operation`
FOR EACH ROW
BEGIN
    DECLARE v_shift_date DATE;
    DECLARE v_shift_start TIME;
    DECLARE v_shift_end TIME;

    SELECT start_date, start_time, end_time INTO v_shift_date, v_shift_start, v_shift_end FROM Shifts WHERE staff_AMKA = NEW.sugeon_id ORDER BY timestamp DESC LIMIT 1;

    IF v_shift_date IS NOT NULL AND v_shift_start IS NOT NULL AND v_shift_end IS NOT NULL THEN
        IF v_shift_date <> DATE(NEW.start_time) OR v_shift_start > TIME(NEW.start_time) OR v_shift_end < TIME(NEW.expected_end_time) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'The assigned surgeon must have a shift registered at the time of the operation.';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The specified surgeon does not have registered shifts.';
    END IF;
END 

CREATE TRIGGER `check_if_on_call_surgeon_upd` BEFORE UPDATE ON `Operation`
FOR EACH ROW
BEGIN
    DECLARE v_shift_date DATE;
    DECLARE v_shift_start TIME;
    DECLARE v_shift_end TIME;

    SELECT start_date, start_time, end_time INTO v_shift_date, v_shift_start, v_shift_end FROM Shifts WHERE staff_AMKA = NEW.sugeon_id ORDER BY timestamp DESC LIMIT 1;

    IF v_shift_date IS NOT NULL AND v_shift_start IS NOT NULL AND v_shift_end IS NOT NULL THEN
        IF v_shift_date <> DATE(NEW.start_time) OR v_shift_start > TIME(NEW.start_time) OR v_shift_end < TIME(NEW.expected_end_time) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'The assigned surgeon must have a shift registered at the time of the operation.';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The specified surgeon does not have registered shifts.';
    END IF;
END 

CREATE TRIGGER `check_if_on_call_staff_ins` BEFORE INSERT ON `Assistant_Staff`
FOR EACH ROW
BEGIN
    DECLARE v_shift_date DATE;
    DECLARE v_shift_start TIME;
    DECLARE v_shift_end TIME;

    SELECT start_date, start_time, end_time INTO v_shift_date, v_shift_start, v_shift_end FROM Shifts WHERE staff_AMKA = NEW.assistant_staff_id ORDER BY timestamp DESC LIMIT 1;

    IF v_shift_date IS NOT NULL AND v_shift_start IS NOT NULL AND v_shift_end IS NOT NULL THEN
        IF v_shift_date <> DATE(NEW.start_time) OR v_shift_start > TIME(NEW.start_time) OR v_shift_end < TIME(NEW.expected_end_time) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'The assigned staff must have a shift registered at the time of the operation.';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The specified staff member does not have registered shifts.';
    END IF;
END 

CREATE TRIGGER `check_if_on_call_staff_upd` BEFORE UPDATE ON `Assistant_Staff`
FOR EACH ROW
BEGIN
    DECLARE v_shift_date DATE;
    DECLARE v_shift_start TIME;
    DECLARE v_shift_end TIME;

    SELECT start_date, start_time, end_time INTO v_shift_date, v_shift_start, v_shift_end FROM Shifts WHERE staff_AMKA = NEW.assistant_staff_id ORDER BY timestamp DESC LIMIT 1;

    IF v_shift_date IS NOT NULL AND v_shift_start IS NOT NULL AND v_shift_end IS NOT NULL THEN
        IF v_shift_date <> DATE(NEW.start_time) OR v_shift_start > TIME(NEW.start_time) OR v_shift_end < TIME(NEW.expected_end_time) THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'The assigned staff must have a shift registered at the time of the operation.';
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'The specified staff member does not have registered shifts.';
    END IF;
END 

--CHECK POSITION BEFORE INSERT
CREATE TRIGGER calculate_position_triage BEFORE INSERT ON Triage
FOR EACH ROW
BEGIN
    DECLARE queue_length INT DEFAULT 0;
    SELECT COUNT(*) + 1 INTO queue_length FROM Triage tr JOIN Outcome outc ON tr.outcome_id = outc.outcome_id 
    WHERE outc.outcome_name = 'Waiting' AND (tr.urgency_level < NEW.urgency_level) OR ((tr.urgency_level = NEW.urgency_level) AND (tr.arrival_time < NEW.arrival_time));
    SET NEW.position = queue_length;
END$$
  
--CHECK POSITION AFTER UPDATE
CREATE TRIGGER calculate_position_triage_upd AFTER UPDATE ON Triage
FOR EACH ROW
BEGIN
    DECLARE old_outcome VARCHAR(45);
    DECLARE new_outcome VARCHAR(45);
    SELECT outcome_name INTO old_outcome FROM Outcome WHERE outcome_id = OLD.outcome_id;
    SELECT outcome_name INTO new_outcome FROM Outcome WHERE outcome_id = new.outcome_id;
    IF old_outcome = 'Waiting' AND new_outcome != 'Waiting' THEN
        UPDATE Triage tr JOIN Outcome outc ON tr.outcome_id = outc.outcome_id SET tr.position = tr.position -1
        WHERE outc.outcome_name = 'Waiting' AND tr.urgency_level = OLD.urgency_level AND tr.position > OLD.position;
    END IF;
END$$

CREATE TRIGGER finished_hospitalization_evaluation BEFORE INSERT ON Hospital_Evaluation
FOR EACH ROW
BEGIN
    DECLARE discharge_date DATE;
    SELECT discharge_date INTO discharge_date FROM Hospitalization WHERE hospitalization_id = NEW.hospitalization_id;
    IF discharge_date IS NULL
    OR discharge_date > NEW.eval_date THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Cannot evaluate hospital experience before discharge';
    END IF;
END$$

CREATE TRIGGER finished_doctor_evaluation BEFORE INSERT ON Doctor_Evaluation
FOR EACH ROW
BEGIN
  DECLARE discharge_date DATE;
  SELECT discharge_date INTO discharge_date FROM Hospitalization WHERE hospitalization_id = NEW.hospitalization_id;
  IF(discharge_date IS NULL
  OR (discharge_date > NEW.eval_date)) THEN
    SIGNAL SQLSTATE '45000' 
      SET MESSAGE_TEXT = 'Cannot evaluate doctor before discharge';
  END IF;
END$$

--CHECK IF DOCTOR HAS PRESCRIBED ANYTHING TO THIS PATIENT DURING THIS HOSPITALIZATION
CREATE TRIGGER doctor_evaluation_prescription_check BEFORE INSERT ON Doctor_Evaluation
FOR EACH ROW
BEGIN
    DECLARE has_prescribed INT;
    SELECT COUNT(*) INTO has_prescribed
    FROM Prescription
    WHERE doctor_AMKA = NEW.doctor_id AND hospitalization_id = NEW.hospitalization_id;
    IF has_prescribed = 0 THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Δεν γίνεται να αξιολογήσετε χωρίς να σας έχει συνταγογραφήσει σε αυτή τη νοσηλεία.';
    END IF;
END$$

--CHECK LAB_WORK RESULTS: MUST CONTAIN EITHER ARITHMETIC VALUES OR TEXT OR BOTH
CREATE TRIGGER lab_work_result BEFORE INSERT ON Lab_Work
FOR EACH ROW
BEGIN
    IF (NEW.lab_result_value IS NOT NULL AND NEW.lab_result_units IS NULL) OR (NEW.lab_result_value IS NULL AND NEW.lab_result_units IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Lab result value and units must be provided together';
    END IF;
    IF (NEW.lab_result_value IS NULL AND NEW.lab_result_text IS NULL) THEN
        SIGNAL SQLSTATE '45000' 
            SET MESSAGE_TEXT = 'Either lab result value with units or result text must be provided';
    END IF;
END$$

--CHECK IF MAIN DOCTOR FOR OPERATION IS ACTUALLY A SURGEON
CREATE TRIGGER main_doctor_operation BEFORE INSERT ON Operation
FOR EACH ROW
BEGIN
    DECLARE has_specialty VARCHAR(45);
    SELECT specialty INTO has_specialty
    FROM Doctor
    WHERE doctor_AMKA = NEW.surgeon_id;
    IF has_specialty != 'Surgeon' THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Main doctor for operation must be a surgeon.';
    END IF;
END$$

--CHECK IF OPERATION ROOM IS NOT FOR SURGERY AND IF SURGEON IS ASSIGNED
CREATE TRIGGER check_operation_room_type BEFORE INSERT ON Operation
FOR EACH ROW
BEGIN 
    DECLARE room_type_variable VARCHAR(45);
    SELECT room_type INTO room_type_variable
    FROM Operation_room WHERE room_id = NEW.room_id;
    IF (room_type_variable != 'Χειρουργείο' AND NEW.surgeon_id IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Οι χειρουργοί κάνουν μόνο επεμβάσεις, όχι ιατρικές πράξεις.';
    END IF;
END$$

--CHECK IF PATIENT IS HOSPITALIZED FOR OPERATIONS AND LAB WORK
CREATE TRIGGER check_if_hospitalized BEFORE INSERT ON Operation
FOR EACH ROW
BEGIN
    IF (SELECT hospitalization_id FROM Hospitalization WHERE hospitalization_id = NEW.hospitalization_id) IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'To perform operation patient must be hospitalized.';
    END IF;
END$$

--edw mporw na prosthesw to discharge date an einai megalutero apo to start date ths epemvashs
CREATE TRIGGER check_if_hospitalized BEFORE INSERT ON Lab_Work
FOR EACH ROW
BEGIN
    IF (SELECT hospitalization_id FROM Hospitalization WHERE hospitalization_id = NEW.hospitalization_id) IS NULL THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'To perform lab work patient must be hospitalized.';
    END IF;
END$$

CREATE TRIGGER occupied_operation_room BEFORE INSERT ON Operation
FOR EACH ROW
BEGIN
    DECLARE conflict INT;
    SELECT COUNT(*) INTO conflict FROM Operation WHERE room_id = NEW.room_id AND (expected_end_time > NEW.start_time) AND (start_time < NEW.expected_end_time);
    IF conflict > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Operation room is occupied.';
    END IF;
END$$

CREATE TRIGGER occupied_surgeon BEFORE INSERT ON Operation
FOR EACH ROW
BEGIN
    DECLARE conflict INT;
    SELECT COUNT(*) INTO conflict FROM Operation WHERE surgeon_id = NEW.surgeon_id AND (expected_end_time > NEW.start_time) AND (start_time < NEW.expected_end_time);
    IF conflict > 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Surgeon is busy.';
    END IF;
END$$

CREATE TRIGGER occupied_assistant_staff BEFORE INSERT ON Assistant_Staff
FOR EACH ROW
BEGIN
    DECLARE conflicts INT DEFAULT 0;
    DECLARE starts DATETIME;
    DECLARE end_time DATETIME;
    SELECT start_time, expected_end_time INTO starts, end_time
    FROM Operation WHERE operation_id = NEW.operation_id;

    SELECT COUNT(*) INTO conflicts
    FROM Assistant_Staff staff
    JOIN Operation op ON staff.operation_id = op.operation_id
    WHERE (staff.assistant_staff_id = NEW.assistant_staff_id) AND (op.expected_end_time > starts) AND (op.start_time < end_time);
    IF conflicts >0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Assistant staff busy.';
    END IF;
END$$

CREATE TRIGGER check_surgeon_on_assistant_staff BEFORE INSERT ON Assistant_Staff
FOR EACH ROW
BEGIN
    DECLARE conflict INT DEFAULT 0;
    DECLARE starts DATETIME;
    DECLARE end_time DATETIME;
    SELECT start_time, expected_end_time INTO starts, end_time
    FROM Operation WHERE operation_id = NEW.operation_id;
    SELECT COUNT(*) INTO conflict FROM Operation WHERE (operation_id != NEW.operation_id) 
    AND (surgeon_id = NEW.assistant_staff_id) AND (expected_end_time > starts) AND (start_time < end_time);
    IF conflict > 0 THEN 
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Assistant staff cannot be the main surgeon.';
    END IF;
END

$$
DELIMITER;