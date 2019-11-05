CREATE TABLE ceg(
	ceg_id SERIAL,
	cegNev TEXT NOT NULL,
    CONSTRAINT ceg_PK PRIMARY KEY (ceg_id) 
);

CREATE TABLE szamla(
	szamla_id SERIAL,
	szamlazoCeg INTEGER NOT NULL REFERENCES ceg (ceg_id),
	osszeg NUMERIC (12,2) CHECK (osszeg > -1),
	szamlaKelt DATE,
	befizetesiHatarido DATE,
	CONSTRAINT szamla_PK PRIMARY KEY (szamla_id)
);

CREATE TABLE befizetes(
	befizetes_id SERIAL,
	szamla_id INTEGER REFERENCES szamla (szamla_id),
	befizetesDatum DATE,
	CONSTRAINT befizetes_PK PRIMARY KEY (befizetes_id)
);

INSERT INTO ceg(cegNev) VALUES ('Apple');
INSERT INTO ceg(cegNev) VALUES ('Microsoft');
INSERT INTO ceg(cegNev) VALUES ('Google');
INSERT INTO ceg(cegNev) VALUES ('Valve');
INSERT INTO ceg(cegNev) VALUES ('Ubisoft');
INSERT INTO ceg(cegNev) VALUES ('Msi');

INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (1,9000000,'20160916','20161216');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (1,7591399.99,'20160926','20161226');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (1,69999.99,'20160802','20161102');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (1,8364099.99,'20160826','20161126');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (2,76499.99,'20160814','20161114');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (2,28943.45,'20160917','20161217');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (2,9847.55,'20160919','20161219');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (3,1000000.66,'20160628','20160928');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (3,18000.79,'20150609','20150909');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (4,58942.99,'20150807','20151107');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (4,48869.70,'20080313','20110313');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (5,18.99,'20141119','20171119');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (5,76322.99,'20160221','20160521');
INSERT INTO szamla(szamlazoCeg,osszeg,szamlaKelt,befizetesiHatarido) VALUES (6,4869723.44,'20100201','20180201');

INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (1,'20160917');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (2,'20160927');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (3,'20160902');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (4,'20160920');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (5,'20161029');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (6,'20160930');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (7,'20161028');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (8,'20160819');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (9,'20150829');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (10,'20151001');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (11,NULL);
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (12,'20150219');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (13,'20160805');
INSERT INTO befizetes(szamla_id,befizetesDatum) VALUES (14,'20180201');

/** joinok **/ 

/** Lehozza az összes befizetett számlát és mindenegyiknél megmutatja, hány nap volt a számla kelte és a befizetés között **/
SELECT sz.szamlaKelt , b.befizetesDatum , b.befizetesDatum-sz.szamlaKelt
FROM szamla sz
INNER JOIN befizetes b ON b.szamla_id = sz.szamla_id
WHERE b.befizetesDatum IS NOT NULL;

/** Lehozza a kifizetetlen számlákat**/

SELECT sz.*
FROM szamla sz
LEFT JOIN befizetes b ON b.szamla_id = sz.szamla_id
WHERE  b.szamla_id IS NULL;

/** Lehozza az összes céget, akinek nincs kifizetetlen számlája **/

SELECT c.*
FROM ceg c
WHERE c.ceg_id NOT IN 
(select sz.szamlazoCeg FROM szamla sz
LEFT JOIN befizetes b ON b.szamla_id = sz.szamla_id
WHERE  b.szamla_id IS NULL);

/** Lehozza a kifizetetlen számlák összegét cégenként **/

SELECT sz.szamlazoCeg,sum(sz.osszeg)
FROM szamla sz
LEFT JOIN befizetes b ON b.szamla_id = sz.szamla_id
WHERE  b.szamla_id IS NULL
GROUP BY sz.szamlazoCeg;


/** Lehozza a lejárt határidejű számlákat **/

SELECT sz.*
FROM szamla sz
LEFT JOIN befizetes b ON b.szamla_id = sz.szamla_id
WHERE  b.szamla_id IS NULL and sz.befizetesiHatarido < current_date; 

/** Lehozza azokat a cégeket, akiknek csak le NEM járt határidejű, kifizetetlen számlája van **/

SELECT sz.szamlazoCeg
FROM szamla sz
LEFT JOIN befizetes b ON b.szamla_id = sz.szamla_id
WHERE  b.szamla_id IS NULL and sz.befizetesiHatarido > current_date
and sz.szamlazoCeg NOT IN 
(SELECT sz.szamlazoCeg
FROM szamla sz
LEFT JOIN befizetes b ON b.szamla_id = sz.szamla_id
WHERE  b.szamla_id IS NULL and sz.befizetesiHatarido < current_date); 

/** 
b.szamla_id IS NULL --> ez azt adja meg, hogy kifizetetlen a számla
sz.befizetesiHatarido > current_date --> ez azt adja meg, hogy le nem járt a határidő
az alselect pedig azt garantálja, hogy CSAK ilyen van
**/

