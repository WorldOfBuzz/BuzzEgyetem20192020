ALTER TABLE library_book ADD COLUMN is_raktaron boolean;

update library_book set is_raktaron = true where library_book_id % 2 = 0;
update library_book set is_raktaron = false where is_raktaron is null;