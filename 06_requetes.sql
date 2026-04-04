-- Vues
CREATE OR REPLACE VIEW Patient_Global AS
SELECT
    i."idPatient",
    i."nomPatient",
    i."prenomPatient",
    i."dateNaissance",
    i."sexe",
    c."telephone",
    c."adresse",
    c."ville"
FROM Patient_Info_S1 i
JOIN Patient_Contact_S1 c
    ON i."idPatient" = c."idPatient"

UNION ALL

SELECT
    i."idPatient",
    i."nomPatient",
    i."prenomPatient",
    i."dateNaissance",
    i."sexe",
    c."telephone",
    c."adresse",
    c."ville"
FROM rabat_schema.Patient_Info_S2 i
JOIN rabat_schema.Patient_Contact_S2 c
    ON i."idPatient" = c."idPatient";

CREATE OR REPLACE VIEW Medecin_Global AS
SELECT
    "idMedecin",
    "nomMedecin",
    "specialite",
    "ville",
    "telephone"
FROM Medecin_S1

UNION ALL

SELECT
    "idMedecin",
    "nomMedecin",
    "specialite",
    "ville",
    "telephone"
FROM rabat_schema.Medecin_S2;

CREATE OR REPLACE VIEW Consultation_Global AS
SELECT
    "idConsultation",
    "dateConsultation",
    "diagnostic",
    "idPatient",
    "idMedecin"
FROM Consultation_S1

UNION ALL

SELECT
    "idConsultation",
    "dateConsultation",
    "diagnostic",
    "idPatient",
    "idMedecin"
FROM rabat_schema.Consultation_S2;

CREATE OR REPLACE VIEW Prescription_Global AS
SELECT
    "idPrescription",
    "datePrescription",
    "idConsultation"
FROM Prescription_S1

UNION ALL

SELECT
    "idPrescription",
    "datePrescription",
    "idConsultation"
FROM rabat_schema.Prescription_S2;


CREATE OR REPLACE VIEW LignePrescription_Global AS
SELECT
    "idPrescription",
    "idMedicament",
    "quantite",
    "posologie"
FROM LignePrescription_S1

UNION ALL

SELECT
    "idPrescription",
    "idMedicament",
    "quantite",
    "posologie"
FROM rabat_schema.LignePrescription_S2;

CREATE OR REPLACE VIEW Stock_Global AS
SELECT
    "idStock",
    "idMedicament",
    "ville",
    "quantiteDisponible",
    "seuilAlerte"
FROM Stock_S1

UNION ALL

SELECT
    "idStock",
    "idMedicament",
    "ville",
    "quantiteDisponible",
    "seuilAlerte"
FROM rabat_schema.Stock_S2;

CREATE OR REPLACE VIEW Vente_Global AS
SELECT
    "idVente",
    "idPatient",
    "dateVente",
    "ville",
    "montantTotal"
FROM Vente_S1

UNION ALL

SELECT
    "idVente",
    "idPatient",
    "dateVente",
    "ville",
    "montantTotal"
FROM rabat_schema.Vente_S2;

CREATE OR REPLACE VIEW LigneVente_Global AS
SELECT
    "idVente",
    "idMedicament",
    "quantite",
    "prixVente"
FROM LigneVente_S1

UNION ALL

SELECT
    "idVente",
    "idMedicament",
    "quantite",
    "prixVente"
FROM rabat_schema.LigneVente_S2;

CREATE OR REPLACE VIEW Medicament_Global AS
SELECT
    "idMedicament",
    "nomMedicament",
    "forme",
    "dosage",
    "prixUnitaire",
    "fabricant",
    "villeProduction"
FROM s3_schema."Medicament";

-- Requêtes

-- 1.
SELECT *
FROM Patient_Global
WHERE "ville" = 'Casablanca';

-- 2.
SELECT *
FROM Medicament_Global
WHERE "prixUnitaire" = (
    SELECT MAX("prixUnitaire")
    FROM Medicament_Global
);

-- 3.
SELECT
    c."idConsultation",
    c."dateConsultation",
    c."diagnostic",
    m."nomMedecin"
FROM Consultation_Global c
JOIN Medecin_Global m
    ON c."idMedecin" = m."idMedecin"
WHERE c."idPatient" = 'ID_PATIENT_A_REMPLACER';

-- 4.
SELECT
    med."idMedicament",
    med."nomMedicament",
    lp."quantite",
    lp."posologie"
FROM Prescription_Global p
JOIN LignePrescription_Global lp
    ON p."idPrescription" = lp."idPrescription"
JOIN Medicament_Global med
    ON lp."idMedicament" = med."idMedicament"
WHERE p."idConsultation" = 'ID_CONSULTATION_A_REMPLACER';

-- 5.
SELECT
    "ville",
    SUM("montantTotal") AS chiffre_affaires_total
FROM Vente_Global
GROUP BY "ville";

-- 6.
SELECT
    med."idMedicament",
    med."nomMedicament",
    SUM(lv."quantite") AS quantite_totale_vendue
FROM LigneVente_Global lv
JOIN Medicament_Global med
    ON lv."idMedicament" = med."idMedicament"
GROUP BY med."idMedicament", med."nomMedicament"
ORDER BY quantite_totale_vendue DESC
LIMIT 1;

-- 7.

SELECT
    s."idStock",
    s."idMedicament",
    med."nomMedicament",
    s."ville",
    s."quantiteDisponible",
    s."seuilAlerte"
FROM Stock_Global s
JOIN Medicament_Global med
    ON s."idMedicament" = med."idMedicament"
WHERE s."quantiteDisponible" < s."seuilAlerte";

-- 8.

SELECT
    m."idMedecin",
    m."nomMedecin",
    COUNT(c."idConsultation") AS nombre_consultations
FROM Medecin_Global m
LEFT JOIN Consultation_Global c
    ON m."idMedecin" = c."idMedecin"
GROUP BY m."idMedecin", m."nomMedecin"
ORDER BY nombre_consultations DESC;

-- 9.
SELECT DISTINCT
    p."idPatient",
    p."nomPatient",
    p."prenomPatient"
FROM Patient_Global p
JOIN Consultation_Global c
    ON p."idPatient" = c."idPatient"
JOIN Medecin_Global m
    ON c."idMedecin" = m."idMedecin"
JOIN Vente_Global v
    ON p."idPatient" = v."idPatient"
WHERE m."ville" <> v."ville";

-- 10. 
SELECT DISTINCT
    p."idPatient",
    p."nomPatient",
    p."prenomPatient"
FROM Patient_Global p
JOIN Consultation_Global c
    ON p."idPatient" = c."idPatient"
JOIN Prescription_Global pr
    ON c."idConsultation" = pr."idConsultation"
JOIN LignePrescription_Global lp
    ON pr."idPrescription" = lp."idPrescription"
JOIN Vente_Global v
    ON p."idPatient" = v."idPatient"
JOIN LigneVente_Global lv
    ON v."idVente" = lv."idVente"
WHERE lp."idMedicament" = lv."idMedicament";