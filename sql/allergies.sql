DROP TABLE IF EXISTS Active_Substances;

CREATE TABLE IF NOT EXISTS Active_Substances(
  id INT NOT NULL AUTO_INCREMENT,
  product_name VARCHAR(45) NOT NULL,
  active_substance VARCHAR(45) NOT NULL,
  PRIMARY KEY(id)
);

DROP TABLE IF EXISTS Patient_Allergy;

CREATE TABLE IF NOT EXISTS Patient_Allergy(
  allergy_id INT NOT NULL AUTO_INCREMENT,
  patient_id VARCHAR(11) NOT NULL,
  medicine_ema_code VARCHAR(15) NOT NULL,
  PRIMARY KEY(allergy_id),
  CONSTRAINT fk_patient_allergy FOREIGN KEY (patient_id) REFERENCES Patient(patient_AMKA) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_medicine_allergy FOREIGN KEY (medicine_ema_code) REFERENCES Medicine(medicine_ema_code) ON DELETE RESTRICT ON UPDATE CASCADE
);

DELIMITER $$
DROP TRIGGER IF EXISTS `check_allergies_upd`;

CREATE TRIGGER `check_allergies_upd` BEFORE UPDATE ON Prescription
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT (SELECT medicine_ema_code FROM Patient_Allergy WHERE patient_id = new.patient_id)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot Prescribe medicine the patient is allergic to.';
    END IF;
END$$

DROP TRIGGER IF EXISTS `check_allergies_ins`;

CREATE TRIGGER `check_allergies_ins` BEFORE INSERT ON Prescription
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT (SELECT medicine_ema_code FROM Patient_Allergy WHERE patient_id = new.patient_id)) THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Cannot Prescribe medicine the patient is allergic to.';
    END IF;
END$$