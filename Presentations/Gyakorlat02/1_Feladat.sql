CREATE TABLE product (
    ean text not null,
    product_name text not null,
    current_price numeric(10,2) CHECK (current_price > 0.0),
    quantity integer CHECK (quantity >= 0),
    CONSTRAINT product_pk PRIMARY KEY (ean)
);

CREATE TABLE customer (
    customer_id SERIAL,
    customer_name text not null,
    address1 text not null,
    address2 text,
    post_code integer not null CHECK (post_code > 1000),
    CONSTRAINT customer_pk PRIMARY KEY (customer_id)
);

CREATE TABLE orders (
    order_id SERIAL,
    ean text REFERENCES product (ean),
    customer_id integer REFERENCES customer (customer_id),
    ordered_qty integer CHECK (ordered_qty > 0),
    order_item_price numeric(10,2) CHECK (order_item_price > 0.0),
    CONSTRAINT order_pk PRIMARY KEY (order_id)
);

INSERT INTO product VALUES ('12312415','Termék1',10440,10);
INSERT INTO product VALUES ('92312415','Termék2',10336,0);
INSERT INTO product VALUES ('82312415','Termék3',5000,100);
INSERT INTO product VALUES ('444424','Termék4',10030130,1);

INSERT INTO customer(customer_name,address1,address2,post_code) VALUES ('István','asdasd',NULL,7691);
INSERT INTO customer(customer_name,address1,address2,post_code) VALUES ('Évi','asdasd','12312313',1091);
INSERT INTO customer(customer_name,address1,address2,post_code) VALUES ('Bence','3123134asdasdasd dasda a d','12312313',5352);

INSERT INTO orders(ean,customer_id,ordered_qty,order_item_price)
VALUES
('12312415',1,1,9999),
('12312415',1,2,18998),
('92312415',2,1,12000);



/**Lehozza az összes megrendelés eladási ára mellett a jelenlegi árat**/

select o.ean,o.order_item_price,p.current_price
from orders o
inner join product p ON o.ean = p.ean;

/**Lehozza az összes terméket, amiből még nem rendeltek**/

select p.*
from product p
left join orders o ON o.ean = p.ean
WHERE o.ean is null;


/**Lehozza az összes vevőt, aki már rendelt**/

select DISTINCT c.*
from customer c
inner join orders o ON o.customer_id = c.customer_id;

/**Lehozza annak a terméknek a jelenlegi árát, amiből az 1-es vevő a legtöbbet rendelte**/

select p.current_price
from product p
where p.ean = (select ean from orders where customer_id = 1 GROUP BY ean order by count(*) DESC LIMIT 1)

/** Lehozza azt a terméket, amiből rendeltek már, de most nulla a mennyisége**/

select p.*
from product p
inner join orders o ON p.ean = o.ean
WHERE p.quantity = 0;

/** Lehozza azt a terméket, amiből régebben drágábban rendeltek, mint most**/

select distinct p.*
from product p
inner join orders o ON p.ean = o.ean
WHERE p.current_price < o.order_item_price
