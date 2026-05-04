DROP SCHEMA IF EXISTS Ygeiopolis-Management;
CREATE SCHEMA Ygeiopolis-Management;
USE Ygeiopolis-Management;

CREATE TABLE IF NOT EXISTS `Staff` (
    `amka` BIGINT(11) NOT NULL UNIQUE,
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
    `amka` BIGINT(11) NOT NULL UNIQUE,
    `license_number` INT NOT NULL UNIQUE,
    `specialty` VARCHAR(45) NOT NULL,
    `rank_level` VARCHAR(45) NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    `supervisor_amka` INT,
    CONSTRAINT `fk_doctor_amka` FOREIGN KEY (`amka`) REFERENCES `Staff` (`amka`) ON DELETE CASCADE,
    CONSTRAINT `fk_doctor_supervisor` FOREIGN KEY (`supervisor_amka`) REFERENCES `Doctor` (`amka`) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS `Nurse` (
    `amka` BIGINT(11) NOT NULL UNIQUE,
    `rank` VARCHAR(45) NOT NULL,
    `department_code` INT NOT NULL,
    `monthly_shifts_worked` INT NOT NULL,
    `consecutive_shifts` INT NOT NULL,
    CONSTRAINT `fk_nurse_amka` FOREIGN KEY (`amka`) REFERENCES `Staff` (`amka`) ON DELETE CASCADE,
    CONSTRAINT `fk_nurse_department` FOREIGN KEY (`department_code`) REFERENCES `Department` (`department_code`)
);

CREATE TABLE IF NOT EXISTS `Administrative_staff` (
    `amka` BIGINT(11) NOT NULL UNIQUE,
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
    `department_head` INT(12) NOT NULL UNIQUE,
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
    `amka` BIGINT(11) NOT NULL,
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
    `amka` BIGINT(11) NOT NULL UNIQUE,
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
    `prescribed_medicine`
);