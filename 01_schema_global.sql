CREATE TABLE "Patient"(
    "idPatient" UUID NOT NULL,
    "nomPatient" VARCHAR(50) NOT NULL,
    "prenomPatient" VARCHAR(50) NOT NULL,
    "dateNaissance" DATE NOT NULL,
    "sexe" VARCHAR(20) NOT NULL,
    "adresse" VARCHAR(50) NOT NULL,
    "ville" VARCHAR(50) NOT NULL,
    "telephone" VARCHAR(20) NOT NULL
);

CREATE TABLE "Medecin"(
    "idMedecin" UUID NOT NULL,
    "nomMedecin" VARCHAR(50) NOT NULL,
    "specialite" VARCHAR(20) NOT NULL,
    "ville" VARCHAR(50) NOT NULL,
    "telephone" VARCHAR(255) NOT NULL
);

CREATE TABLE "Consultation"(
    "idConsulation" UUID NOT NULL,
    "dateConsultation" DATE NOT NULL,
    "diagnostic" TEXT NOT NULL,
    "idPatient" UUID NOT NULL,
    "idMedecin" UUID NOT NULL
);

CREATE TABLE "Prescription"(
    "idPrescription" UUID NOT NULL,
    "datePrescription" DATE NOT NULL,
    "idConsultation" UUID NOT NULL
);

CREATE TABLE "LignePrescription"(
    "idPrescription" UUID NOT NULL,
    "idMedicament" UUID NOT NULL,
    "quantite" DECIMAL(8, 2) NOT NULL,
    "posologie" VARCHAR(255) NOT NULL
);

CREATE TABLE "Medicament"(
    "idMedicament" UUID NOT NULL,
    "nomMedicament" VARCHAR(20) NOT NULL,
    "forme" VARCHAR(20) NOT NULL,
    "dosage" VARCHAR(20) NOT NULL,
    "prixUnitaire" DECIMAL(8, 2) NOT NULL,
    "fabricant" VARCHAR(20) NOT NULL,
    "villeProduction" VARCHAR(50) NOT NULL
);

CREATE TABLE "Stock"(
    "idStock" UUID NOT NULL,
    "idMedicament" UUID NOT NULL,
    "ville" VARCHAR(50) NOT NULL,
    "quantiteDisponible" SMALLINT NOT NULL,
    "seuilAlerte" FLOAT(53) NOT NULL
);

CREATE TABLE "Vente"(
    "idVente" UUID NOT NULL,
    "idPatient" UUID NOT NULL,
    "dateVente" DATE NOT NULL,
    "ville" VARCHAR(50) NOT NULL,
    "montantTotal" DECIMAL(8, 2) NOT NULL
);

CREATE TABLE "LigneVente"(
    "idVente" UUID NOT NULL,
    "idMedicament" UUID NOT NULL,
    "quantite" SMALLINT NOT NULL,
    "prixVente" DECIMAL(8, 2) NOT NULL
);

ALTER TABLE
    "Patient" ADD PRIMARY KEY("idPatient");
ALTER TABLE
    "Medecin" ADD PRIMARY KEY("idMedecin");
ALTER TABLE
    "Consultation" ADD PRIMARY KEY("idConsulation");
ALTER TABLE
    "Prescription" ADD PRIMARY KEY("idPrescription");
ALTER TABLE
    "Medicament" ADD PRIMARY KEY("idMedicament");
ALTER TABLE
    "Stock" ADD PRIMARY KEY("idStock");
ALTER TABLE
    "Vente" ADD PRIMARY KEY("idVente");

ALTER TABLE
    "LigneVente" ADD PRIMARY KEY("idVente", "idMedicament");
ALTER TABLE
    "LignePrescription" ADD PRIMARY KEY("idPrescription", "idMedicament");

ALTER TABLE
    "Consultation" ADD CONSTRAINT "consultation_idpatient_foreign" FOREIGN KEY("idPatient") REFERENCES "Patient"("idPatient");
ALTER TABLE
    "LignePrescription" ADD CONSTRAINT "ligneprescription_idmedicament_foreign" FOREIGN KEY("idMedicament") REFERENCES "Medicament"("idMedicament");
ALTER TABLE
    "LignePrescription" ADD CONSTRAINT "ligneprescription_idprescription_foreign" FOREIGN KEY("idPrescription") REFERENCES "Prescription"("idPrescription");
ALTER TABLE
    "Prescription" ADD CONSTRAINT "prescription_idconsultation_foreign" FOREIGN KEY("idConsultation") REFERENCES "Consultation"("idConsulation");
ALTER TABLE
    "Stock" ADD CONSTRAINT "stock_idmedicament_foreign" FOREIGN KEY("idMedicament") REFERENCES "Medicament"("idMedicament");
ALTER TABLE
    "Vente" ADD CONSTRAINT "vente_idpatient_foreign" FOREIGN KEY("idPatient") REFERENCES "Patient"("idPatient");
ALTER TABLE
    "LigneVente" ADD CONSTRAINT "lignevente_idvente_foreign" FOREIGN KEY("idVente") REFERENCES "Vente"("idVente");
ALTER TABLE
    "LigneVente" ADD CONSTRAINT "lignevente_idmedicament_foreign" FOREIGN KEY("idMedicament") REFERENCES "Medicament"("idMedicament");
ALTER TABLE
    "Consultation" ADD CONSTRAINT "consultation_idmedecin_foreign" FOREIGN KEY("idMedecin") REFERENCES "Medecin"("idMedecin");