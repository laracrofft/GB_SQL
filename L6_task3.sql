-- Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей

SELECT sum(like_num)
FROM (
	SELECT user_id, birthday,
			(SELECT 
				(SELECT count(like_type) 
				FROM posts_likes
				WHERE post_id = posts.id)
			FROM posts
			WHERE user_id = profiles.user_id) AS like_num
	FROM profiles
	ORDER BY birthday DESC
	LIMIT 10
) AS overall;
