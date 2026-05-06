-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `mydb` DEFAULT CHARACTER SET utf8 ;
USE `mydb` ;

-- -----------------------------------------------------
-- Table `mydb`.`Staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Staff` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Staff` (
  `amka` VARCHAR(11) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(12) NOT NULL,
  `hire_date` DATE NOT NULL,
  `staff_type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`amka`),
  UNIQUE INDEX `amka_UNIQUE` (`amka` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Doctor`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Doctor` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Doctor` (
  `medical_association_license_number` VARCHAR(30) NOT NULL,
  `specialty` VARCHAR(45) NOT NULL,
  `rank` VARCHAR(45) NOT NULL,
  `supervisor_amka` VARCHAR(11) NOT NULL,
  `Staff_amka` VARCHAR(11) NOT NULL,
  `monthly_shifts_worked` INT NOT NULL,
  `consecutive_shifts` INT NOT NULL,
  PRIMARY KEY (`Staff_amka`),
  INDEX `fk_Doctor_Doctor1_idx` (`supervisor_amka` ASC) VISIBLE,
  UNIQUE INDEX `Staff_amka_UNIQUE` (`Staff_amka` ASC) VISIBLE,
  UNIQUE INDEX `license_number_UNIQUE` (`medical_association_license_number` ASC) VISIBLE,
  CONSTRAINT `fk_Doctor_Supervisor`
    FOREIGN KEY (`supervisor_amka`)
    REFERENCES `mydb`.`Doctor` (`Staff_amka`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Department`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Department` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Department` (
  `department_code` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `number_of_beds` INT NOT NULL,
  `building_floor` VARCHAR(45) NOT NULL,
  `department_head_amka` VARCHAR(11) NOT NULL,
  `building` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`department_code`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  INDEX `fk_Department_Doctor1_idx` (`department_head_amka` ASC) VISIBLE,
  UNIQUE INDEX `department_head_UNIQUE` (`department_head_amka` ASC) VISIBLE,
  UNIQUE INDEX `department_code_UNIQUE` (`department_code` ASC) VISIBLE,
  CONSTRAINT `fk_Department_Doctor1`
    FOREIGN KEY (`department_head_amka`)
    REFERENCES `mydb`.`Doctor` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Nurse`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Nurse` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Nurse` (
  `rank` VARCHAR(45) NOT NULL,
  `department_code` INT NOT NULL,
  `Staff_amka` VARCHAR(11) NOT NULL,
  `monthly_shifts_worked` INT NOT NULL,
  `consecutive_shifts` INT NOT NULL,
  PRIMARY KEY (`Staff_amka`),
  INDEX `fk_Nurse_Department1_idx` (`department_code` ASC) VISIBLE,
  UNIQUE INDEX `Staff_amka_UNIQUE` (`Staff_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Nurse_Staff1`
    FOREIGN KEY (`Staff_amka`)
    REFERENCES `mydb`.`Staff` (`amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Nurse_Department1`
    FOREIGN KEY (`department_code`)
    REFERENCES `mydb`.`Department` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Administrative_staff`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Administrative_staff` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Administrative_staff` (
  `role` VARCHAR(45) NOT NULL,
  `office` VARCHAR(45) NOT NULL,
  `department_code` INT NOT NULL,
  `Staff_amka` INT NOT NULL,
  `monthly_shifts_worked` INT NOT NULL,
  `consecutive_shifts` INT NOT NULL,
  PRIMARY KEY (`Staff_amka`),
  INDEX `fk_Administrator_Department1_idx` (`department_code` ASC) VISIBLE,
  UNIQUE INDEX `Staff_amka_UNIQUE` (`Staff_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Administrator_Staff1`
    FOREIGN KEY (`Staff_amka`)
    REFERENCES `mydb`.`Staff` (`amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Administrator_Department1`
    FOREIGN KEY (`department_code`)
    REFERENCES `mydb`.`Department` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Beds`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Beds` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Beds` (
  `id_number` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `Department_department_code` INT NOT NULL,
  PRIMARY KEY (`id_number`, `Department_department_code`),
  UNIQUE INDEX `id_number_UNIQUE` (`id_number` ASC) VISIBLE,
  INDEX `fk_Beds_Department1_idx` (`Department_department_code` ASC) VISIBLE,
  CONSTRAINT `fk_Beds_Department1`
    FOREIGN KEY (`Department_department_code`)
    REFERENCES `mydb`.`Department` (`department_code`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Patient`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Patient` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Patient` (
  `AMKA` VARCHAR(11) NOT NULL,
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
  PRIMARY KEY (`AMKA`),
  UNIQUE INDEX `AMKA_UNIQUE` (`AMKA` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Cost_Calculation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Cost_Calculation` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Cost_Calculation` (
  `KEN` VARCHAR(5) NOT NULL,
  `base_cost` INT NOT NULL,
  `MDN` INT NOT NULL,
  `total_cost` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`KEN`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Triage_level`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Triage_level` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Triage_level` (
  `level_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  `priority` INT NULL,
  PRIMARY KEY (`level_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`outcome`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`outcome` ;

CREATE TABLE IF NOT EXISTS `mydb`.`outcome` (
  `outcome_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NULL,
  PRIMARY KEY (`outcome_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Triage`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Triage` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Triage` (
  `triage_id` INT NOT NULL AUTO_INCREMENT,
  `arrival_time` DATETIME NOT NULL,
  `symptoms` LONGTEXT NOT NULL,
  `Triage_level_level_id` INT NOT NULL,
  `Patient_AMKA` BIGINT(11) NOT NULL,
  `Nurse_Staff_amka` INT NOT NULL,
  `outcome_outcome_id` INT NOT NULL,
  PRIMARY KEY (`triage_id`, `Triage_level_level_id`, `Patient_AMKA`, `Nurse_Staff_amka`, `outcome_outcome_id`),
  INDEX `fk_Triage_Triage_level1_idx` (`Triage_level_level_id` ASC) VISIBLE,
  INDEX `fk_Triage_Patient1_idx` (`Patient_AMKA` ASC) VISIBLE,
  INDEX `fk_Triage_Nurse1_idx` (`Nurse_Staff_amka` ASC) VISIBLE,
  INDEX `fk_Triage_outcome1_idx` (`outcome_outcome_id` ASC) VISIBLE,
  CONSTRAINT `fk_Triage_Triage_level1`
    FOREIGN KEY (`Triage_level_level_id`)
    REFERENCES `mydb`.`Triage_level` (`level_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Triage_Patient1`
    FOREIGN KEY (`Patient_AMKA`)
    REFERENCES `mydb`.`Patient` (`AMKA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Triage_Nurse1`
    FOREIGN KEY (`Nurse_Staff_amka`)
    REFERENCES `mydb`.`Nurse` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Triage_outcome1`
    FOREIGN KEY (`outcome_outcome_id`)
    REFERENCES `mydb`.`outcome` (`outcome_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Diagnoses`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Diagnoses` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Diagnoses` (
  `code` VARCHAR(7) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Hospitalisation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Hospitalisation` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Hospitalisation` (
  `hospitalization_id` INT NOT NULL AUTO_INCREMENT,
  `Patient_AMKA` VARCHAR(11) NOT NULL,
  `Department_department_code` INT NOT NULL,
  `Beds_id_number` INT NOT NULL,
  `admission_date` DATE NOT NULL,
  `discharge_date` DATE NULL,
  `cost_calculation_KEN` VARCHAR(5) NOT NULL,
  `Triage_triage_id` INT NOT NULL,
  `admission_ICD_code` VARCHAR(7) NOT NULL,
  `discharge_ICD_code` VARCHAR(7) NULL,
  `admission_diagnosis_description` VARCHAR(255) NOT NULL,
  `discharge_diagnosis_description` VARCHAR(255) NULL,
  PRIMARY KEY (`hospitalization_id`, `cost_calculation_KEN`, `Triage_triage_id`, `admission_ICD_code`, `discharge_ICD_code`, `Patient_AMKA`, `admission_date`),
  INDEX `fk_Hospitalisation_Department1_idx` (`Department_department_code` ASC) VISIBLE,
  INDEX `fk_Hospitalisation_Beds1_idx` (`Beds_id_number` ASC) VISIBLE,
  INDEX `fk_Hospitalisation_cost_calculation1_idx` (`cost_calculation_KEN` ASC) VISIBLE,
  INDEX `fk_Hospitalisation_Triage1_idx` (`Triage_triage_id` ASC) VISIBLE,
  INDEX `fk_Hospitalisation_ICD-10_codes1_idx` (`admission_ICD_code` ASC) VISIBLE,
  INDEX `fk_Hospitalisation_ICD-10_codes1_idx1` (`discharge_ICD_code` ASC) VISIBLE,
  UNIQUE INDEX `Beds_id_number_UNIQUE` (`Beds_id_number` ASC) VISIBLE,
  UNIQUE INDEX `Triage_triage_id_UNIQUE` (`Triage_triage_id` ASC) VISIBLE,
  CONSTRAINT `fk_Hospitalisation_Patient1`
    FOREIGN KEY (`Patient_AMKA`)
    REFERENCES `mydb`.`Patient` (`AMKA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hospitalisation_Department1`
    FOREIGN KEY (`Department_department_code`)
    REFERENCES `mydb`.`Department` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hospitalisation_Beds1`
    FOREIGN KEY (`Beds_id_number`)
    REFERENCES `mydb`.`Beds` (`id_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hospitalisation_cost_calculation1`
    FOREIGN KEY (`cost_calculation_KEN`)
    REFERENCES `mydb`.`Cost_Calculation` (`KEN`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hospitalisation_Triage1`
    FOREIGN KEY (`Triage_triage_id`)
    REFERENCES `mydb`.`Triage` (`triage_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hospitalisation_admission_diagnosis`
    FOREIGN KEY (`admission_ICD_code`)
    REFERENCES `mydb`.`Diagnoses` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hospitalisation_discharge_diagnosis`
    FOREIGN KEY (`discharge_ICD_code`)
    REFERENCES `mydb`.`Diagnoses` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Doctor_has_Department`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Doctor_has_Department` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Doctor_has_Department` (
  `Doctor_Staff_amka` INT NOT NULL,
  `Department_department_code` INT NOT NULL,
  PRIMARY KEY (`Doctor_Staff_amka`, `Department_department_code`),
  INDEX `fk_Doctor_has_Department_Department1_idx` (`Department_department_code` ASC) VISIBLE,
  INDEX `fk_Doctor_has_Department_Doctor1_idx` (`Doctor_Staff_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Doctor_has_Department_Doctor1`
    FOREIGN KEY (`Doctor_Staff_amka`)
    REFERENCES `mydb`.`Doctor` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Doctor_has_Department_Department1`
    FOREIGN KEY (`Department_department_code`)
    REFERENCES `mydb`.`Department` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Insurance_Type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Insurance_Type` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Insurance_Type` (
  `insurance_provider` VARCHAR(255) NOT NULL,
  `Patient_patient_amka` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`Patient_patient_amka`),
  INDEX `fk_Insurance_Company_Patient1_idx` (`Patient_patient_amka` ASC) VISIBLE,
  UNIQUE INDEX `Patient_patient_amka_UNIQUE` (`Patient_patient_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Insurance_Company_Patient1`
    FOREIGN KEY (`Patient_patient_amka`)
    REFERENCES `mydb`.`Patient1` (`amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Shift_Type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Shift_Type` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Shift_Type` (
  `type_id` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `start_time` TIME NOT NULL,
  `end_time` TIME NOT NULL,
  PRIMARY KEY (`type_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Shifts`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Shifts` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Shifts` (
  `shift_id` INT NOT NULL AUTO_INCREMENT,
  `shift_date` DATE NOT NULL,
  `department_code` INT NOT NULL,
  `shift_type_id` INT NOT NULL,
  PRIMARY KEY (`shift_id`),
  INDEX `fk_Shifts_Department1_idx` (`department_code` ASC) VISIBLE,
  INDEX `fk_Shifts_Shift_Type1_idx` (`shift_type_id` ASC) VISIBLE,
  CONSTRAINT `fk_Shifts_Department1`
    FOREIGN KEY (`department_code`)
    REFERENCES `mydb`.`Department` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Shifts_Shift_Type1`
    FOREIGN KEY (`shift_type_id`)
    REFERENCES `mydb`.`Shift_Type` (`type_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Medicine`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Medicine` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Medicine` (
  `ema_code` VARCHAR(45) NOT NULL,
  `product_name` VARCHAR(100) NOT NULL,
  `active_substance` VARCHAR(255) NOT NULL,
  `route_of_administration` VARCHAR(255) NOT NULL,
  `product_authorisation_country` VARCHAR(255) NOT NULL,
  `marketing_authorization_holder` VARCHAR(255) NOT NULL,
  `pharmacovigilance_system_master_file_location` VARCHAR(255) NOT NULL,
  `pharmacovigilance_enquires_email_address` VARCHAR(255) NOT NULL,
  `pharmacovigilance_enquires_phone_number` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`ema_code`, `active_substance`),
  UNIQUE INDEX `ema_code_UNIQUE` (`ema_code` ASC) VISIBLE,
  UNIQUE INDEX `product_name_UNIQUE` (`product_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Prescription`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Prescription` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Prescription` (
  `prescription_id` VARCHAR(14) NOT NULL,
  `Patient_AMKA` VARCHAR(11) NOT NULL,
  `Doctor_Staff_AMKA` VARCHAR(11) NOT NULL,
  `Medicine_ema_code` VARCHAR(45) NOT NULL,
  `frequency` VARCHAR(45) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `dosage` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`prescription_id`, `Patient_AMKA`, `Doctor_Staff_AMKA`, `start_date`),
  INDEX `fk_Prescription_Patient1_idx` (`Patient_AMKA` ASC) VISIBLE,
  INDEX `fk_Prescription_Doctor1_idx` (`Doctor_Staff_AMKA` ASC) VISIBLE,
  INDEX `fk_Prescription_Medicine1_idx` (`Medicine_ema_code` ASC) VISIBLE,
  UNIQUE INDEX `Patient_AMKA_UNIQUE` (`Patient_AMKA` ASC) VISIBLE,
  UNIQUE INDEX `Doctor_Staff_AMKA_UNIQUE` (`Doctor_Staff_AMKA` ASC) VISIBLE,
  UNIQUE INDEX `Medicine_ema_code_UNIQUE` (`Medicine_ema_code` ASC) VISIBLE,
  CONSTRAINT `fk_Prescription_Patient1`
    FOREIGN KEY (`Patient_AMKA`)
    REFERENCES `mydb`.`Patient` (`AMKA`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prescription_Doctor1`
    FOREIGN KEY (`Doctor_Staff_AMKA`)
    REFERENCES `mydb`.`Doctor` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prescription_Medicine1`
    FOREIGN KEY (`Medicine_ema_code`)
    REFERENCES `mydb`.`Medicine` (`ema_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Lab_test_code`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Lab_test_code` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Lab_test_code` (
  `code` VARCHAR(15) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Laboratory_Test`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Laboratory_Test` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Laboratory_Test` (
  `test_id` INT NOT NULL AUTO_INCREMENT,
  `test_code` VARCHAR(15) NOT NULL,
  `hospitalisation_id` INT NOT NULL,
  `order_by_doctor` INT NOT NULL,
  `test_date` DATE NULL,
  `result_value` DECIMAL(10,3) NULL,
  `result_units` VARCHAR(45) NULL,
  `result_text` TEXT NULL,
  `cost` DECIMAL(10,2) NULL,
  PRIMARY KEY (`test_id`, `test_code`, `hospitalisation_id`, `order_by_doctor`),
  INDEX `fk_Laboratory_Test_Lab_test_code1_idx` (`test_code` ASC) VISIBLE,
  INDEX `fk_Laboratory_Test_Doctor1_idx` (`order_by_doctor` ASC) VISIBLE,
  INDEX `fk_Laboratory_Test_Hospitalisation1_idx` (`hospitalisation_id` ASC) VISIBLE,
  CONSTRAINT `fk_Laboratory_Test_Lab_test_code1`
    FOREIGN KEY (`test_code`)
    REFERENCES `mydb`.`Lab_test_code` (`code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Laboratory_Test_Doctor1`
    FOREIGN KEY (`order_by_doctor`)
    REFERENCES `mydb`.`Doctor` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Laboratory_Test_Hospitalisation1`
    FOREIGN KEY (`hospitalisation_id`)
    REFERENCES `mydb`.`Hospitalisation` (`hospitalization_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Operation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Operation` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Operation` (
  `operation_code` VARCHAR(15) NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `duration` INT NULL,
  `cost` DECIMAL(10,2) NULL,
  `category` VARCHAR(45) NULL,
  PRIMARY KEY (`operation_code`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Operating_Room`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Operating_Room` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Operating_Room` (
  `number` INT NOT NULL,
  `type` VARCHAR(45) NULL,
  PRIMARY KEY (`number`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Performed_Operation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Performed_Operation` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Performed_Operation` (
  `performed_op_id` INT NOT NULL AUTO_INCREMENT,
  `hospitalisation_id` INT NOT NULL,
  `operation_code` VARCHAR(15) NOT NULL,
  `Operating_Rooms_number` INT NOT NULL,
  `main_surgeon` INT NOT NULL,
  `start_time` DATETIME NOT NULL,
  `expected_end_time` DATETIME NOT NULL,
  PRIMARY KEY (`performed_op_id`, `hospitalisation_id`, `operation_code`, `Operating_Rooms_number`, `main_surgeon`),
  INDEX `fk_Performed_Operation_Hospitalisation1_idx` (`hospitalisation_id` ASC) VISIBLE,
  INDEX `fk_Performed_Operation_Operation1_idx` (`operation_code` ASC) VISIBLE,
  INDEX `fk_Performed_Operation_Operating_Rooms1_idx` (`Operating_Rooms_number` ASC) VISIBLE,
  INDEX `fk_Performed_Operation_Doctor1_idx` (`main_surgeon` ASC) VISIBLE,
  CONSTRAINT `fk_Performed_Operation_Hospitalisation1`
    FOREIGN KEY (`hospitalisation_id`)
    REFERENCES `mydb`.`Hospitalisation` (`hospitalization_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Performed_Operation_Operation1`
    FOREIGN KEY (`operation_code`)
    REFERENCES `mydb`.`Operation` (`operation_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Performed_Operation_Operating_Rooms1`
    FOREIGN KEY (`Operating_Rooms_number`)
    REFERENCES `mydb`.`Operating_Room` (`number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Performed_Operation_Doctor1`
    FOREIGN KEY (`main_surgeon`)
    REFERENCES `mydb`.`Doctor` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Operating_Assistants`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Operating_Assistants` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Operating_Assistants` (
  `Performed_Operation_performed_op_id` INT NOT NULL,
  PRIMARY KEY (`Performed_Operation_performed_op_id`),
  CONSTRAINT `fk_Operating_Assistants_Performed_Operation1`
    FOREIGN KEY (`Performed_Operation_performed_op_id`)
    REFERENCES `mydb`.`Performed_Operation` (`performed_op_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Hospital_Evaluation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Hospital_Evaluation` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Hospital_Evaluation` (
  `hospitalisation_id` INT NOT NULL,
  `nursing_quality` TINYINT(0) NULL,
  `cleanliness` TINYINT(0) NULL,
  `food_quality` TINYINT(0) NULL,
  `overall_experience` VARCHAR(45) NULL,
  `eval_date` DATE NULL,
  PRIMARY KEY (`hospitalisation_id`),
  CONSTRAINT `fk_Hospital_Evaluation_Hospitalisation1`
    FOREIGN KEY (`hospitalisation_id`)
    REFERENCES `mydb`.`Hospitalisation` (`hospitalization_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Active_Substances`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Active_Substances` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Active_Substances` (
  `substance_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`substance_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Allergy`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Allergy` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Allergy` (
  `Patient_AMKA` BIGINT(11) NOT NULL,
  `Active_Substances_substance_id` INT NOT NULL,
  `severity` VARCHAR(45) NULL,
  PRIMARY KEY (`Patient_AMKA`, `Active_Substances_substance_id`),
  INDEX `fk_Allergy_Active_Substances1_idx` (`Active_Substances_substance_id` ASC) VISIBLE,
  CONSTRAINT `fk_Allergy_Patient1`
    FOREIGN KEY (`Patient_AMKA`)
    REFERENCES `mydb`.`Patient` (`AMKA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Allergy_Active_Substances1`
    FOREIGN KEY (`Active_Substances_substance_id`)
    REFERENCES `mydb`.`Active_Substances` (`substance_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Doctor_Evaluation`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Doctor_Evaluation` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Doctor_Evaluation` (
  `hospitalisation_id` INT NOT NULL,
  `Doctor_Staff_amka` INT NOT NULL,
  `medical_care_quality` TINYINT(0) NULL,
  `eval_date` DATE NULL,
  PRIMARY KEY (`hospitalisation_id`, `Doctor_Staff_amka`),
  INDEX `fk_Doctor_Evaluation_Doctor1_idx` (`Doctor_Staff_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Doctor_Evaluation_Hospitalisation1`
    FOREIGN KEY (`hospitalisation_id`)
    REFERENCES `mydb`.`Hospitalisation` (`hospitalization_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Doctor_Evaluation_Doctor1`
    FOREIGN KEY (`Doctor_Staff_amka`)
    REFERENCES `mydb`.`Doctor` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Emergency_Contact`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Emergency_Contact` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Emergency_Contact` (
  `id_number` VARCHAR(10) NOT NULL,
  `first_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(45) NULL,
  `phone_number` BIGINT(14) NULL,
  `relationship` VARCHAR(45) NULL,
  `Patient_AMKA` BIGINT(11) NOT NULL,
  PRIMARY KEY (`id_number`),
  INDEX `fk_Emergency_Contact_Patient1_idx` (`Patient_AMKA` ASC) VISIBLE,
  CONSTRAINT `fk_Emergency_Contact_Patient1`
    FOREIGN KEY (`Patient_AMKA`)
    REFERENCES `mydb`.`Patient` (`AMKA`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Staff1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Staff1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Staff1` (
  `amka` VARCHAR(11) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `phone_number` BIGINT(12) NOT NULL,
  `hire_date` DATE NOT NULL,
  `staff_type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`amka`),
  UNIQUE INDEX `amka_UNIQUE` (`amka` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Doctor1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Doctor1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Doctor1` (
  `license_number` INT NOT NULL,
  `specialty` VARCHAR(45) NOT NULL,
  `rank_level` VARCHAR(45) NOT NULL,
  `supervisor_amka` VARCHAR(11) NULL,
  `Staff_amka` VARCHAR(11) NOT NULL,
  `monthly_shifts_worked` INT NOT NULL,
  `consecutive_shifts` INT NOT NULL,
  INDEX `fk_Doctor_Staff_idx` (`Staff_amka` ASC) VISIBLE,
  PRIMARY KEY (`Staff_amka`),
  INDEX `fk_Doctor_Doctor1_idx` (`supervisor_amka` ASC) VISIBLE,
  UNIQUE INDEX `license_number_UNIQUE` (`license_number` ASC) VISIBLE,
  UNIQUE INDEX `Staff_amka_UNIQUE` (`Staff_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Doctor_Staff`
    FOREIGN KEY (`Staff_amka`)
    REFERENCES `mydb`.`Staff1` (`amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Doctor_Supervisor`
    FOREIGN KEY (`supervisor_amka`)
    REFERENCES `mydb`.`Doctor1` (`Staff_amka`)
    ON DELETE SET NULL
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Department1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Department1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Department1` (
  `department_code` INT NOT NULL,
  `name` VARCHAR(45) NOT NULL,
  `description` VARCHAR(255) NOT NULL,
  `number_of_beds` INT NOT NULL,
  `building_floor` VARCHAR(45) NOT NULL,
  `department_head` VARCHAR(11) NOT NULL,
  `building` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`department_code`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC) VISIBLE,
  INDEX `fk_Department_Doctor1_idx` (`department_head` ASC) VISIBLE,
  UNIQUE INDEX `department_head_UNIQUE` (`department_head` ASC) VISIBLE,
  UNIQUE INDEX `department_code_UNIQUE` (`department_code` ASC) VISIBLE,
  CONSTRAINT `fk_Department_Doctor1`
    FOREIGN KEY (`department_head`)
    REFERENCES `mydb`.`Doctor1` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Nurse1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Nurse1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Nurse1` (
  `rank` VARCHAR(45) NOT NULL,
  `department_code` INT NOT NULL,
  `Staff_amka` VARCHAR(11) NOT NULL,
  `monthly_shifts_worked` INT NOT NULL,
  `consecutive_shifts` INT NOT NULL,
  PRIMARY KEY (`Staff_amka`),
  INDEX `fk_Nurse_Department1_idx` (`department_code` ASC) VISIBLE,
  UNIQUE INDEX `Staff_amka_UNIQUE` (`Staff_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Nurse_Staff1`
    FOREIGN KEY (`Staff_amka`)
    REFERENCES `mydb`.`Staff1` (`amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Nurse_Department1`
    FOREIGN KEY (`department_code`)
    REFERENCES `mydb`.`Department1` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Administrative_staff1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Administrative_staff1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Administrative_staff1` (
  `position` VARCHAR(45) NOT NULL,
  `office` VARCHAR(45) NOT NULL,
  `department_code` INT NOT NULL,
  `Staff_amka` VARCHAR(11) NOT NULL,
  `monthly_shifts_worked` INT NOT NULL,
  `consecutive_shifts` INT NOT NULL,
  PRIMARY KEY (`Staff_amka`),
  INDEX `fk_Administrator_Department1_idx` (`department_code` ASC) VISIBLE,
  UNIQUE INDEX `Staff_amka_UNIQUE` (`Staff_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Administrator_Staff1`
    FOREIGN KEY (`Staff_amka`)
    REFERENCES `mydb`.`Staff1` (`amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Administrator_Department1`
    FOREIGN KEY (`department_code`)
    REFERENCES `mydb`.`Department1` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Beds1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Beds1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Beds1` (
  `id_number` INT NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NOT NULL,
  `status` VARCHAR(45) NOT NULL,
  `Department_department_code` INT NOT NULL,
  PRIMARY KEY (`id_number`, `Department_department_code`),
  UNIQUE INDEX `id_number_UNIQUE` (`id_number` ASC) VISIBLE,
  INDEX `fk_Beds_Department1_idx` (`Department_department_code` ASC) VISIBLE,
  CONSTRAINT `fk_Beds_Department1`
    FOREIGN KEY (`Department_department_code`)
    REFERENCES `mydb`.`Department1` (`department_code`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Patient1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Patient1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Patient1` (
  `amka` VARCHAR(11) NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `fathers_name` VARCHAR(45) NOT NULL,
  `date_of_birth` DATE NOT NULL,
  `sex` VARCHAR(1) NOT NULL,
  `weight` DECIMAL(5,2) NOT NULL,
  `height` DECIMAL(5,2) NOT NULL,
  `address` VARCHAR(255) NOT NULL,
  `phone_number` VARCHAR(12) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `occupation` VARCHAR(45) NOT NULL,
  `nationality` VARCHAR(45) NOT NULL,
  `emergency_contact_first_name` VARCHAR(45) NULL,
  `emergency_contact_last_name` VARCHAR(45) NULL,
  `emergency_contact_relationship` VARCHAR(45) NULL,
  `emergency_contact_phone_number` INT(10) NULL,
  `allergies` VARCHAR(45) NULL,
  PRIMARY KEY (`amka`),
  UNIQUE INDEX `amka_UNIQUE` (`amka` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Hospitalization`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Hospitalization` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Hospitalization` (
  `Patient_amka` VARCHAR(11) NOT NULL,
  `Department_department_code` INT NOT NULL,
  `Beds_id_number` INT NOT NULL,
  `admission_date` DATE NOT NULL,
  `discharge_date` DATE NULL,
  `admission_diagnosis_ICD` VARCHAR(7) NOT NULL,
  `discharge_diagnosis_ICD` VARCHAR(7) NULL,
  `admission_diagnosis_description` VARCHAR(255) NOT NULL,
  `discharge_diagnosis_description` VARCHAR(255) NULL,
  PRIMARY KEY (`Patient_amka`, `admission_date`),
  INDEX `fk_Hospitalisation_Department1_idx` (`Department_department_code` ASC) VISIBLE,
  INDEX `fk_Hospitalisation_Beds1_idx` (`Beds_id_number` ASC) VISIBLE,
  CONSTRAINT `fk_Hospitalisation_Patient1`
    FOREIGN KEY (`Patient_amka`)
    REFERENCES `mydb`.`Patient1` (`amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hospitalisation_Department1`
    FOREIGN KEY (`Department_department_code`)
    REFERENCES `mydb`.`Department1` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hospitalisation_Beds1`
    FOREIGN KEY (`Beds_id_number`)
    REFERENCES `mydb`.`Beds1` (`id_number`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Doctor_has_Department1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Doctor_has_Department1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Doctor_has_Department1` (
  `Doctor_Staff_amka` VARCHAR(11) NOT NULL,
  `Department_department_code` INT NOT NULL,
  PRIMARY KEY (`Doctor_Staff_amka`, `Department_department_code`),
  INDEX `fk_Doctor_has_Department_Department1_idx` (`Department_department_code` ASC) VISIBLE,
  INDEX `fk_Doctor_has_Department_Doctor1_idx` (`Doctor_Staff_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Doctor_has_Department_Doctor1`
    FOREIGN KEY (`Doctor_Staff_amka`)
    REFERENCES `mydb`.`Doctor1` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Doctor_has_Department_Department1`
    FOREIGN KEY (`Department_department_code`)
    REFERENCES `mydb`.`Department1` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Insurance_Type`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Insurance_Type` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Insurance_Type` (
  `insurance_provider` VARCHAR(255) NOT NULL,
  `Patient_patient_amka` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`Patient_patient_amka`),
  INDEX `fk_Insurance_Company_Patient1_idx` (`Patient_patient_amka` ASC) VISIBLE,
  UNIQUE INDEX `Patient_patient_amka_UNIQUE` (`Patient_patient_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Insurance_Company_Patient1`
    FOREIGN KEY (`Patient_patient_amka`)
    REFERENCES `mydb`.`Patient1` (`amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`On_Duty`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`On_Duty` ;

CREATE TABLE IF NOT EXISTS `mydb`.`On_Duty` (
  `Department_department_code` INT NOT NULL,
  `Administrative_staff_Staff_administrative_staff_amka` VARCHAR(11) NOT NULL,
  `Nurse_Staff_nurse_amka` VARCHAR(11) NOT NULL,
  `Doctor_Staff_doctor_amka` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`Department_department_code`, `Administrative_staff_Staff_administrative_staff_amka`, `Nurse_Staff_nurse_amka`, `Doctor_Staff_doctor_amka`),
  INDEX `fk_on_duty_Department1_idx` (`Department_department_code` ASC) VISIBLE,
  INDEX `fk_on_duty_Administrative_staff1_idx` (`Administrative_staff_Staff_administrative_staff_amka` ASC) VISIBLE,
  INDEX `fk_on_duty_Nurse1_idx` (`Nurse_Staff_nurse_amka` ASC) VISIBLE,
  INDEX `fk_on_duty_Doctor1_idx` (`Doctor_Staff_doctor_amka` ASC) VISIBLE,
  UNIQUE INDEX `Administrative_staff_Staff_staff_amka_UNIQUE` (`Administrative_staff_Staff_administrative_staff_amka` ASC) VISIBLE,
  UNIQUE INDEX `Nurse_Staff_nurse_amka_UNIQUE` (`Nurse_Staff_nurse_amka` ASC) VISIBLE,
  UNIQUE INDEX `Doctor_Staff_doctor_amka_UNIQUE` (`Doctor_Staff_doctor_amka` ASC) VISIBLE,
  CONSTRAINT `fk_on_duty_Department1`
    FOREIGN KEY (`Department_department_code`)
    REFERENCES `mydb`.`Department1` (`department_code`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_on_duty_Administrative_staff1`
    FOREIGN KEY (`Administrative_staff_Staff_administrative_staff_amka`)
    REFERENCES `mydb`.`Administrative_staff1` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_on_duty_Nurse1`
    FOREIGN KEY (`Nurse_Staff_nurse_amka`)
    REFERENCES `mydb`.`Nurse1` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_on_duty_Doctor1`
    FOREIGN KEY (`Doctor_Staff_doctor_amka`)
    REFERENCES `mydb`.`Doctor1` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Shifts1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Shifts1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Shifts1` (
  `morning_shift_start` TIME NOT NULL,
  `afternoon_shift_start` TIME NULL,
  `night_shift_start` TIME NULL,
  `morning_shift_end` TIME NULL,
  `afternoon_shift_end` TIME NULL,
  `night_shift_end` TIME NULL,
  `on_duty_Department_department_code` INT NOT NULL,
  `on_duty_Administrative_staff_Staff_amka` VARCHAR(11) NOT NULL,
  `on_duty_Nurse_Staff_amka` VARCHAR(11) NOT NULL,
  `on_duty_Doctor_Staff_amka` VARCHAR(11) NOT NULL,
  PRIMARY KEY (`morning_shift_start`, `on_duty_Department_department_code`, `on_duty_Administrative_staff_Staff_amka`, `on_duty_Nurse_Staff_amka`, `on_duty_Doctor_Staff_amka`),
  INDEX `fk_shifts_on_duty1_idx` (`on_duty_Department_department_code` ASC, `on_duty_Administrative_staff_Staff_amka` ASC, `on_duty_Nurse_Staff_amka` ASC, `on_duty_Doctor_Staff_amka` ASC) VISIBLE,
  CONSTRAINT `fk_shifts_on_duty1`
    FOREIGN KEY (`on_duty_Department_department_code` , `on_duty_Administrative_staff_Staff_amka` , `on_duty_Nurse_Staff_amka` , `on_duty_Doctor_Staff_amka`)
    REFERENCES `mydb`.`On_Duty` (`Department_department_code` , `Administrative_staff_Staff_administrative_staff_amka` , `Nurse_Staff_nurse_amka` , `Doctor_Staff_doctor_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Cost_Calculation1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Cost_Calculation1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Cost_Calculation1` (
  `KEN` VARCHAR(5) NOT NULL,
  `base_cost` INT NOT NULL,
  `MDN` INT NOT NULL,
  `Hospitalization_Patient_patient_amka` VARCHAR(11) NOT NULL,
  `total_cost` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`KEN`, `Hospitalization_Patient_patient_amka`),
  INDEX `fk_Cost_Calculation_Hospitalization1_idx` (`Hospitalization_Patient_patient_amka` ASC) VISIBLE,
  UNIQUE INDEX `Hospitalization_Patient_patient_amka_UNIQUE` (`Hospitalization_Patient_patient_amka` ASC) VISIBLE,
  CONSTRAINT `fk_Cost_Calculation_Hospitalization1`
    FOREIGN KEY (`Hospitalization_Patient_patient_amka`)
    REFERENCES `mydb`.`Hospitalization` (`Patient_amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Medicine1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Medicine1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Medicine1` (
  `medicine_name` VARCHAR(255) NOT NULL,
  `active_substance` VARCHAR(255) NOT NULL,
  `route_of_administration` VARCHAR(255) NOT NULL,
  `product_authorization_country` VARCHAR(255) NOT NULL,
  `marketing_authorization_holder` VARCHAR(255) NOT NULL,
  `pharmacovigilance_system_master_file_location` VARCHAR(255) NOT NULL,
  `pharmacovigilance_enquiries_email_address` VARCHAR(255) NOT NULL,
  `pharmacovigilance_enquiries_telephone_number` VARCHAR(20) NOT NULL,
  PRIMARY KEY (`medicine_name`, `active_substance`),
  UNIQUE INDEX `medicine_name_UNIQUE` (`medicine_name` ASC) VISIBLE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `mydb`.`Prescription1`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `mydb`.`Prescription1` ;

CREATE TABLE IF NOT EXISTS `mydb`.`Prescription1` (
  `id` VARCHAR(255) NOT NULL,
  `dosage` VARCHAR(45) NOT NULL,
  `frequency` VARCHAR(45) NOT NULL,
  `start_date` DATE NOT NULL,
  `end_date` DATE NULL,
  `Patient_patient_amka` VARCHAR(11) NOT NULL,
  `Doctor_Staff_doctor_amka` VARCHAR(11) NOT NULL,
  `Medicine_medicine_name` VARCHAR(255) NOT NULL,
  `Medicine_medicine_active_substance` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `start_date_UNIQUE` (`start_date` ASC) VISIBLE,
  INDEX `fk_Prescription_Patient1_idx` (`Patient_patient_amka` ASC) VISIBLE,
  INDEX `fk_Prescription_Doctor1_idx` (`Doctor_Staff_doctor_amka` ASC) VISIBLE,
  UNIQUE INDEX `Doctor_Staff_amka_UNIQUE` (`Doctor_Staff_doctor_amka` ASC) VISIBLE,
  UNIQUE INDEX `Patient_amka_UNIQUE` (`Patient_patient_amka` ASC) VISIBLE,
  INDEX `fk_Prescription_Medicine1_idx` (`Medicine_medicine_name` ASC, `Medicine_medicine_active_substance` ASC) VISIBLE,
  UNIQUE INDEX `Medicine_medicine_name_UNIQUE` (`Medicine_medicine_name` ASC) VISIBLE,
  UNIQUE INDEX `id_UNIQUE` (`id` ASC) VISIBLE,
  CONSTRAINT `fk_Prescription_Patient1`
    FOREIGN KEY (`Patient_patient_amka`)
    REFERENCES `mydb`.`Patient1` (`amka`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prescription_Doctor1`
    FOREIGN KEY (`Doctor_Staff_doctor_amka`)
    REFERENCES `mydb`.`Doctor1` (`Staff_amka`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Prescription_Medicine1`
    FOREIGN KEY (`Medicine_medicine_name` , `Medicine_medicine_active_substance`)
    REFERENCES `mydb`.`Medicine1` (`medicine_name` , `active_substance`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
