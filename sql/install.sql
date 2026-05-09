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
    `rank` VARCHAR(45) NOT NULL CHECK (`rank` IN ('Intern', 'Registrar', 'Senior Registrar', 'Head Physician')),
    `monthly_shifts_worked` INT,
    `consecutive_night_shifts` INT,
    `supervisor_AMKA` VARCHAR(11) CHECK (`supervisor_AMKA` <> `AMKA`),
    PRIMARY KEY (`AMKA`, `Staff_id`),
    CONSTRAINT `fk_doctor_AMKA` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_Staff_id` FOREIGN KEY (`Staff_id`) REFERENCES `Staff` (`Staff_id`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_supervisor` FOREIGN KEY (`supervisor_AMKA`) REFERENCES `Doctor` (`AMKA`) ON DELETE SET NULL
);

DROP TABLE IF EXISTS `Nurse`;

CREATE TABLE IF NOT EXISTS `Nurse` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `Staff_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
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
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `Staff_id` INT NOT NULL UNIQUE AUTO_INCREMENT,
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

DROP TABLE IF EXISTS `Department`;

CREATE TABLE IF NOT EXISTS `Department` (
    `department_code` INT NOT NULL UNIQUE,
    `name` VARCHAR(45) NOT NULL UNIQUE,
    `description` VARCHAR(255) NOT NULL,
    `number_of_beds` INT NOT NULL,
    `building_floor` VARCHAR(45) NOT NULL,
    `building` VARCHAR(255) NOT NULL,
    `department_head_AMKA` VARCHAR(11) NOT NULL UNIQUE,PRIMARY KEY (`department_code`),
    CONSTRAINT `fk_Department_Doctor` FOREIGN KEY (`department_head_AMKA`) REFERENCES `Doctor` (`AMKA`)   
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

DROP TABLE IF EXISTS `Shifts`;

CREATE TABLE IF NOT EXISTS `Shifts` (
    `shift_id` INT NOT NULL AUTO_INCREMENT,
    `shift_type` VARCHAR(20) NOT NULL CHECK (`shift_type` IN ('Morning', 'Afternoon', 'Night')),
    `shift_status` VARCHAR(45) CHECK (`shift_status` IN ('Scheduled', 'Draft')),
    `start_time` TIME NOT NULL,
    `end_time` TIME NOT NULL,
   `start_date` DATE NOT NULL,
   `staff_AMKA` VARCHAR(11) NOT NULL,
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

CREATE TRIGGER `check_if_doctor_exists` BEFORE INSERT ON `Doctor`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE AMKA = new.AMKA AND staff_type = 'Doctor') THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'The AMKA provided does not correspond to an existing staff member. Please insert into "Staff" first.';
    END IF;
END;

CREATE TRIGGER `check_if_nurse_exists` BEFORE INSERT ON `Nurse`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE AMKA = new.AMKA AND staff_type = 'Nurse') THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'The AMKA provided does not correspond to an existing staff member. Please insert into "Staff" first.';
    END IF;
END;

CREATE TRIGGER `check_if_admin_exists` BEFORE INSERT ON `Administrative_staff`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Staff WHERE AMKA = new.AMKA AND staff_type = 'Administrative Staff') THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'The AMKA provided does not correspond to an existing staff member. Please insert into "Staff" first.';
    END IF;
END;

CREATE TRIGGER `check_is_intern_supervisor` BEFORE DELETE ON `Doctor`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Doctor WHERE supervisor_AMKA = old.AMKA AND rank = 'Inter') THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Cannot delete a doctor who supervises an intern. Please change the Intern"s supervisor first.';
    END IF;
END

CREATE TRIGGER `check_rank` BEFORE INSERT ON `Doctor`
FOR EACH ROW
BEGIN
    IF (new.rank = 'Intern') AND (new.supervisor_AMKA IS NULL) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Intern doctors must have a supervisor.';
    END IF;
    IF (new.rank = 'Head Physician') AND (new.supervisor_AMKA IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Head Physicians cannot have a supervisor.';
    END IF;
END

CREATE TRIGGER `check_rank` BEFORE UPDATE ON `Doctor`
FOR EACH ROW
BEGIN
    IF (new.rank = 'Intern') AND (new.supervisor_AMKA IS NULL) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Intern doctors must have a supervisor.';
    END IF;
    IF (new.rank = 'Head Physician') AND (new.supervisor_AMKA IS NOT NULL) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Head Physicians cannot have a supervisor.';
    END IF;
END

CREATE TRIGGER `check_supervision_chain` BEFORE INSERT ON `Doctor`
FOR EACH ROW
BEGIN
    IF(SELECT AMKA, supervisor_AMKA FROM Doctor WHERE AMKA = new.supervisor_AMKA AND supervisor_AMKA = new.AMKA) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Circular supervision chains are not allowed.';
    END IF;
END

CREATE TRIGGER `check_supervision_chain` BEFORE UPDATE ON `Doctor`
FOR EACH ROW
BEGIN
    IF(SELECT AMKA, supervisor_AMKA FROM Doctor WHERE AMKA = new.supervisor_AMKA AND supervisor_AMKA = new.AMKA) THEN
        SIGNAL SQLSTATE '45000';
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

CREATE TRIGGER `check_hospitalization_dates` BEFORE INSERT ON `Hospitilization`
FOR EACH ROW
BEGIN
    IF new.admission_date > new.discharge_date THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Hospitalization admission date must be before discharge date.';
    END IF;
END

CREATE TRIGGER `check_hospitalization_dates` BEFORE UPDATE ON `Hospitilization`
FOR EACH ROW
BEGIN
    IF new.admission_date > new.discharge_date THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Hospitalization admission date must be before discharge date.';
    END IF;
END

CREATE TRIGGER `check_discharge_data` BEFORE UPDATE ON `Hospitilization`
FOR EACH ROW
BEGIN
    IF new.discharge_date IS NOT NULL AND old.discharge_date IS NULL THEN
        IF new.discharge_diagnosis_ICD IS NULL OR new.discharge_diagnosis_description IS NULL THEN
            SIGNAL SQLSTATE '45000';
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
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'The selected bed is not available.';
    END IF;
END

CREATE TRIGGER `check_medicine` BEFORE UPDATE ON `Medicine`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code = new.ema_code AND product_name <> new.product_name) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'No two medicines can have the same EMA code but different product names.';
    END IF;
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code <> new.ema_code AND product_name = new.product_name) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'No two medicines can have the same product name but different EMA codes.';
    END IF;
END

CREATE TRIGGER `check_medicine` BEFORE INSERT ON `Medicine`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code = new.ema_code AND product_name <> new.product_name) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'No two medicines can have the same EMA code but different product names.';
    END IF;
    IF EXISTS (SELECT * FROM Medicine WHERE ema_code <> new.ema_code AND product_name = new.product_name) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'No two medicines can have the same product name but different EMA codes.';
    END IF;
END

CREATE TRIGGER `check_prescription_dates` BEFORE UPDATE ON `Prescription`
FOR EACH ROW
BEGIN
    IF new.start_date > new.end_date THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Prescription start date must be before end date.';
    END IF;
END

CREATE TRIGGER `check_prescription_dates` BEFORE INSERT ON `Prescription`
FOR EACH ROW
BEGIN
    IF new.start_date > new.end_date THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Prescription start date must be before end date.';
    END IF;
END

CREATE TRIGGER `check_allergies` BEFORE UPDATE ON `Prescription`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT (SELECT medicine_ema_code FROM Allergy WHERE patient_AMKA = new.patient_AMKA)) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Cannot Prescribe medicine the patient is allergic to.';
    END IF;
END

CREATE TRIGGER `check_allergies` BEFORE INSERT ON `Prescription`
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT (SELECT medicine_ema_code FROM Allergy WHERE patient_AMKA = new.patient_AMKA)) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Cannot Prescribe medicine the patient is allergic to.';
    END IF;
END

CREATE FUNCTION `calculate_shift_members` (p_start_time TIME, p_start_date DATE) RETURNS TINYINT(1)
BEGIN
    DECLARE doctor_count INT;
    DECLARE nurse_count INT;
    DECLARE admin_count INT;

    SELECT COUNT(*) INTO doctor_count FROM Shifts sh JOIN Staff st ON sh.staff_AMKA = st.AMKA WHERE sh.start_time = p_start_time AND sh.start_date = p_start_date AND st.staff_type = 'Doctor';
    SELECT COUNT(*) INTO nurse_count FROM Shifts sh JOIN Staff st ON sh.staff_AMKA = st.AMKA WHERE sh.start_time = p_start_time AND sh.start_date = p_start_date AND st.staff_type = 'Nurse';
    SELECT COUNT(*) INTO admin_count FROM Shifts sh JOIN Staff st ON sh.staff_AMKA = st.AMKA WHERE sh.start_time = p_start_time AND sh.start_date = p_start_date AND st.staff_type = 'Administrative Staff';

    IF doctor_count >= 3 AND nurse_count >= 6 AND admin_count >= 2 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END

CREATE FUNCTION `exists_senior_doctor`(p_start_time TIME, p_start_date DATE) RETURNS TINYINT(1)
BEGIN
    DECLARE senior_doctor_count INT;

    SELECT COUNT(*) INTO senior_doctor_count
    FROM Shifts s
    JOIN Doctor d ON s.staff_id = d.Staff_id
    WHERE s.start_time = p_start_time AND s.start_date = p_start_date AND d.rank IN ('Senior Registrar', 'Head Physician');

    IF senior_doctor_count >= 1 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END

-- CHECK IF STAFF_TYPE = DOCTOR CHECK IS REQUIRED
CREATE FUNCTION `is_intern` (staff_id INT) RETURNS TINYINT(1)
BEGIN
      IF (SELECT rank FROM Doctor WHERE Staff_id = staff_id) = 'Intern' THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END

CREATE FUNCTION `check_for_senior_doctor`()

CREATE TRIGGER `check_for_senior_doctor_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    IF is_intern(NEW.staff_id) THEN
        IF NOT exists_senior_doctor(NEW.start_time, NEW.start_date) THEN
            SIGNAL SQLSTATE '45000';
                SET MESSAGE_TEXT = 'Cannot add an Intern Doctor to a shift without atleast one Senior Registrar or Head Physician present.';
        END IF;
    END IF;
END

CREATE TRIGGER `check_for_senior_doctor_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    IF is_intern(NEW.staff_id) THEN
        IF NOT exists_senior_doctor(NEW.start_time, NEW.start_date) THEN
            SIGNAL SQLSTATE '45000';
                SET MESSAGE_TEXT = 'Cannot add an Intern Doctor to a shift without atleast one Senior Registrar or Head Physician present.';
        END IF;
    END IF;
END

CREATE TRIGGER `set_shift_validity_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    IF CURDATE() > NEW.start_date THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Shift start date cannot be in the past.';
    END IF;

    IF calculate_shift_members(NEW.start_time, NEW.start_date) THEN
        SET NEW.shift_status = 'Scheduled';
    ELSE
        SET NEW.shift_status = 'Draft';
    END IF;
END

CREATE TRIGGER `set_shift_validity_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    IF CURDATE() > NEW.start_date THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'Shift start date cannot be in the past.';
    END IF;

    IF calculate_shift_members(NEW.start_time, NEW.start_date) THEN
        SET NEW.shift_status = 'Scheduled';
    ELSE
        SET NEW.shift_status = 'Draft';
    END IF;
END

CREATE TRIGGER `check_max_shifts_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE last_shift_date DATE;
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    SELECT MAX(start_date) INTO last_shift_date FROM Shifts WHERE staff_AMKA = NEW.staff_AMKA AND staff_id = NEW.staff_id;

    IF last_shift_date IS NOT NULL AND MONTH(last_shift_date) <> MONTH(NEW.start_date) THEN
        UPDATE Doctor SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        UPDATE Nurse SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        UPDATE Administrative_Staff SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    END IF;    
    
    CASE
        WHEN s_type = 'Doctor' THEN
            IF (SELECT monthly_shifts_worked FROM Doctor WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 15 THEN
                SIGNAL SQLSTATE '45000';
                    SET MESSAGE_TEXT = 'A doctor cannot work more than 15 shifts per month.';
            END IF;
        WHEN s_type = 'Nurse' THEN
            IF (SELECT monthly_shifts_worked FROM Nurse WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 20 THEN
                SIGNAL SQLSTATE '45000';
                    SET MESSAGE_TEXT = 'A nurse cannot work more than 20 shifts per month.';
            END IF;
        WHEN s_type = 'Administrative Staff' THEN
            IF (SELECT monthly_shifts_worked FROM Administrative_staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 25 THEN
                SIGNAL SQLSTATE '45000';
                    SET MESSAGE_TEXT = 'An administrative staff member cannot work more than 25 shifts per month.';
            END IF; 
    CASE END;    
END

CREATE TRIGGER `check_max_shifts_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE last_shift_date DATE;
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    SELECT MAX(start_date) INTO last_shift_date FROM Shifts WHERE staff_AMKA = NEW.staff_AMKA AND staff_id = NEW.staff_id;

    IF last_shift_date IS NOT NULL AND MONTH(last_shift_date) <> MONTH(NEW.start_date) THEN
        UPDATE Doctor SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        UPDATE Nurse SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        UPDATE Administrative_Staff SET monthly_shifts_worked = 0 WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    END IF;
    
    CASE
        WHEN s_type = 'Doctor' THEN
            IF (SELECT monthly_shifts_worked FROM Doctor WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 15 THEN
                SIGNAL SQLSTATE '45000';
                    SET MESSAGE_TEXT = 'A doctor cannot work more than 15 shifts per month.';
            END IF;
        WHEN s_type = 'Nurse' THEN
            IF (SELECT monthly_shifts_worked FROM Nurse WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 20 THEN
                SIGNAL SQLSTATE '45000';
                    SET MESSAGE_TEXT = 'A nurse cannot work more than 20 shifts per month.';
            END IF;
        WHEN s_type = 'Administrative Staff' THEN
            IF (SELECT monthly_shifts_worked FROM Administrative_staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 25 THEN
                SIGNAL SQLSTATE '45000';
                    SET MESSAGE_TEXT = 'An administrative staff member cannot work more than 25 shifts per month.';
            END IF; 
    CASE END;   
END

CREATE TRIGGER `check_if_shift_exists` BEFORE INSERT ON `On_Duty`
FOR EACH ROW
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Shifts WHERE NEW.shift_id = shift_id) THEN
        SIGNAL SQLSTATE '45000';
            SET MESSAGE_TEXT = 'The shift_id provided does not correspond to an existing shift. Please insert into "Shifts" first.';
    END IF;
END

CREATE TRIGGER `check_shift_type_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    IF HOUR(NEW.start_time) >= 7 AND HOUR(NEW.start_time) < 15 THEN
        SET NEW.shift_type = 'Morning';
    ELSEIF HOUR(NEW.start_time) >= 15 AND HOUR(NEW.start_time) < 23 THEN
        SET NEW.shift_type = 'Afternoon';
    ELSEIF HOUR(NEW.start_time) = 23 OR HOUR(NEW.start_time) < 7 THEN
        SET NEW.shift_type = 'Night';
    ELSE
        SIGNAL SQLSTATE '45000';
                SET MESSAGE_TEXT = 'Invalid start time for shift. Please ensure the start time falls within the defined shift hours.';
    END IF;
END

CREATE TRIGGER `check_shift_type_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    IF HOUR(NEW.start_time) >= 7 AND HOUR(NEW.start_time) < 15 THEN
        SET NEW.shift_type = 'Morning';
    ELSEIF HOUR(NEW.start_time) >= 15 AND HOUR(NEW.start_time) < 23 THEN
        SET NEW.shift_type = 'Afternoon';
    ELSEIF HOUR(NEW.start_time) = 23 OR HOUR(NEW.start_time) < 7 THEN
        SET NEW.shift_type = 'Night';
    ELSE
        SIGNAL SQLSTATE '45000';
                SET MESSAGE_TEXT = 'Invalid start time for shift. Please ensure the start time falls within the defined shift hours.';
    END IF;
END

CREATE TRIGGER `update_shifts` AFTER INSERT ON `Shifts`
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
                    CASE END;
            WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        ELSEIF s_type = 'Nurse' THEN
            UPDATE Nurse
            SET monthly_shifts_worked = IFNULL(monthly_shifts_worked, 0) + 1,
                consecutive_night_shifts = 
                    CASE WHEN NEW.shift_type = 'Night' 
                        THEN IFNULL(consecutive_night_shifts, 0) + 1
                        ELSE 0
                    CASE END;
            WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        ELSEIF s_type = 'Administrative Staff' THEN
            UPDATE Administrative_Staff
            SET monthly_shifts_worked = IFNULL(monthly_shifts_worked, 0) + 1,
                consecutive_night_shifts = 
                    CASE WHEN NEW.shift_type = 'Night' 
                        THEN IFNULL(consecutive_night_shifts, 0) + 1
                        ELSE 0
                    CASE END;
            WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
        END IF; 
    END IF;
END

CREATE TRIGGER `check_consecutive_shifts_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE last_shift DATETIME;

    SELECT TIMESTAMP(start_date, end_time) INTO last_shift FROM Shifts WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA AND TIMESTAMP(start_date, end_time) < TIMESTAMP(NEW.start_date, NEW.start_time) ORDER BY TIMESTAMP(start_date, end_time) DESC LIMIT 1;

    IF last_shift IS NOT NULL THEN
        IF TIMESTAMPDIFF(HOUR, last_shift, TIMESTAMP(NEW.start_date, NEW.end_time)) < 8 THEN
            SIGNAL SQLSTATE '45000';
                SET MESSAGE_TEXT = 'Could not register shift: an 8-hour rest is required between shifts.';
        END IF;
    END IF;
END

CREATE TRIGGER `check_consecutive_shifts_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE last_shift DATETIME;

    SELECT TIMESTAMP(start_date, end_time) INTO last_shift FROM Shifts WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA AND shift_id <> NEW.shift_id AND TIMESTAMP(start_date, end_time) < TIMESTAMP(NEW.start_date, NEW.end_time) ORDER BY TIMESTAMP(start_date, end_time) DESC LIMIT 1;

    IF last_shift IS NOT NULL THEN
        IF TIMESTAMPDIFF(HOUR, last_shift, TIMESTAMP(NEW.start_date, NEW.end_time)) < 8 THEN
            SIGNAL SQLSTATE '45000';
                SET MESSAGE_TEXT = 'Could not register shift: an 8-hour rest is required between shifts.';
        END IF;
    END IF;
END

CREATE TRIGGER `check_night_shift_validity_ins` BEFORE INSERT ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    
    IF NEW.shift_type = 'Night' THEN
        CASE
            WHEN s_type = 'Doctor' THEN 
                IF (SELECT consecutive_night_shifts FROM Doctor WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000';
                        SET MESSAGE_TEXT = 'Doctors cannot work more than 3 consecutive night shifts.';
                END IF;
            WHEN s_type = 'Nurse' THEN
                IF (SELECT consecutive_night_shifts FROM Nurse WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000';
                        SET MESSAGE_TEXT = 'Nurses cannot work more than 3 consecutive night shifts.';
                END IF;
            WHEN s_type = 'Administrative Staff' THEN
                IF (SELECT consecutive_night_shifts FROM Administrative_Staff WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000';
                        SET MESSAGE_TEXT = 'Administrative Staff cannot work more than 3 consecutive night shifts.';
                END IF;
        CASE END;
    END IF;    
END

CREATE TRIGGER `check_night_shift_validity_upd` BEFORE UPDATE ON `Shifts`
FOR EACH ROW
BEGIN
    DECLARE s_type VARCHAR(45);
    SELECT staff_type INTO s_type FROM Staff WHERE Staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA;
    
    IF NEW.shift_type = 'Night' THEN
        CASE
            WHEN s_type = 'Doctor' THEN 
                IF (SELECT consecutive_night_shifts FROM Doctor WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000';
                        SET MESSAGE_TEXT = 'Doctors cannot work more than 3 consecutive night shifts.';
                END IF;
            WHEN s_type = 'Nurse' THEN
                IF (SELECT consecutive_night_shifts FROM Nurse WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000';
                        SET MESSAGE_TEXT = 'Nurses cannot work more than 3 consecutive night shifts.';
                END IF;
            WHEN s_type = 'Administrative Staff' THEN
                IF (SELECT consecutive_night_shifts FROM Administrative_Staff WHERE staff_id = NEW.staff_id AND AMKA = NEW.staff_AMKA) >= 3 THEN
                    SIGNAL SQLSTATE '45000';
                        SET MESSAGE_TEXT = 'Administrative Staff cannot work more than 3 consecutive night shifts.';
                END IF;
        CASE END;
    END IF;    
END