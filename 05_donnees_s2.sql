-- 1. Patients (6)
INSERT INTO "Patient" ("idPatient", "nomPatient", "prenomPatient", "dateNaissance", "sexe", "adresse", "ville", "telephone") VALUES
(gen_random_uuid(), 'Gharbi', 'Mehdi', '1988-06-30', 'M', 'Agdal', 'Rabat', '0663112233'),
(gen_random_uuid(), 'Haddi', 'Meryem', '1992-09-14', 'F', 'Hay Riad', 'Rabat', '0663445566'),
(gen_random_uuid(), 'Idrissi', 'Anas', '1980-01-05', 'M', 'Souissi', 'Rabat', '0663778899'),
(gen_random_uuid(), 'Jebli', 'Salma', '2002-04-22', 'F', 'Hassan', 'Rabat', '0664112233'),
(gen_random_uuid(), 'Kabbaj', 'Karim', '1970-10-18', 'M', 'Les Orangers', 'Rabat', '0664445566'),
(gen_random_uuid(), 'Lahlou', 'Sofia', '1998-02-14', 'F', 'Ocean', 'Rabat', '0664778899');

-- 2. MEDECINS (3)
INSERT INTO "Medecin" ("idMedecin", "nomMedecin", "specialite", "ville", "telephone") VALUES
('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380b01', 'Dr. Benjelloun', 'Généraliste', 'Rabat', '0537112233'),
('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380b02', 'Dr. Iraqi', 'Dermatologue', 'Rabat', '0537445566'),
('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380b03', 'Dr. Jouahri', 'Ophtalmologue', 'Rabat', '0537778899');

-- 3. Consultations (6)
INSERT INTO "Consultation" ("idConsultation", "dateConsultation", "diagnostic", "idPatient", "idMedecin")
SELECT gen_random_uuid(), CURRENT_DATE, 'Suivi Rabat', "idPatient", 'c2eebc99-9c0b-4ef8-bb6d-6bb9bd380b01'
FROM "Patient" WHERE "ville" = 'Rabat';

-- 4. Prescriptions (6)
INSERT INTO "Prescription" ("idPrescription", "datePrescription", "idConsultation")
SELECT gen_random_uuid(), CURRENT_DATE, "idConsultation" 
FROM "Consultation" WHERE "idMedecin" IN ('c2eebc99-9c0b-4ef8-bb6d-6bb9bd380b01','c2eebc99-9c0b-4ef8-bb6d-6bb9bd380b02','c2eebc99-9c0b-4ef8-bb6d-6bb9bd380b03');

-- 5. Ventes (7 ventes)
INSERT INTO "Vente" ("idVente", "idPatient", "dateVente", "ville", "montantTotal")
SELECT gen_random_uuid(), "idPatient", CURRENT_DATE, 'Rabat', 0.00
FROM "Patient" WHERE "ville" = 'Rabat' LIMIT 7;

-- Lignes Prescription 
INSERT INTO "LignePrescription" ("idPrescription", "idMedicament", "quantite", "posologie")
SELECT "idPrescription", 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 1.00, '1 comprimé si douleur'
FROM "Prescription";

INSERT INTO "LignePrescription" ("idPrescription", "idMedicament", "quantite", "posologie")
SELECT "idPrescription", 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 1.00, '2 bouffées en cas de crise'
FROM "Prescription"
LIMIT 3;

-- Lignes Vente 
INSERT INTO "LigneVente" ("idVente", "idMedicament", "quantite", "prixVente")
SELECT "idVente", 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 1, 42.00
FROM "Vente";

INSERT INTO "LigneVente" ("idVente", "idMedicament", "quantite", "prixVente")
SELECT "idVente", 'a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 1, 72.00
FROM "Vente"
LIMIT 3;
