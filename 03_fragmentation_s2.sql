DROP TABLE IF EXISTS Patient_S2 CASCADE;
DROP TABLE IF EXISTS Patient_Info_S2 CASCADE;
DROP TABLE IF EXISTS Patient_Contact_S2 CASCADE;
DROP TABLE IF EXISTS Medecin_S2 CASCADE;
DROP TABLE IF EXISTS Consultation_S2 CASCADE;
DROP TABLE IF EXISTS Prescription_S2 CASCADE;
DROP TABLE IF EXISTS LignePrescription_S2 CASCADE;
DROP TABLE IF EXISTS Medicament_Prix_S2 CASCADE;
DROP TABLE IF EXISTS Stock_S2 CASCADE;
DROP TABLE IF EXISTS Vente_S2 CASCADE;
DROP TABLE IF EXISTS LigneVente_S2 CASCADE;

CREATE TABLE Patient_S2
AS SELECT * FROM s3_schema."Patient"
WHERE ville = 'Rabat';

CREATE TABLE Patient_Info_S2
AS SELECT "idPatient", "nomPatient", "prenomPatient", "dateNaissance", "sexe"
FROM Patient_S2;

CREATE TABLE Patient_Contact_S2
AS SELECT "idPatient","telephone", "adresse", "ville"
FROM Patient_S2;

CREATE TABLE Medecin_S2
AS SELECT * FROM s3_schema."Medecin"
WHERE ville = 'Rabat';

CREATE TABLE Consultation_S2
AS SELECT * FROM s3_schema."Consultation"
WHERE "idMedecin" IN (SELECT "idMedecin" FROM Medecin_S2);

CREATE TABLE Prescription_S2
AS SELECT * FROM s3_schema."Prescription"
WHERE "idConsultation" IN (SELECT "idConsultation" FROM Consultation_S2);

CREATE TABLE LignePrescription_S2
AS SELECT * FROM s3_schema."LignePrescription"
WHERE "idPrescription" IN (SELECT "idPrescription" FROM Prescription_S2);

CREATE TABLE Medicament_Prix_S2
AS SELECT "idMedicament", "prixUnitaire"
FROM s3_schema."Medicament";

CREATE TABLE Stock_S2
AS SELECT * FROM s3_schema."Stock"
WHERE ville = 'Rabat';

CREATE TABLE Vente_S2
AS SELECT * FROM s3_schema."Vente"
WHERE ville = 'Rabat';

CREATE TABLE LigneVente_S2
AS SELECT * FROM s3_schema."LigneVente"
WHERE "idVente" IN (SELECT "idVente" FROM Vente_S2);

DROP TRIGGER IF EXISTS trigger_medecin_s2 ON Medecin_S2;
DROP TRIGGER IF EXISTS trigger_medicament_s2 ON s3_schema."Medicament";
DROP TRIGGER IF EXISTS trigger_stock_s2 ON Stock_S2;
DROP TRIGGER IF EXISTS trigger_vente_s2 ON Vente_S2;

-- Medecin
CREATE OR REPLACE FUNCTION process_medecin_s2()
RETURNS TRIGGER AS $$BEGIN
    IF NEW.ville = 'Rabat' THEN
        RETURN NEW;
    ELSIF NEW.ville = 'Casablanca' THEN
        INSERT INTO casa_schema.Medecin_S1 VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_medecin_s2
BEFORE INSERT ON Medecin_S2
FOR EACH ROW EXECUTE FUNCTION process_medecin_s2();

-- Medicament
CREATE OR REPLACE FUNCTION process_medicament_s2()
RETURNS TRIGGER AS $$BEGIN
    INSERT INTO Medicament_Prix_S2 ("idMedicament", "prixUnitaire")
    VALUES (NEW."idMedicament", NEW."prixUnitaire");
    RETURN NULL;
END;$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_medicament_s2
BEFORE INSERT ON s3_schema."Medicament"
FOR EACH ROW EXECUTE FUNCTION process_medicament_s2();

-- Stock
CREATE OR REPLACE FUNCTION process_stock_s2()
RETURNS TRIGGER AS $$BEGIN
    IF NEW.ville = 'Rabat' THEN
        RETURN NEW;
    ELSIF NEW.ville = 'Casablanca' THEN
        INSERT INTO casa_schema.Stock_S1 VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_stock_s2
BEFORE INSERT ON Stock_S2
FOR EACH ROW EXECUTE FUNCTION process_stock_s2();

-- Vente
CREATE OR REPLACE FUNCTION process_vente_s2()
RETURNS TRIGGER AS $$BEGIN
    IF NEW.ville = 'Rabat' THEN
        RETURN NEW;
    ELSIF NEW.ville = 'Casablanca' THEN
        INSERT INTO casa_schema.Vente_S1 VALUES (NEW.*);
    END IF;
    RETURN NULL;
END;$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_vente_s2
BEFORE INSERT ON Vente_S2
FOR EACH ROW EXECUTE FUNCTION process_vente_s2();