CREATE TABLE library (
    library_id SERIAL,
    library_name text NOT NULL UNIQUE,
    library_postcode integer CHECK (library_postcode > 1000),
    CONSTRAINT library_pk PRIMARY KEY (library_id)
);

CREATE TABLE library_book (
    library_book_id SERIAL,
    ean text CHECK (ean LIKE '978%' AND length(ean) = 13),
    library_id integer NOT NULL REFERENCES library (library_id),
    title text NOT NULL,
    author text NOT NULL,
    page_number integer CHECK (page_number > 0),
    CONSTRAINT library_book_pk PRIMARY KEY (ean)
);

## rossz insertek

INSERT INTO library(library_name,library_postcode) VALUES ('Széchenyi',999);
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780751544749',1,'The Book Thief','Zusak',560); /*idegen kulcs hiba*/
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('978075154474',1,'The Book Thief','Zusak',560); /*ean check*/
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('0751544749',1,'The Book Thief','Zusak',560); /*ean check*/
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780751544749',1,'The Book Thief','Zusak',-10); /*page number check*/
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780751544749',1, NULL ,'Zusak',560); /*title NOT NULL*/
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780751544749',1, 'The Book Thief' , NULL,560); /*author not null*/

# Működő insertek

INSERT INTO library(library_name,library_postcode) VALUES ('Széchenyi',7625);
INSERT INTO library(library_name,library_postcode) VALUES ('Petőfi',4513);

INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780751544749',2,'The Book Thief','Zusak',560);
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780751544749',3,'The Book Thief','Zusak',560);

# hopp, elgépeltük a primary key-t

drop table library;
drop table library_book;

/** ez így nem fog menni az idegenkulcs miatt*/

drop table library_book;
drop table library;

CREATE TABLE library (
    library_id SERIAL,
    library_name text NOT NULL UNIQUE,
    library_postcode integer CHECK (library_postcode > 1000),
    CONSTRAINT library_pk PRIMARY KEY (library_id)
);

CREATE TABLE library_book (
    library_book_id SERIAL,
    ean text CHECK (ean LIKE '978%' AND length(ean) = 13),
    library_id integer NOT NULL REFERENCES library (library_id),
    title text NOT NULL,
    author text NOT NULL,
    page_number integer CHECK (page_number > 0),
    CONSTRAINT library_book_pk PRIMARY KEY (library_book_id)
);

/** Íme, egy kis tesztadat **/

INSERT INTO library(library_name,library_postcode) VALUES ('Széchenyi',7625);
INSERT INTO library(library_name,library_postcode) VALUES ('Petőfi',4513);

INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780751544749',1,'The Book Thief','Zusak',560);
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780751544749',2,'The Book Thief','Zusak',560);
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780575400160',1,'Billie Holiday','Nicholson',320);
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780241023198',2,'In the country','Allsop',212);
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780241023198',2,'Hideous Kinky','Freud',192);
INSERT INTO library_book(ean,library_id,title,author,page_number) VALUES ('9780747597704',1,'Mr Mac and Me','Freud',304);

# INNER JOIN

CREATE TABLE library_employee (
    employee_name text NOT NULL,
    favourite_book_ean text CHECK (favourite_book_ean LIKE '978%' AND length(favourite_book_ean) = 13),
    library_id integer NOT NULL REFERENCES library (library_id),
    CONSTRAINT library_employee_pk PRIMARY KEY (employee_name)
);

INSERT INTO library_employee VALUES ('Kovács Géza','9781408805824',1);
INSERT INTO library_employee VALUES ('Teszt Elek','9780751544749',1);
INSERT INTO library_employee VALUES ('Tóth Péter','9780747597704',2);
INSERT INTO library_employee VALUES ('Kiss Virág','9780241023198',2);


# JOINok

/** lehozzá a könyveket a könyvtár irányítószámával */
select l.library_postcode,b.title,b.ean
from library_book b
inner join library l ON b.library_id = l.library_id;

/** Lehozza azokat a könyv példányokat, amelyek valamelyik alkalmazott kedvencei */
SELECT e.employee_name,b.library_id
FROM library_employee e
INNER JOIN library_book b ON e.favourite_book_ean = b.ean;

/** Lehozza azon alkalmazottakat, akiknek nincs meg a kedvenc könyvük a munkahelyükön */
SELECT e.employee_name
FROM library_employee e
LEFT JOIN library_book b ON e.favourite_book_ean = b.ean and e.library_id = b.library_id
WHERE b.ean is null;

/** Hozzuk le az összes alkalmazottat és az összes könyvet és kössük őket össze, ahol lehet */
SELECT e.employee_name,b.author,b.title
FROM library_employee e
FULL JOIN library_book b ON e.favourite_book_ean = b.ean;
