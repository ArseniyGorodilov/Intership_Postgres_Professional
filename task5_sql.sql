--Задание 5 
--ускорить работу "savepoint + update", добиться постоянной во времени производительности (число транзакций в секунду)
-- Уменьшил количество savepoint 
-- Добавил измненние атрибута name 
-- Добился потсоянной производительности 
psql -X -q > generate_100_subtrans.sql <<'EOF'

select '\set id random(1,10000000)'

-- Начало транзакции
union all select 'BEGIN;'

-- Генерация 10 savepoint с группировкой по 10 update в каждом
union all select 'savepoint batch_' || (v.id/10) || ';' || E'\n' ||
       string_agg('update t1 set name = md5(random()::text) where id = :id;', E'\n' 
       order by sub.id) || E'\n'
from generate_series(1,100) v(id),
     generate_series(1,10) sub(id)
group by v.id/10

-- Завершение транзакции
union all select E'COMMIT;\n'
\g (tuples_only=true format=unaligned)
EOF


