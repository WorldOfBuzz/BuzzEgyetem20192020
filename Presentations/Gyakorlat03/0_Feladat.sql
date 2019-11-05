/**
* Tranzakció kezelés
**/

CREATE TABLE library_gyak3 (
    library_id SERIAL,
    library_name text NOT NULL UNIQUE,
    CONSTRAINT library_gy3_pk PRIMARY KEY (library_id)
);

INSERT INTO library_gyak3(library_name) VALUES ('test1');
INSERT INTO library_gyak3(library_name) VALUES ('test2');
select * from library_gyak3;

/* Ezen a ponton van egy kis táblánk */

/* ------ 1 - DDL-tranzakció ------ **/

BEGIN;

DROP TABLE IF EXISTS library_gyak3;

CREATE TABLE library_gyak3 (
    library_id SERIAL,
    library_name text NOT NULL UNIQUE,
    library_postcode integer CHECK (library_postcode > 1000),
    CONSTRAINT library_gy3_pk PRIMARY KEY (library_id)
);

ALTER TABLE library_gyak3 ADD COLUMN library_director text NOT NULL;

select * from library_gyak3;
ROLLBACK;

select * from library_gyak3;

/* Visszaállt minden a régi kerékvágásba */

BEGIN;

DROP TABLE IF EXISTS library_gyak3;

CREATE TABLE library_gyak3 (
    library_id SERIAL,
    library_name text NOT NULL UNIQUE,
    library_postcode integer CHECK (library_postcode > 1000),
    CONSTRAINT library_gy3_pk PRIMARY KEY (library_id)
);

ALTER TABLE library_gyak3 ADD COLUMN library_director text NOT NULL;

select * from library_gyak3;
COMMIT;

select * from library_gyak3;

/* ------ 2 - DML-tranzakció ------ **/

BEGIN;

INSERT INTO library_gyak3(library_name,library_postcode,library_director) VALUES ('teszt3',3123,'Nincs');
INSERT INTO library_gyak3(library_name,library_postcode,library_director) VALUES ('teszt4',6667,'Nincs');
INSERT INTO library_gyak3(library_name,library_postcode,library_director) VALUES ('teszt5',8641,'Nincs');
INSERT INTO library_gyak3(library_name,library_postcode,library_director) VALUES ('nemteszt10',8341,'Nincs');
UPDATE library_gyak3 SET library_director = 'A Vezető';

COMMIT;

select * from library_gyak3;

BEGIN;

INSERT INTO library_gyak3(library_name,library_postcode,library_director) VALUES ('teszt6',1414,'A Vezető');
INSERT INTO library_gyak3(library_name,library_postcode,library_director) VALUES ('teszt7',4141,'A Vezető');
INSERT INTO library_gyak3(library_name,library_postcode,library_director) VALUES ('teszt8',8510,'A Vezető');
UPDATE library_gyak3 SET library_director = 'A Vezető VEzető2';

select * from library_gyak3;

ROLLBACK;

select * from library_gyak3;

/** Tranzakcióba egy parancsot is tehetünk persze... */

BEGIN;
DELETE FROM library_gyak3 WHERE library_name LIKE 'teszt%';
ROLLBACK;

/** Nézzük meg tranzakció nélkül **/

DELETE FROM library_gyak3 WHERE library_name LIKE 'teszt%';
ROLLBACK;
select * from library_gyak3;
