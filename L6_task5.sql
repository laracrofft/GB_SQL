-- Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.

SELECT id, count(*) AS total
FROM
(
	SELECT id 
	FROM users
	WHERE id NOT IN (SELECT user_id FROM communities_users)
	UNION ALL
	SELECT id 
	FROM users
	WHERE id NOT IN (SELECT from_user_id FROM friend_requests)
	UNION ALL
	SELECT id 
	FROM users
	WHERE id NOT IN (SELECT from_user_id FROM messages)
	UNION ALL
	SELECT id 
	FROM users
	WHERE id NOT IN (SELECT user_id FROM posts)
	UNION ALL
	SELECT id 
	FROM users
	WHERE id NOT IN (SELECT user_id FROM posts_likes)
) AS unactive
GROUP BY id
ORDER BY total DESC
LIMIT 10;