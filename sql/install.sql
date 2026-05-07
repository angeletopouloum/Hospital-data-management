DROP SCHEMA IF EXISTS Ygeiopolis-Management;
CREATE SCHEMA Ygeiopolis-Management;
USE Ygeiopolis-Management;

DROP TABLE IF EXISTS `Staff`;

CREATE TABLE IF NOT EXISTS `Staff` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `first_name` VARCHAR(45) NOT NULL,
    `last_name` VARCHAR(45) NOT NULL,
    `date_of_birth` DATE NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(12) NOT NULL,
    `hire_date` DATE NOT NULL,
    `staff_type` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`AMKA`)
);

DROP TABLE IF EXISTS `Doctor`;

CREATE TABLE IF NOT EXISTS `Doctor` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `medical_association_license_number` VARCHAR(30) NOT NULL UNIQUE,
    `specialty` VARCHAR(45) NOT NULL,
    `rank` VARCHAR(45) NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    `supervisor_AMKA` VARCHAR(11),
    PRIMARY KEY (`AMKA`),
    CONSTRAINT `fk_doctor_AMKA` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_supervisor` FOREIGN KEY (`supervisor_AMKA`) REFERENCES `Doctor` (`AMKA`) ON DELETE SET NULL,
    CHECK (`rank` IN ('Intern', 'Registrar', 'Senior Registrar', 'Head Physician'));
);


DROP TABLE IF EXISTS `Nurse`;

CREATE TABLE IF NOT EXISTS `Nurse` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `rank` VARCHAR(45) NOT NULL,
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    PRIMARY KEY (`AMKA`),
    CONSTRAINT `fk_nurse_AMKA` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
    CONSTRAINT `fk_nurse_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`),
    CHECK (`rank` IN ('Assistant Nurse', 'Nurse', 'Head Nurse'));
);

DROP TABLE IF EXISTS `Administrative_staff`;

CREATE TABLE IF NOT EXISTS `Administrative_staff` (
    `AMKA` VARCHAR(11) NOT NULL UNIQUE,
    `role` VARCHAR(45) NOT NULL,
    `office` VARCHAR(45) NOT NULL,
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    PRIMARY KEY (`AMKA`),
    CONSTRAINT `fk_Admin_Staff` FOREIGN KEY (`AMKA`) REFERENCES `Staff` (`AMKA`) ON DELETE CASCADE,
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
    `status` VARCHAR(45) NOT NULL,
    `department_code` INT NOT NULL,
    PRIMARY KEY (`id_number`),
    CONSTRAINT `fk_Beds_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`) ON DELETE CASCADE,
    CHECK (`status` IN ('Occupied', 'Available', 'Under Maintenance'));
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
    `ema_code` VARCHAR(45) NOT NULL UNIQUE,
    `product_name` VARCHAR(100) NOT NULL UNIQUE,
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
    PRIMARY KEY (`KEN`),
);

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