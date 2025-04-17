--ЗАДАНИЕ 2 ускорить запрос "max + left join", добиться времени выполнения < 10ms
-- Анализируем время выполнения запроса 
explain analyse
select max(t2.day) from t2 left join t1 on t2.t_id = t1.id and t1.name like 'a%';
--- Есть несколько варирантов 
-- Первый перед джойном отфильтровать таблицу т1, используя CTE
-- Второй вариант подзапрос с фильтрацией 
-- Третий использовать exists
-- Создали индексы 
-- Измени запрос на order by limit

CREATE INDEX CONCURRENTLY t2_id_idx 
ON t2(id);

CREATE INDEX CONCURRENTLY t2_day_idx 
ON t2(day);

CREATE INDEX CONCURRENTLY t1_name_idx 
ON t1(name);
-- ПОДЗАПРОС 
EXPLAIN ANALYZE
SELECT t2.day
FROM t2
WHERE t2.t_id IN (
    SELECT id 
    FROM t1 
    WHERE name LIKE 'a%'
)
ORDER BY t2.day DESC
LIMIT 1;

-- ДЖОЙН И CTE
explain analyse 
WITH filtered_t1 AS (
    SELECT id
    FROM t1
    WHERE name LIKE 'a%'
)
SELECT t2.day
FROM t2
LEFT JOIN filtered_t1 ON t2.t_id = filtered_t1.id
WHERE filtered_t1.id IS NOT NULL
ORDER BY t2.day DESC
LIMIT 1;

-- EXISTS 
EXPLAIN ANALYZE
SELECT t2.day
FROM t2
WHERE EXISTS (
    SELECT 1 
    FROM t1 
    WHERE t1.id = t2.t_id 
    AND t1.name LIKE 'a%'
)
ORDER BY t2.day DESC
LIMIT 1;

--Execution Time: 1.748 ms
-- Вывод: оптимизировали запрос 