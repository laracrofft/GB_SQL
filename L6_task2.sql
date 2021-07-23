-- Пусть задан некоторый пользователь. 
-- Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.

SELECT 
	count(*) AS num, from_user_id, to_user_id
FROM messages
WHERE to_user_id = 99
GROUP BY from_user_id
ORDER BY num DESC) AS table1
LIMIT 1;
