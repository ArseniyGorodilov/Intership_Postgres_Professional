--ЗАДАНИЕ 1 ускорить простой запроc, добиться времени выполнения < 10ms 
select name from t1 where id = 50000;
-- Аналиизруем время выполнения
EXPLAIN ANALYZE
SELECT name FROM t1 WHERE id = 50000;
-- Execution Time: 1295.135 ms

-- Стоит отметить, что explain analyse  выполнит запрос, в то время
-- как explain предоставит ориентировочное время
--можно обернуть explain analyse  в транзакцию и сделать rollback 
--Так как сам код запроса не оптимизировать, необходимо использовать индексы. 
--Буду использовать классический B-tree индекс 
--По полю id, который не является первичным ключом(поэтому индекс не создан автоматически)
CREATE INDEX CONCURRENTLY t1_id_idx 
ON t1(id);
-- Повторный замер после добавления индекса 
EXPLAIN ANALYZE
SELECT name FROM t1 WHERE id = 50000;
-- Execution Time: 0.132 ms
-- Вывод: Время выполнения запроса оптимизировано 