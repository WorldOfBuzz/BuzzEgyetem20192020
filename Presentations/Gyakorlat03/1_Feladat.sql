CREATE TABLE book_data
(
  ean text NOT NULL,
  author text,
  title text,
  weight numeric(6,2),
  weight_unit text,
  CONSTRAINT bd_pk PRIMARY KEY (ean)
);

COPY book_data FROM '/tmp/book.data.csv'; /**itt írd át az elérési utat a sajátodra.   encoding 'latin1' szükséges lehet **/

select count(*) from book_data;

select count(*) from book_data where weight is null;

/** Hozzuk le azokat a könyveket, amelyek olyan szerzőkhöz tartoznak, akik többször szerepelnek az adathalmazban **/
WITH duplicated_authors  AS (
  SELECT author FROM book_data
  GROUP BY author
  HAVING count(*) > 1
)
SELECT book_data.*  FROM book_data
INNER JOIN duplicated_authors ON duplicated_authors.author = book_data.author;

/** A HAVING a group by utáni szűrésért felel, ezzel szemben a where a kezdeti adathalmazt szűkíti **/

/** Írjuk ki COPY-val egy CSV fájlba azokat a könyveket (a tömeggel), amelyek súlya nagyobb, mint az átlagos tömeg. **/
COPY (
SELECT book_data.ean,book_data.weight  FROM book_data
WHERE weight > (select avg(weight) from book_data)
ORDER BY weight DESC
) TO '/tmp/heaviest.books.csv';
