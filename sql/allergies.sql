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
  CONSTRAINT 'fk_patient_id_allergy' FOREIGN KEY (patient_id) REFERENCES Patient(patient_AMKA) ON DELETE CASCADE ON UPDATE CASCADE
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
    CONSTRAINT 'fk_patient_id_prescription' FOREIGN KEY(patient_AMKA) REFERENCES Patient(patient_AMKA),
    CONSTRAINT 'fk_doctor_id_prescription' FOREIGN KEY(doctor_AMKA) REFERENCES Doctor(doctor_AMKA),
    CONSTRAINT 'fk_medicine_id_prescription' FOREIGN KEY(medicine_id) REFERENCES Drug_Info_Active_Substance(id),
    CONSTRAINT 'fk_hospitalization_id_prescription' FOREIGN KEY(hospitalization_id) REFERENCES Hospitalization(hospitalization_id),
    CHECK(starting_date < end_date)
);

DELIMITER $$
--CHECK IF PATIENT HOSPITALIZED IN ORDER TO GET PRESCRIBED
CREATE TRIGGER check_if_hospitalized BEFORE INSERT ON Prescription
FOR EACH ROW
BEGIN
  IF (SELECT hospitalization_id FROM Hospitalization WHERE hospitalization_id = NEW.hospitalization_id) IS NULL THEN
    SIGNAL_SQLSTATE '45000'
      SET MESSAGE_TEXT = 'To prescribe medicines, patient must be hospitalized.';
  END IF;
END$$


DROP TRIGGER IF EXISTS `check_allergies_upd`;
--CHECK IF PATIENT OR MEDICINE CHANGED, WE DONT MIND UPDATING THE REST
CREATE TRIGGER `check_allergies_upd` BEFORE UPDATE ON Prescription
FOR EACH ROW
BEGIN
  DECLARE is_allergic INT DEAFULT 0;
  IF (NEW.medication_id != OLD.medication_id) OR (NEW.patient_AMKA!=OLD.patient_AMKA) THEN
    SELECT COUNT(*) INTO is_allergic FROM Drug_Info_Active_Substance drug JOIN Patient_Allergy allergy ON drug.active_substance = allergy.active_substance_allergy_name
    WHERE (drug.id = NEW.medicine_id) AND (allergy.patiend_id = NEW.patient_AMKA);
    IF is_allergic > 0 THEN
      SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Updated medicine or patient caused allergy flag.'
    END IF;
END$$

DROP TRIGGER IF EXISTS `check_allergies_ins`;
--edw ginetai kai me if exists gia na mhn xanw xrono na apothhkeuw sto is_allergic kai na metraw ola ta instances
CREATE TRIGGER `check_allergies_ins` BEFORE INSERT ON Prescription
FOR EACH ROW
BEGIN
  DECLARE is_allergic INT DEFAULT 0;
  SELECT COUNT(*) INTO is_allergic FROM Drug_Info_Active_Substance drug JOIN Patient_Allergy allergy ON drug.active_substance = allergy.active_substance_allergy_name
  WHERE (drug.id = NEW.medicine_id) AND (allergy.patient_id = NEW.patient_AMKA);
  IF is_allergic > 0 THEN 
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Patient is allergic to this drug.';
  END IF;
END$$