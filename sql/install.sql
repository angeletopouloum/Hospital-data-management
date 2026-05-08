DROP SCHEMA IF EXISTS Ygeiopolis-Management;
CREATE SCHEMA Ygeiopolis-Management;
USE Ygeiopolis-Management;

DROP TABLE IF EXISTS `Staff`;

CREATE TABLE IF NOT EXISTS `Staff` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
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

DROP TABLE IF EXISTS `Doctor`;

CREATE TABLE IF NOT EXISTS `Doctor` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `Staff_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `medical_association_license_number` VARCHAR(30) NOT NULL UNIQUE,
    `specialty` VARCHAR(45) NOT NULL,
    `rank` VARCHAR(45) NOT NULL CHECK (`rank` IN ('Intern', 'Registrar', 'Senior Registrar', 'Head Physician'));,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    `supervisor_AMKA` VARCHAR(11) CHECK (`supervisor_AMKA` <> `AMKA`),
    PRIMARY KEY (`AMKA`, `Staff_id`),
    CONSTRAINT `fk_doctor_AMKA` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_Staff_id` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_supervisor` FOREIGN KEY (`supervisor_AMKA`) REFERENCES `Doctor` (`AMKA`) ON DELETE SET NULL,
);

DROP TABLE IF EXISTS `Nurse`;

CREATE TABLE IF NOT EXISTS `Nurse` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `Staff_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `rank` VARCHAR(45) NOT NULL CHECK (`rank` IN ('Assistant Nurse', 'Nurse', 'Head Nurse'));,
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    PRIMARY KEY (`AMKA`, `Staff_id`),
    CONSTRAINT `fk_nurse_AMKA` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_nurse_Staff_id` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_nurse_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`),
);

DROP TABLE IF EXISTS `Administrative_staff`;

CREATE TABLE IF NOT EXISTS `Administrative_staff` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `Staff_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `role` VARCHAR(45) NOT NULL,
    `office` VARCHAR(45) NOT NULL,
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    PRIMARY KEY (`AMKA`, `Staff_id`),
    CONSTRAINT `fk_Admin_Staff` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_Admin_Staff_id` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_Administrator_Department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`)
);

DROP TABLE IF EXISTS `Department`;

CREATE TABLE IF NOT EXISTS `Department` (
    `department_code` INT NOT NULL UNIQUE,
    `name` VARCHAR(45) NOT NULL UNIQUE,
    `description` VARCHAR(255) NOT NULL,
    `number_of_beds` INT NOT NULL,
    `building_floor` VARCHAR(45) NOT NULL,
    `building` VARCHAR(255) NOT NULL,
    `department_head_AMKA` VARCHAR(11) NOT NULL UNIQUE,PRIMARY KEY (`department_code`),
    CONSTRAINT `fk_Department_Doctor` FOREIGN KEY (`department_head`) REFERENCES `Doctor` (`AMKA`)   
);

DROP TABLE IF EXISTS `Beds`;

CREATE TABLE IF NOT EXISTS `Beds` (
    `id_number` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `type` VARCHAR(45) NOT NULL,
    `status` VARCHAR(45) NOT NULL CHECK (`status` IN ('Occupied', 'Available', 'Under Maintenance'));,
    `department_code` INT NOT NULL,
    PRIMARY KEY (`id_number`),
    CONSTRAINT `fk_Beds_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`) ON DELETE CASCADE,
);

DROP TABLE IF EXISTS `Hospitilization`;

CREATE TABLE IF NOT EXISTS `Hospitilization` (
    `hospitilization_id` INT NOT NULL AUTO_INCREMENT,
    `AMKA` VARCHAR(11) NOT NULL,
    `department_code` INT NOT NULL,
    `bed_id_number` INT NOT NULL UNIQUE,
    `admission_date` DATE NOT NULL,
    `discharge_date` DATE,
    `KEN` VARCHAR(5) NOT NULL,
    `triage_id` INT NOT NULL UNIQUE,
    `admission_diagnosis_ICD` VARCHAR(7) NOT NULL,
    `discharge_diagnosis_ICD` VARCHAR(7),
    `admission_diagnosis_description` VARCHAR(255) NOT NULL,
    `discharge_diagnosis_description` VARCHAR(255),
    PRIMARY KEY (`hospitilization_id`,`AMKA`, `admission_date`),
    CONSTRAINT `fk_Hospitilization_AMKA` FOREIGN KEY (`AMKA`) REFERENCES `Patient` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_Hospitilization_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`),
    CONSTRAINT `fk_Hospitilization_bed` FOREIGN KEY (`bed_id_number`) REFERENCES `Beds` (`id_number`),
    CONSTRAINT `fk_Hospitilization_cost_calculation` FOREIGN KEY (`KEN`) REFERENCES `Cost_Calculation` (`KEN`),
    CONSTRAINT `fk_Hospitilization_triage` FOREIGN KEY (`triage_id`) REFERENCES `Triage` (`triage_id`),
    CONSTRAINT `fk_Hospitilization_admission_diagnosis` FOREIGN KEY (`admission_diagnosis_ICD`) REFERENCES `Diagnoses` (`code`),
    CONSTRAINT `fk_Hospitilization_discharge_diagnosis` FOREIGN KEY (`discharge_diagnosis_ICD`) REFERENCES `Diagnoses` (`code`)
);

DROP TABLE IF EXISTS `Patient`;

CREATE TABLE IF NOT EXISTS `Patient` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
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

DROP TABLE IF EXISTS `Medicine`;

CREATE TABLE IF NOT EXISTS `Medicine`(
    `ema_code` VARCHAR(45) NOT NULL,
    `product_name` VARCHAR(100) NOT NULL,
    `active_substance` VARCHAR(255) NOT NULL,
    `route_of_administration` VARCHAR(255) NOT NULL,
    `product_autorization_country` VARCHAR(255) NOT NULL,
    `marketing_authorization_holder` VARCHAR(255) NOT NULL,
    `pharmacovigilance_system_master_file_location` VARCHAR(255) NOT NULL,
    `pharmacovigilance_enquires_email_address` VARCHAR(255) NOT NULL,
    `pharmacovigilance_enquires_phone_number` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`ema_code`, `active_substance`)
);

DROP TABLE IF EXISTS `Prescription`;

CREATE TABLE IF NOT EXISTS `Prescription` (
    `prescription_id` VARCHAR(14) NOT NULL UNIQUE,
    `dosage` VARCHAR(45) NOT NULL,
    `frequency` VARCHAR(45) NOT NULL,
    `start_date` DATE NOT NULL,
    `end_date` DATE,
    `patient_AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `doctor_AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `medicine_ema_code` VARCHAR(45) NOT NULL UNIQUE,
    PRIMARY KEY (`prescription_id`, `medicine_ema_code`, `patient_AMKA`, `doctor_AMKA`),
    CONSTRAINT `fk_Prescription_Patient` FOREIGN KEY (`patient_AMKA`) REFERENCES `Patient` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_Prescription_Medicine` FOREIGN KEY (`medicine_ema_code`) REFERENCES `Medicine` (`ema_code`),
    CONSTRAINT `fk_Prescription_Doctor` FOREIGN KEY (`doctor_AMKA`) REFERENCES `Doctor` (`AMKA`)
);

DROP TABLE IF EXISTS `Cost_Calculation`;

CREATE TABLE IF NOT EXISTS `Cost_Calculation` (
    `KEN` VARCHAR(5) NOT NULL,
    `base_cost` INT NOT NULL,
    `MDN` INT NOT NULL,    
    `total_cost` DECIMAL(10,2) NOT NULL,
    `total_hospitilisation_days` INT NOT NULL,
    PRIMARY KEY (`KEN`),
);

CREATE TRIGGER `calculate_total_cost` BEFORE INSERT OR UPDATE ON `Cost_Calculation`

DROP TABLE IF EXISTS `Insurance_Type`;

CREATE TABLE IF NOT EXISTS `Insurance_Type`(
    `patient_AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `insurance_provider` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`patient_AMKA`),
    CONSTRAINT `fk_insurance_type_AMKA` FOREIGN KEY (`patient_AMKA`) REFERENCES `Patient` (`AMKA`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `On_Duty`;

CREATE TABLE IF NOT EXISTS `On_Duty` (
    `department_code` INT NOT NULL,
    `administrative_staff_AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `nurse_AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `doctor_AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `date` DATE NOT NULL,
    `shift` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`administrative_staff_AMKA`, `date`, `shift`),
    CONSTRAINT `fk_on_duty_administrative_staff_AMKA` FOREIGN KEY (`administrative_staff_AMKA`) REFERENCES `Administrative_staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_on_duty_nurse_AMKA` FOREIGN KEY (`nurse_AMKA`) REFERENCES `Nurse` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_on_duty_doctor_AMKA` FOREIGN KEY (`doctor_AMKA`) REFERENCES `Doctor` (`AMKA`) ON DELETE CASCADE
);

DROP TABLE IF EXISTS `Shifts`

CREATE TABLE IF IF NOT EXISTS `Shifts` (
    `shift_id` INT NOT NULL AUTO_INCREMENT,
    `type` VARCHAR(15) NOT NULL,
    ``
    PRIMARY KEY (`shift_id`),
    CONSTRAINT `fk_shifts_department_code` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`) ON DELETE CASCADE
);

CREATE TRIGGER `check_if_doctor_exists` BEFORE INSERT ON `Doctor`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE AMKA = new.AMKA AND staff_type = 'Doctor') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The AMKA provided does not correspond to an existing staff member. Please insert into "Staff" first.';
    END IF;
END;

CREATE TRIGGER `check_if_nurse_exists` BEFORE INSERT ON `Nurse`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE AMKA = new.AMKA AND staff_type = 'Nurse') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The AMKA provided does not correspond to an existing staff member. Please insert into "Staff" first.';
    END IF;
END;

CREATE TRIGGER `check_if_admin_exists` BEFORE INSERT ON `Administrative_staff`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE AMKA = new.AMKA AND staff_type = 'Administrative Staff') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The AMKA provided does not correspond to an existing staff member. Please insert into "Staff" first.';
    END IF;
END;

CREATE TRIGGER `check_is_intern_supervisor` BEFORE DELETE ON `Doctor`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Doctor WHERE supervisor_AMKA = old.AMKA AND rank = 'Inter') THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot delete a doctor who supervises an intern. Please change the Intern"s supervisor first.';
    END IF;
END

CREATE TRIGGER `check_rank` BEFORE INSERT OR UPDATE ON `Doctor`
FOR EACH ROW
BEGIN
    IF (new.rank == 'Intern') AND (new.supervisor_AMKA IS NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Intern doctors must have a supervisor.';
    END IF;
    IF (new.rank == 'Head Physician') AND (new.supervisor_AMKA IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Head Physicians cannot have a supervisor.';
    END IF;
END

CREATE TRIGGER `check_supervision_chain` BEFORE INSERT OR UPDATE ON `Doctor`
FOR EACH ROW
BEGIN
    IF(SELECT AMKA, supervisor_AMKA FROM Doctor WHERE AMKA = new.supervisor_AMKA AND supervisor_AMKA = new.AMKA) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Circular supervision chains are not allowed.';
    END IF;
END

CREATE TRIGGER `increase_bed_count` AFTER INSERT ON `Beds`
FOR EACH ROW
BEGIN
    UPDATE Department
    SET number_of_beds = number_of_beds + 1
    WHERE department_code = new.department_code;
END

CREATE TRIGGER `decrease_bed_count` AFTER DELETE ON `Beds`
FOR EACH ROW
BEGIN
    UPDATE Department
    SET number_of_beds = number_of_beds - 1
    WHERE department_code = old.department_code;
END

CREATE TRIGGER `check_hospitalization_dates` BEFORE INSERT OR UPDATE ON `Hospitilization`
FOR EACH ROW
BEGIN
    IF new.admission_date > new.discharge_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Hospitalization admission date must be before discharge date.';
    END IF;
END

CREATE TRIGGER `check_discharge_data` BEFORE UPDATE ON `Hospitilization`
FOR EACH ROW
BEGIN
    IF new.discharge_date IS NOT NULL AND old.discharge_date IS NULL THEN
        IF new.discharge_diagnosis_ICD IS NULL OR new.discharge_diagnosis_description IS NULL THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Discharge diagnosis code and description must be provided when discharge date is set.';
        END IF;
    END IF;
END

CREATE TRIGGER `set_bed_occupied` AFTER INSERT ON `Hospitilization`
FOR EACH ROW
BEGIN
    UPDATE Beds
    SET status = 'Occupied'
    WHERE id_number = new.bed_id_number;
END

CREATE TRIGGER `set_bed_available` AFTER UPDATE ON `Hospitilization`
FOR EACH ROW
BEGIN
    IF new.discharge_date IS NOT NULL THEN
        UPDATE Beds
        SET status = 'Available'
        WHERE id_number = new.bed_id_number;
    END IF;
END

CREATE TRIGGER `check_bed_availability` BEFORE INSERT ON `Hospitilization`
FOR EACH ROW
BEGIN
    IF (SELECT status FROM Beds where id_number = new.bed_id_number) <> 'Available' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'The selected bed is not available.';
    END IF;
END

CREATE TRIGGER `check_medicine` BEFORE INSERT OR UPDATE ON `Medicine`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code == new.ema_code AND product_name <> new.product_name) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No two medicines can have the same EMA code but different product names.';
    END IF;
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code <> new.ema_code AND product_name == new.product_name) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'No two medicines can have the same product name but different EMA codes.';
    END IF;
END

CREATE TRIGGER `check_prescription_dates` BEFORE INSERT OR UPDATE ON `Prescription`
FOR EACH ROW
BEGIN
    IF new.start_date > new.end_date THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Prescription start date must be before end date.';
    END IF;
END

CREATE TRIGGER `check_allergies` BEFORE INSERT OR UPDATE ON `Prescription`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT (SELECT medicine_ema_code FROM Allergy WHERE patient_AMKA = new.patient_AMKA)) THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Cannot Prescribe medicine the patient is allergic to.';
    END IF;
END