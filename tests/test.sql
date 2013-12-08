select load_extension('./bin/libtrilite.so');
create virtual table trg using trilite (id key, text text, c1 blob, c2 blob, name TEXT);
-- TriLite current creates two underlying tables
.tables
-- Wrap insertions into a transaction (not strictly required)
BEGIN TRANSACTION;
insert into trg (id, text) VALUES (1, 'abcd');
insert into trg (id, text) VALUES (2, 'bcde');
insert into trg (id, text) VALUES (3, 'bcdef');
insert into trg (id, text) VALUES (4, 'abc');
-- Note that we can only query data after we've committed
-- This is just a detail left out so far.
COMMIT TRANSACTION;
-- See we have content
select * from trg_content;
-- We also have doclists, Note the trigram is encoded as integer
select trigram, length(doclist), hex(doclist) from trg_index;
-- Now, let's select something, -extents: tells, to generate extents when matching
select *, hex(extents(contents)) from trg WHERE contents MATCH 'substr-extents:abc' and contents MATCH 'regexp-extents:bcd'; 
