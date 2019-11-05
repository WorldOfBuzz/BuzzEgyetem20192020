CREATE DATABASE gyakorlat1;

/** DDL műveletek **/

CREATE TABLE auto (
         rendszam text NOT NULL,
         gyartasi_datum date NOT NULL,
         CONSTRAINT auto_pk PRIMARY KEY (rendszam)
);
ALTER TABLE auto ADD COLUMN teljesitmeny int not null;
DROP TABLE auto;

CREATE TABLE auto(
  rendszam text NOT NULL,
  gyartasi_datum date NOT NULL,
  teljesitmeny integer NOT NULL,
  CONSTRAINT auto_pk PRIMARY KEY (rendszam)
);

ALTER TABLE auto ADD COLUMN forgalomban boolean default true;

/** DML műveletek **/

INSERT INTO auto
VALUES ('xxx-000','2007-08-01','74',true);

INSERT INTO auto
VALUES
('xxx-001','2007-08-20','74',true),
('xxx-002','2007-01-01','100',false);

INSERT INTO auto
VALUES
('yyy-001','2013-08-20','120',true),
('yyy-002','2013-01-01','130',true);

/** default érték lesz a forgalomban oszlopban **/
INSERT INTO auto (rendszam,gyartasi_datum,teljesitmeny)
VALUES
('zzz-111','2010-12-12',100);

INSERT INTO auto
VALUES ('xxx-000','2007-12-30','74',true);

select * from auto;
select * from auto where forgalomban = true;
select * from auto where gyartasi_datum >= '2008-01-01';
select * from auto where rendszam = 'xxx-001';
select * from auto where rendszam like 'yyy%';

/** aggregation **/

select sum(teljesitmeny) from auto where rendszam like 'yyy%';
select avg(teljesitmeny) from auto where rendszam like 'yyy%';
select count(*) from auto;

/** update / delete / truncate **/

update auto set forgalomban = true where forgalomban = false;
update auto set teljesitmeny = teljesitmeny - 10 ;

delete from auto where rendszam = 'xxx-002';

truncate auto;
