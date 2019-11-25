truncate library_book;
delete from library; /* truncate nem lehet, mert a táblán van idegenkulcs */
alter table library_book 
drop constraint library_book_ean_check;

/** Enélkül 10es postgresen nem fut a save. Ez generálja az autoincrementing ID-t **/
CREATE SEQUENCE hibernate_sequence START 1;