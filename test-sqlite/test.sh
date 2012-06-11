sqlite3 test.sqlite <<'EOF'  > out1 2>&1
create table t (a int, b int, c int);
insert into t select 1,1,1;
insert into t select 2,2,2;
insert into t select 3,3,3;
insert into t select 4,4,4;
create table u (a string);
insert into u select 'foo' from (t as t0, t as t1, t as t2, t as t3, t as t4, t as t5);
drop table if exists v;
create table v (a string);
EOF

sqlite3 test.sqlite "insert into v select 'big' from (u as u0, u as u1);" > out1a 2>&1 &

for a in $(seq 9); do
  sqlite3 test.sqlite "insert into v select 'foo$a';"
done > out2 2>&1 &

for a in $(seq 9); do
  sqlite3 test.sqlite "insert into v select 'bar$a';"
done > out3 2>&1 &
