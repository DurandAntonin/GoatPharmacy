-- 1. MEDICAMENTS (10 produits)
INSERT INTO "Medicament" ("idMedicament", "nomMedicament", "forme", "dosage", "prixUnitaire", "fabricant", "villeProduction") VALUES
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11', 'Doliprane', 'Comprimé', '1000mg', 15.50, 'Sanofi', 'Casablanca'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a12', 'Amoxil', 'Gélule', '500mg', 45.00, 'GSK', 'Casablanca'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a13', 'Spasfon', 'Comprimé', '80mg', 28.00, 'Teva', 'Rabat'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a14', 'Augmentin', 'Sachet', '1g', 85.00, 'Glaxo', 'Casablanca'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a15', 'Ventoline', 'Inhalateur', '100mcg', 55.00, 'GSK', 'Rabat'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a16', 'Voltarene', 'Gel', '1%', 35.00, 'Novartis', 'Casablanca'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a17', 'Gaviscon', 'Sirop', '250ml', 42.00, 'Reckitt', 'Rabat'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a18', 'Zyrtec', 'Comprimé', '10mg', 60.00, 'UCB', 'Casablanca'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a19', 'Aerius', 'Comprimé', '5mg', 72.00, 'MSD', 'Rabat'),
('a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a20', 'Difal', 'Comprimé', '50mg', 22.00, 'Laprophan', 'Casablanca');

-- 2. INITIALISATION DES STOCKS (2 par médicament : 1 Casa, 1 Rabat)
INSERT INTO "Stock" ("idStock", "idMedicament", "ville", "quantiteDisponible", "seuilAlerte")
SELECT gen_random_uuid(), "idMedicament", 'Casablanca', 100, 10 FROM "Medicament";

INSERT INTO "Stock" ("idStock", "idMedicament", "ville", "quantiteDisponible", "seuilAlerte")
SELECT gen_random_uuid(), "idMedicament", 'Rabat', 80, 5 FROM "Medicament";