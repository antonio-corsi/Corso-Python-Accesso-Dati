-- =====================================================================
--  setup_emp_dept.sql  (Oracle XE/EE)  - script ripetibile
--  Droppa in sicurezza le tabelle se esistono, poi le ricrea con PK/FK.
-- =====================================================================

SET FEEDBACK ON
SET ECHO ON

-- =============== DROP (safe) ==========================================
-- Nota: Drop delle child prima delle parent per evitare vincoli;
--       gestiamo gracefully il caso "table does not exist" (ORA-00942).

BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE emp PURGE';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE bonus PURGE';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE salgrade PURGE';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE dummy PURGE';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/
BEGIN
  EXECUTE IMMEDIATE 'DROP TABLE dept PURGE';
EXCEPTION WHEN OTHERS THEN
  IF SQLCODE != -942 THEN RAISE; END IF;
END;
/

-- =============== CREATE ===============================================

-- === DEPT ==============================================================
CREATE TABLE dept (
  deptno NUMBER(2) CONSTRAINT nn_dept_deptno NOT NULL,
  dname  VARCHAR2(14),
  loc    VARCHAR2(13),
  CONSTRAINT pk_dept PRIMARY KEY (deptno),
  CONSTRAINT uq_dept_dname UNIQUE (dname)           -- opzionale
);

-- === EMP ===============================================================
CREATE TABLE emp (
  empno    NUMBER(4)  CONSTRAINT nn_emp_empno NOT NULL,
  ename    VARCHAR2(10),
  job      VARCHAR2(9),
  mgr      NUMBER(4),
  hiredate DATE,
  sal      NUMBER(7,2) CONSTRAINT ck_emp_sal_nonneg  CHECK (sal  >= 0),
  comm     NUMBER(7,2) CONSTRAINT ck_emp_comm_nonneg CHECK (comm >= 0),
  deptno   NUMBER(2)  CONSTRAINT nn_emp_deptno NOT NULL,
  CONSTRAINT pk_emp PRIMARY KEY (empno),
  CONSTRAINT fk_emp_dept FOREIGN KEY (deptno) REFERENCES dept(deptno),
  CONSTRAINT fk_emp_mgr  FOREIGN KEY (mgr)   REFERENCES emp(empno)
);

-- Indici consigliati sui FK
CREATE INDEX ix_emp_deptno ON emp(deptno);
CREATE INDEX ix_emp_mgr    ON emp(mgr);

-- === BONUS =============================================================
CREATE TABLE bonus (
  ename VARCHAR2(10),
  job   VARCHAR2(9),
  sal   NUMBER,
  comm  NUMBER
);

-- === SALGRADE ==========================================================
CREATE TABLE salgrade (
  grade NUMBER CONSTRAINT pk_salgrade PRIMARY KEY,
  losal NUMBER NOT NULL,
  hisal NUMBER NOT NULL,
  CONSTRAINT ck_salgrade_range CHECK (losal <= hisal)
);

-- === DUMMY =============================================================
-- NB: in Oracle esiste già DUAL; crea questa solo se serve davvero
CREATE TABLE dummy (
  dummy NUMBER
);

-- La DDL auto-committa. Nessun COMMIT necessario.
-- Uscita automatica (facoltativa) se lanci via @script:
-- EXIT
