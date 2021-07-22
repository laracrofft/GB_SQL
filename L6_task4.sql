-- Определить кто больше поставил лайков (всего) - мужчины или женщины?

SELECT sum(like_num)
FROM (
	SELECT gender,
		(SELECT 
				(SELECT count(like_type) FROM posts_likes WHERE post_id = posts.id)
		FROM posts
		WHERE user_id = profiles.user_id) AS like_num
	FROM profiles
WHERE gender = 'm') AS overall_m

-- 33

SELECT sum(like_num)
FROM (
	SELECT gender,
		(SELECT 
				(SELECT count(like_type) FROM posts_likes WHERE post_id = posts.id)
		FROM posts
		WHERE user_id = profiles.user_id) AS like_num
	FROM profiles
WHERE gender = 'f') AS overall_f;

-- 24