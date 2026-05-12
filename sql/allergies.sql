DROP TABLE IF EXISTS Drug_Info_Active_Substance;
--isws na vgalw to id giati sto prescription exw to product name pou zhtaei h ekfwnhsh
CREATE TABLE IF NOT EXISTS Drug_Info_Active_Substance(
  id INT NOT NULL AUTO_INCREMENT,
  product_name VARCHAR(45) NOT NULL, --thewrw oti an exw 2 paraplhsia alla diaforetika farmaka tha exoun allo onoma
  active_substance VARCHAR(45) NOT NULL, --borw na kanw add kai alles plhrofories an thelw
  PRIMARY KEY(id), --or PRIMARY KEY(product_name, country)
  country VARCHAR(45) NOT NULL,
  UNIQUE(product_name, active_substance, country)
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
    medicine_name VARCHAR(45) NOT NULL,
    product_autorization_country VARCHAR(255) NOT NULL,
    UNIQUE(doctor_AMKA, patient_AMKA, medicine_name, starting_date),
    PRIMARY KEY(prescription_id), -- OR PRIMARY KEY(doctor_AMKA, patient_AMKA, medicine_name, starting_date)
    CONSTRAINT 'fk_patient_id_prescription' FOREIGN KEY(patient_AMKA) REFERENCES Patient(patient_AMKA),
    CONSTRAINT 'fk_doctor_id_prescription' FOREIGN KEY(doctor_AMKA) REFERENCES Doctor(doctor_AMKA),
    CHECK(starting_date < end_date)
);



DELIMITER $$
DROP TRIGGER IF EXISTS 'check_medicine_name_prescription';

CREATE TRIGGER 'check_medicine_name_prescription' BEFORE INSERT ON Prescription




DROP TRIGGER IF EXISTS `check_allergies_upd`;

CREATE TRIGGER `check_allergies_upd` BEFORE UPDATE ON Prescription
FOR EACH ROW
BEGIN
    
END$$

DROP TRIGGER IF EXISTS `check_allergies_ins`;

CREATE TRIGGER `check_allergies_ins` BEFORE INSERT ON Prescription
FOR EACH ROW
BEGIN
  DECLARE is_allergic INT DEFAULT 0;
  SELECT COUNT(*) INTO is_allergic FROM Drug_Info_Active_Substance drug JOIN Patient_Allergy allergy ON drug.active_substance = allergy.active_substance_allergy_name
  WHERE (drug.product_name = NEW.medicine_name) AND (allergy.patient_id = NEW.patient_AMKA);
  IF is_allergic > 0 THEN 
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Patient is allergic to this drug.';
  END IF;

    
END$$