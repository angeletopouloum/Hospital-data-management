--epeigonta peristatika - dialogh // ta tables triggers ta kanw se jexwrista files
DROP TABLE IF EXISTS Triage;

CREATE TABLE IF NOT EXISTS Triage (
  triage_id INT NOT NULL AUTO_INCREMENT, 
  arrival_time DATETIME NOT NULL,
  symptoms TEXT NOT NULL, 
  urgency_level INT NOT NULL,
  patient_AMKA VARCHAR(11) NOT NULL,
  nurse_AMKA VARCHAR(11) NOT NULL,
  position INT DEFAULT NULL,
  outcome INT NOT NULL,
  hospitalization_id VARCHAR(11) DEFAULT NULL,
  department VARCHAR(45) NOT NULL,
  PRIMARY KEY(triage_id),
  CONSTRAINT fk_Nurse FOREIGN KEY (nurse_AMKA) REFERENCES Nurse(nurse_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_patient FOREIGN KEY (patient_AMKA) REFERENCES Patient(patient_AMKA) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT fk_urgency_level FOREIGN KEY (urgency_level) REFERENCES Urgency_Level(level_id) ON DELETE RESTRICT,
  --CONSTRAINT chk_urgency_level CHECK (urgency_level in (1, 2, 3, 4, 5)),
  CONSTRAINT fk_outcome FOREIGN KEY (outcome) REFERENCES Outcome(outcome_id),
  CONSTRAINT fk_triage_hospitalization FOREIGN KEY (hospitalization_id) 
  REFERENCES Hospitalization(hospitalization_id),
  CONSTRAINT fk_department_triage FOREIGN KEY (department) REFERENCES Department(department_name)
  --CONSTRAINT chk_outcome CHECK (outcome in ('Admitted', 'Discharged'))
);

DROP TABLE IF EXISTS Urgency_Level;

CREATE TABLE IF NOT EXISTS Urgency_Level (
  level_id INT AUTO_INCREMENT NOT NULL,
  urgency_name VARCHAR(45) NOT NULL,
  priority_num INT NOT NULL,
  PRIMARY KEY (level_id),
  CONSTRAINT chk_urgency_name CHECK (urgency_name in ('Immediate', 'Emergent', 'Necessary', 'Important', 'Not Emergent')),
  CONSTRAINT chk_priority_num CHECK (priority_num in (1, 2, 3, 4, 5))
);

DROP TABLE IF EXISTS Outcome;

CREATE TABLE IF NOT EXISTS Outcome (
  outcome_id INT NOT NULL AUTO_INCREMENT,
  outcome_description VARCHAR(45) NOT NULL,
  outcome_odhgies TEXT DEFAULT NULL,
  CONSTRAINT chk_outcome_description CHECK (outcome_description in ('Admitted', 'Discharged')),
  PRIMARY KEY (outcome_id)
);

CREATE TRIGGER change_position AFTER INSERT ON Triage
FOR EACH ROW
BEGIN
  DECLARE new_priority INT;
  DECLARE queue_position INT DEFAULT 1;
  SELECT priority_num INTO new_priority 
  FROM Urgency_Level 
  WHERE level_id = NEW.urgency_level;
  SELECT COUNT(*) + 1 INTO queue_position
  FROM Triage t
  JOIN Urgency_Level ul ON t.urgency_level = ul.level_id
  WHERE (ul.priority_num < new_priority) 
     OR (ul.priority_num = new_priority AND t.arrival_time < NEW.arrival_time);
  SET NEW.position = queue_position;
END$$


