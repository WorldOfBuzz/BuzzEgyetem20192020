CREATE TABLE bankszamla
(
  iban text NOT NULL,
  account_value numeric(6,2),
  account_live boolean,
  currency text,
  CONSTRAINT bsz_pk PRIMARY KEY (iban)
);

/**kapott CSV-t betölti egy táblába**/
COPY bankszamla FROM '/home/janoszsolt/work/Egyetem/BuzzEgyetem/Gyakorlat03/Gyakorlat3HaziAdat.csv'
WITH
DELIMITER ','
CSV HEADER;

/**WITH kulcsszóval írjunk olyan SQL-t, ami lehozza a 10, legtöbb pénzzel rendelkező, élő számla adatait**/

WITH top10 as (SELECT iban FROM bankszamla WHERE account_live = TRUE ORDER BY account_value DESC LIMIT 10)
SELECT b.*
FROM bankszamla b
INNER JOIN top10 t ON b.iban = t.iban;

/** COPY-val kiírja fájlba az átlagosnál kevesebb pénzzel rendelkező számlákat **/

COPY (
SELECT *  FROM bankszamla
WHERE account_value < (select avg(account_value) from bankszamla)
) TO '/tmp/below.avg.bsz.csv'
WITH
DELIMITER ',';
