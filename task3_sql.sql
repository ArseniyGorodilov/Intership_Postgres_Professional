--ускорить запрос "anti-join", добиться времени выполнения < 10sec
--Анализируем результат 
explain analyse
select day from t2 where t_id not in ( select t1.id from t1 );
-- Создаем  индекс 
CREATE INDEX CONCURRENTLY t2_t_id_idx 
ON t2(t_id);
-- Запрос через джойн 
explain analyse 
SELECT t2.day
FROM t2
LEFT JOIN t1 ON t2.t_id = t1.id
WHERE t1.id IS NULL;
-- Запрос через exists 
explain analyse 
SELECT t2.day
FROM t2
WHERE NOT EXISTS (
    SELECT 1 FROM t1 WHERE t1.id = t2.t_id  
);
--Вывод: оба запроса работают быстрее 