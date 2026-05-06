DROP SCHEMA IF EXISTS Ygeiopolis-Management;
CREATE SCHEMA Ygeiopolis-Management;
USE Ygeiopolis-Management;

CREATE TABLE IF NOT EXISTS `Staff` (
    `amka` VARCHAR(11) NOT NULL UNIQUE,
    `first_name` VARCHAR(45) NOT NULL,
    `last_name` VARCHAR(45) NOT NULL,
    `date_of_birth` DATE NOT NULL,
    `email` VARCHAR(255) NOT NULL,
    `phone_number` VARCHAR(12) NOT NULL,
    `hire_date` DATE NOT NULL,
    `staff_type` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`amka`)
);

CREATE TABLE IF NOT EXISTS `Doctor` (
    `amka` VARCHAR(11) NOT NULL UNIQUE,
    `license_number` INT NOT NULL UNIQUE,
    `specialty` VARCHAR(45) NOT NULL,
    `rank_level` VARCHAR(45) NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    `supervisor_amka` VARCHAR(11),
    CONSTRAINT `fk_doctor_amka` FOREIGN KEY (`amka`) REFERENCES `Staff` (`amka`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_supervisor` FOREIGN KEY (`supervisor_amka`) REFERENCES `Doctor` (`amka`) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS `Nurse` (
    `amka` VARCHAR(11) NOT NULL UNIQUE,
    `rank` VARCHAR(45) NOT NULL,
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    CONSTRAINT `fk_nurse_amka` FOREIGN KEY (`amka`) REFERENCES `Staff` (`amka`) ON DELETE CASCADE,
    CONSTRAINT `fk_nurse_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`)
);

CREATE TABLE IF NOT EXISTS `Administrative_staff` (
    `amka` VARCHAR(11) NOT NULL UNIQUE,
    `position` VARCHAR(45) NOT NULL,
    `office` VARCHAR(45) NOT NULL,
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    CONSTRAINT `fk_admin_amka` FOREIGN KEY (`amka`) REFERENCES `Staff` (`amka`) ON DELETE CASCADE,
    CONSTRAINT `fk_admin_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`)
);

CREATE TABLE IF NOT EXISTS `Department` (
    `department_code` INT NOT NULL UNIQUE,
    `name` VARCHAR(45) NOT NULL UNIQUE,
    `description` VARCHAR(255) NOT NULL,
    `number_of_beds` INT NOT NULL,
    `building_floor` VARCHAR(45) NOT NULL,
    `department_head` VARCHAR(11) NOT NULL UNIQUE,
    CONSTRAINT `fk_department_head` FOREIGN KEY (`department_head`) REFERENCES `Doctor` (`amka`) ON DELETE SET NULL,
    PRIMARY KEY (`department_code`)
);

CREATE TABLE IF NOT EXISTS `Beds` (
    `id_number` INT NOT NULL UNIQUE AUTO_INCREMENT,
    `type` VARCHAR(45) NOT NULL,
    `status` VARCHAR(45) NOT NULL,
    `department_code` INT NOT NULL,
    PRIMARY KEY (`id_number`),
    CONSTRAINT `fk_beds_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `Hospitilization` (
    `amka` VARCHAR(11) NOT NULL,
    `department_code` INT NOT NULL,
    `bed_id_number` INT NOT NULL UNIQUE,
    `admission_date` DATE NOT NULL,
    `discharge_date` DATE,
    `admission_diagnosis_ICD` VARCHAR(7) NOT NULL,
    `discharge_diagnosis_ICD` VARCHAR(7),
    `admission_diagnosis_description` VARCHAR(255) NOT NULL,
    `discharge_diagnosis_description` VARCHAR(255),
    PRIMARY KEY (`amka`, `admission_date`),
    CONSTRAINT `fk_hospitilization_amka` FOREIGN KEY (`amka`) REFERENCES `Patient` (`amka`) ON DELETE CASCADE,
    CONSTRAINT `fk_hospitilization_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`),
    CONSTRAINT `fk_hospitilization_bed` FOREIGN KEY (`bed_id_number`) REFERENCES `Beds` (`id_number`)
);

CREATE TABLE IF NOT EXISTS `Patient` (
    `amka` VARCHAR(11) NOT NULL UNIQUE,
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
    `emergency_contact_first_name` VARCHAR(45),
    `emergency_contact_last_name` VARCHAR(45),
    `emergency_contact_phone_number` VARCHAR(12),
    `allergies` VARCHAR(45),
    PRIMARY KEY (`amka`)
);

CREATE TABLE IF NOT EXISTS `Medicine`(
    `medicine_name` VARCHAR(255) NOT NULL UNIQUE,
    `active_substance` VARCHAR(255) NOT NULL,
    `route_of_administration` VARCHAR(255) NOT NULL,
    `product_autorization_country` VARCHAR(255) NOT NULL,
    `marketing_authorization_holder` VARCHAR(255) NOT NULL,
    `pharmacovigilance_system_master_file_location` VARCHAR(255) NOT NULL,
    `pharmacovigilance_enquires_email_address` VARCHAR(255) NOT NULL,
    `pharmacovigilance_enquires_phone_number` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`medicine_name`, `active_substance`)
);

CREATE TABLE IF NOT EXISTS `Prescription` (
    `id` VARCHAR(255) NOT NULL UNIQUE AUTO_INCREMENT,
    `dosage` VARCHAR(45) NOT NULL,
    `frequency` VARCHAR(45) NOT NULL,
    `start_date` DATE NOT NULL UNIQUE,
    `end_date` DATE,
    `patient_amka` VARCHAR(11) NOT NULL UNIQUE,
    `doctor_amka` VARCHAR(11) NOT NULL UNIQUE,
    `medicine_name` VARCHAR(255) NOT NULL UNIQUE,
    `medicine_active_substance` VARCHAR(255) NOT NULL UNIQUE,
    PRIMARY KEY (`id`),
    CONSTRAINT `fk_prescription_amka` FOREIGN KEY (`patient_amka`) REFERENCES `Patient` (`amka`) ON DELETE CASCADE,
    CONSTRAINT `fk_prescription_medicine` FOREIGN KEY (`medicine_name`, `medicine_active_substance`) REFERENCES `Medicine` (`medicine_name`, `active_substance`)
    CONSTRAINT `fk_prescription_doctor` FOREIGN KEY (`doctor_amka`) REFERENCES `Doctor` (`amka`)
);

CREATE TABLE IF NOT EXISTS `Cost_Calculation` (
    `KEN` VARCHAR(5) NOT NULL,
    `base_cost` INT NOT NULL,
    `MDN` INT NOT NULL,    
    `patient_amka` VARCHAR(11) NOT NULL UNIQUE,
    `total_cost` DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (`KEN`),
    CONSTRAINT `fk_cost_calculation_amka` FOREIGN KEY (`patient_amka`) REFERENCES `Patient` (`amka`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `Insurance_Type`(
    `patient_amka` VARCHAR(11) NOT NULL UNIQUE,
    `insurance_provider` VARCHAR(255) NOT NULL,
    PRIMARY KEY (`patient_amka`),
    CONSTRAINT `fk_insurance_type_amka` FOREIGN KEY (`patient_amka`) REFERENCES `Patient` (`amka`) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS `On_Duty` (
    `department_code` INT NOT NULL,
    `administrative_staff_amka` VARCHAR(11) NOT NULL UNIQUE,
    `nurse_amka` VARCHAR(11) NOT NULL UNIQUE,
    `doctor_amka` VARCHAR(11) NOT NULL UNIQUE,
    `date` DATE NOT NULL,
    `shift` VARCHAR(45) NOT NULL,
    PRIMARY KEY (`staff_amka`, `date`, `shift`),
    CONSTRAINT `fk_on_duty_amka` FOREIGN KEY (`staff_amka`) REFERENCES `Staff` (`amka`) ON DELETE CASCADE
);