-- 1. Patients (6)
INSERT INTO "Patient" ("idPatient", "nomPatient", "prenomPatient", "dateNaissance", "sexe", "adresse", "ville", "telephone") VALUES
(gen_random_uuid(), 'Alami', 'Ahmed', '1985-05-12', 'M', 'Rue Zerktouni', 'Casablanca', '0661112233'),
(gen_random_uuid(), 'Bennani', 'Sara', '1990-08-20', 'F', 'Bd Anfa', 'Casablanca', '0661445566'),
(gen_random_uuid(), 'Chraibi', 'Omar', '1975-03-15', 'M', 'Maarif', 'Casablanca', '0661778899'),
(gen_random_uuid(), 'Daoudi', 'Laila', '2000-12-01', 'F', 'Oasis', 'Casablanca', '0662112233'),
(gen_random_uuid(), 'El Fassi', 'Yassine', '1982-07-10', 'M', 'Ain Diab', 'Casablanca', '0662445566'),
(gen_random_uuid(), 'Filali', 'Zineb', '1995-11-25', 'F', 'Bourgogne', 'Casablanca', '0662778899');

-- 2. Medecins (3)
INSERT INTO "Medecin" ("idMedecin", "nomMedecin", "specialite", "ville", "telephone") VALUES
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01', 'Dr. Mansouri', 'Généraliste', 'Casablanca', '0522112233'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02', 'Dr. Tazi', 'Cardiologue', 'Casablanca', '0522445566'),
('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03', 'Dr. Amrani', 'Pédiatre', 'Casablanca', '0522778899');

-- 3. Consultations (6)
INSERT INTO "Consultation" ("idConsultation", "dateConsultation", "diagnostic", "idPatient", "idMedecin")
SELECT gen_random_uuid(), CURRENT_DATE, 'Suivi Casa', "idPatient", 'c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01'
FROM "Patient" WHERE "ville" = 'Casablanca';

-- 4. Prescription (6)
INSERT INTO "Prescription" ("idPrescription", "datePrescription", "idConsultation")
SELECT gen_random_uuid(), CURRENT_DATE, "idConsultation" 
FROM "Consultation" WHERE "idMedecin" IN ('c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a01','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a02','c1eebc99-9c0b-4ef8-bb6d-6bb9bd380a03');

-- 5. Ventes (8 ventes)
INSERT INTO "Vente" ("idVente", "idPatient", "dateVente", "ville", "montantTotal")
SELECT gen_random_uuid(), "idPatient", CURRENT_DATE, 'Casablanca', 0.00
FROM "Patient" WHERE "ville" = 'Casablanca' LIMIT 8;


-- Ligne Prescription 
INSERT INTO "LignePrescription" ("idPrescription", "idMedicament", "quantite", "posologie")
SELECT "idPrescription", 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 1.00, '1 comprimé 3 fois par jour'
FROM "Prescription";

INSERT INTO "LignePrescription" ("idPrescription", "idMedicament", "quantite", "posologie")
SELECT "idPrescription", 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 2.00, '1 gélule matin et soir'
FROM "Prescription"
LIMIT 3; 

-- Ligne Vente
INSERT INTO "LigneVente" ("idVente", "idMedicament", "quantite", "prixVente")
SELECT "idVente", 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 1, 15.50
FROM "Vente";

INSERT INTO "LigneVente" ("idVente", "idMedicament", "quantite", "prixVente")
SELECT "idVente", 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 1, 85.00
FROM "Vente"
LIMIT 4;
