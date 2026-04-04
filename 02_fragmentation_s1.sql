DROP TABLE IF EXISTS Patient_S1 CASCADE;
DROP TABLE IF EXISTS Patient_Info_S1 CASCADE;
DROP TABLE IF EXISTS Patient_Contact_S1 CASCADE;
DROP TABLE IF EXISTS Medecin_S1 CASCADE;
DROP TABLE IF EXISTS Consultation_S1 CASCADE;
DROP TABLE IF EXISTS Prescription_S1 CASCADE;
DROP TABLE IF EXISTS LignePrescription_S1 CASCADE;
DROP TABLE IF EXISTS Medicament_Prix_S1 CASCADE;
DROP TABLE IF EXISTS Stock_S1 CASCADE;
DROP TABLE IF EXISTS Vente_S1 CASCADE;
DROP TABLE IF EXISTS LigneVente_S1 CASCADE;

CREATE TABLE Patient_S1
AS SELECT * FROM s3_schema."Patient"
WHERE ville = 'Casablanca';

CREATE TABLE Patient_Info_S1
AS SELECT "idPatient", "nomPatient", "prenomPatient", "dateNaissance",sexe
FROM Patient_S1;

CREATE TABLE Patient_Contact_S1
AS SELECT "idPatient",telephone, adresse, ville
FROM Patient_S1;

CREATE TABLE Medecin_S1
AS SELECT * FROM s3_schema."Medecin"
WHERE ville = 'Casablanca';

CREATE TABLE Consultation_S1
AS SELECT * FROM s3_schema."Consultation"
WHERE "idMedecin" IN (SELECT "idMedecin" FROM Medecin_S1);

CREATE TABLE Prescription_S1
AS SELECT * FROM s3_schema."Prescription"
WHERE "idConsultation" IN (SELECT "idConsultation" FROM Consultation_S1);

CREATE TABLE LignePrescription_S1
AS SELECT * FROM s3_schema."LignePrescription"
WHERE "idPrescription" IN (SELECT "idPrescription" FROM Prescription_S1);

CREATE TABLE Medicament_Prix_S1
AS SELECT "idMedicament", "prixUnitaire"
FROM s3_schema."Medicament";

CREATE TABLE Stock_S1
AS SELECT * FROM s3_schema."Stock"
WHERE ville = 'Casablanca';

CREATE TABLE Vente_S1
AS SELECT * FROM s3_schema."Vente"
WHERE ville = 'Casablanca';

CREATE TABLE LigneVente_S1
AS SELECT * FROM s3_schema."LigneVente"
WHERE "idVente" in (SELECT "idVente" FROM Vente_S1);

DROP TRIGGER IF EXISTS trigger_patient_s1 ON s3_schema."Patient";
DROP TRIGGER IF EXISTS trigger_medecin_s1 ON Medecin_S1;
DROP TRIGGER IF EXISTS trigger_medicament_s1 ON s3_schema."Medicament";
DROP TRIGGER IF EXISTS trigger_stock_s1 ON Stock_S1;
DROP TRIGGER IF EXISTS trigger_vente_s1 ON Vente_S1;

-- Patient
CREATE OR REPLACE FUNCTION process_patient_s1()
RETURNS TRIGGER AS $$BEGIN
    IF NEW.ville = 'Casablanca' THEN
        INSERT INTO Patient_Info_S1 ("idPatient", "nomPatient", "prenomPatient", "dateNaissance", sexe)
        VALUES (NEW."idPatient", NEW."nomPatient", NEW."prenomPatient", NEW."dateNaissance", NEW."sexe");
        
        INSERT INTO Patient_Contact_S1 ("idPatient", telephone, adresse, ville)
        VALUES (NEW."idPatient", NEW."telephone", NEW."adresse", NEW."ville");
    ELSIF NEW.ville = 'Rabat' THEN
        INSERT INTO rabat_schema.Patient_Info_S2 ("idPatient", "nomPatient", "prenomPatient", "dateNaissance", sexe)
        VALUES (NEW."idPatient", NEW."nomPatient", NEW."prenomPatient", NEW."dateNaissance", NEW."sexe");
        
        INSERT INTO rabat_schema.Patient_Contact_S2 ("idPatient", "telephone", "adresse", "ville")
        VALUES (NEW."idPatient", NEW."telephone", NEW."adresse", NEW."ville");
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_patient_s1
BEFORE INSERT ON s3_schema."Patient"
FOR EACH ROW
EXECUTE FUNCTION process_patient_s1();

-- Medecin
CREATE OR REPLACE FUNCTION process_medecin_s1()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.ville = 'Casablanca' THEN
        RETURN NEW;
    ELSIF NEW.ville = 'Rabat' THEN
        INSERT INTO rabat_schema.Medecin_S2 VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_medecin_s1
BEFORE INSERT 
ON Medecin_S1
FOR EACH ROW EXECUTE FUNCTION process_medecin_s1();

-- Medicament
CREATE OR REPLACE FUNCTION process_medicament_s1()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO Medicament_Prix_S1 ("idMedicament", "prixUnitaire")
    VALUES (NEW."idMedicament", NEW."prixUnitaire");
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_medicament_s1
BEFORE INSERT
ON s3_schema."Medicament"
FOR EACH ROW EXECUTE FUNCTION process_medicament_s1();

-- Stock
CREATE OR REPLACE FUNCTION process_stock_s1()
RETURNS TRIGGER AS $$BEGIN
    IF NEW.ville = 'Casablanca' THEN
        RETURN NEW;
    ELSIF NEW.ville = 'Rabat' THEN
        INSERT INTO rabat_schema.Stock_S2 VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_stock_s1
BEFORE INSERT ON Stock_S1
FOR EACH ROW EXECUTE FUNCTION process_stock_s1();

-- Vente
CREATE OR REPLACE FUNCTION process_vente_s1()
RETURNS TRIGGER AS $$BEGIN
    IF NEW.ville = 'Casablanca' THEN
        RETURN NEW;
    ELSIF NEW.ville = 'Rabat' THEN
        INSERT INTO rabat_schema.Vente_S2 VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER trigger_vente_s1
BEFORE INSERT ON Vente_S1
FOR EACH ROW EXECUTE FUNCTION process_vente_s1();