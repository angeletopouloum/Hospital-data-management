--epeigonta peristatika - dialogh
DROP TABLE IF EXISTS Outcome;

CREATE TABLE IF NOT EXISTS Outcome (
  outcome_id INT NOT NULL AUTO_INCREMENT,
  outcome_description VARCHAR(45) NOT NULL ON DEFAULT 'Waiting',
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
  CONSTRAINT fk_Nurse FOREIGN KEY (nurse_AMKA) REFERENCES Nurse(nurse_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE,
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
  lab_code VARCHAR(45) NOT NULL UNIQUE, --pisteuw prepei na einai unique giati alliws dyo ejetaseis borei na exoun idio onoma alla allo kostos, de xerw
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

DROP TABLE IF EXISTS Assistant_Staff;

CREATE TABLE IF NOT EXISTS Assistant_Staff(
  operation_id INT NOT NULL,
  assistant_staff_id VARCHAR(11) NOT NULL,
  PRIMARY KEY (operation_id, assistant_staff_id),
  CONSTRAINT fk_operation FOREIGN KEY (operation_id) REFERENCES Operation(operation_id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_assistant_staff FOREIGN KEY (assistant_staff_id) REFERENCES Staff(staff_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE, --Tha boruse na bei staff id  
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

--ratings

DROP TABLE IF EXISTS Hospital_Evaluation;

CREATE_TABLE IF NOT EXISTS Hospital_Evaluation(
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


DELIMITER $$
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
  IF old_outcome_name = 'Waiting' AND new_outcome_name != 'Waiting' THEN
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
    SIGNAL_SQLSTATE '45000'
      SET MESSAGE_TEXT = 'To perform operation patient must be hospitalized.';
  END IF;
END$$

--edw mporw na prosthesw to discharge date an einai megalutero apo to start date ths epemvashs
CREATE TRIGGER check_if_hospitalized BEFORE INSERT ON Lab_Work
FOR EACH ROW
BEGIN
  IF (SELECT hospitalization_id FROM Hospitalization WHERE hospitalization_id = NEW.hospitalization_id) IS NULL THEN
    SIGNAL_SQLSTATE '45000'
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
  --DECLARE surgeon_id_new VARCHAR(11);
  SELECT COUNT(*) INTO conflict FROM Operation WHERE (operation_id != NEW.operation_id) 
  AND (surgeon_id = NEW.assistant_staff_id) AND (expected_end_time > starts) AND (start_time < end_time);
  IF conflict > 0 THEN 
    SIGNAL SQLSTATE '45000'
      SET MESSAGE_TEXT = 'Assistant staff cannot be the main surgeon.';
  END IF;
END$$


