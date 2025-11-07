ALTER SESSION SET CONTAINER = XEPDB1;

-- Crea un nuovo utente applicativo con password
CREATE USER academy IDENTIFIED BY academy;

-- Permetti la connessione e la creazione di oggetti
GRANT CONNECT, RESOURCE TO academy;

-- Concede spazio nel tablespace USERS (di default in Oracle XE)
ALTER USER academy QUOTA UNLIMITED ON USERS;

-- (Opzionale) Se vuoi dare privilegi più ampi per test:
-- GRANT CREATE VIEW, CREATE SYNONYM, CREATE SEQUENCE TO academy;

-- ora che siamo dentro la PDB XEPDB1 e abbiamo creato (o ci siamo connessi come) l’utente ACADEMY, siamo finalmente nel contesto giusto per creare le nostre tabelle.


