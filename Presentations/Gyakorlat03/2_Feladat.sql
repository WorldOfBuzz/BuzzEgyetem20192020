CREATE TABLE dummy_order
(
  orderId integer NOT NULL,
  orderValue numeric(3,1),
  barcode text,
  CONSTRAINT dummy_order_pk PRIMARY KEY (orderId)
);

COPY dummy_order FROM '/tmp/MOCK_DATA.csv'
WITH
DELIMITER ','
CSV HEADER;
/** Két dologra kellett rájönni itt: a DELIMITER a vessző miatt és a CSV HEADER sorra, ugyanis a fájl tartalmaz headert, ami nem adat **/

select count(*) from dummy_order;
/** Hozzuk le azokat a könyveket, amelyek olyan szerzőkhöz tartoznak, akik többször szerepelnek az adathalmazban **/
WITH interesting_orders  AS (
  SELECT orderValue
  FROM dummy_order
  GROUP BY orderValue
  ORDER BY count(*) DESC LIMIT 5
)
SELECT dummy_order.*
FROM dummy_order
INNER JOIN interesting_orders ON interesting_orders.orderValue = dummy_order.orderValue;


/** Írjuk ki COPY-val egy vesszővel elválasztott CSV fájlba azokat a megrendeléseket, amelyek értéke nagyobb, mint a legkisebb érték kétszerese **/
COPY (
SELECT *  FROM dummy_order
WHERE orderValue > (select min(orderValue) * 2 from dummy_order)
ORDER BY orderValue DESC
) TO '/tmp/interesting.orders.csv'
WITH
DELIMITER ',';
