USE vk;

DROP TABLE IF EXISTS `friend_requests_types`;

CREATE TABLE `friend_requests_types` (
  `id` int unsigned NOT NULL AUTO_INCREMENT PRIMARY KEY,
  `name` varchar(128) UNIQUE NOT NULL
);

INSERT INTO `friend_requests_types`
VALUES (1,'accepted'),(2,'declined'),(3,'unfriended');

ALTER TABLE friend_requests DROP COLUMN accepted;

ALTER TABLE friend_requests ADD COLUMN request_type int unsigned NOT NULL;

UPDATE friend_requests 
SET request_type = 2
WHERE from_user_id > 59;

ALTER TABLE friend_requests ADD CONSTRAINT fk_friends_types
FOREIGN KEY (request_type) REFERENCES friend_requests_types (id);

ALTER TABLE friend_requests ADD COLUMN created_at datetime DEFAULT current_timestamp;


SELECT
	first_name,
	last_name,
	(SELECT city FROM profiles WHERE user_id = users.id) AS city,
	(SELECT file_name FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = users.id)) AS photo_name
FROM users
WHERE id = 1; -- без WHERE будет для всех пользователей

SELECT city FROM profiles WHERE user_id = 1;

SELECT photo_id FROM profiles WHERE user_id = 1;

SELECT file_name FROM media WHERE id = 1;

SELECT file_name FROM media WHERE id = (SELECT photo_id FROM profiles WHERE user_id = 1);


-- ищем картинки пользователя

SELECT file_name
FROM media
WHERE user_id = (SELECT id FROM users WHERE email = 'halvorson.rodger@example.org') 
	AND media_types_id = (
							SELECT id FROM media_types WHERE name = 'image');

SELECT id FROM media_types WHERE name = 'image';

SELECT id, email FROM users WHERE id = 63;

SELECT * FROM media WHERE file_name LIKE '%.png';

SELECT file_name
FROM media
WHERE user_id = 63 AND file_name LIKE '%.png';


SELECT file_name FROM media;

SELECT count(*)
FROM media;

SELECT count(*), media_types_id
FROM media
GROUP BY media_types_id;

SELECT sum(file_size), media_types_id
FROM media
GROUP BY media_types_id;

SELECT count(*),
		(SELECT name FROM media_types WHERE id = media.media_types_id) AS name
FROM media
GROUP BY media_types_id;

SELECT count(*),
		(SELECT name FROM media_types WHERE id = media.media_types_id) AS name,
		user_id
FROM media
GROUP BY media_types_id, user_id
ORDER BY user_id;

SELECT to_user_id
FROM friend_requests
WHERE from_user_id = 25; -- AND request_type = 1

SELECT from_user_id
FROM friend_requests
WHERE to_user_id = 34;

SELECT to_user_id
FROM friend_requests
WHERE from_user_id = 25
UNION
SELECT from_user_id
FROM friend_requests
WHERE to_user_id = 34;

/*
 * 
 * SELECT *
 * FROM friend_requests
 * WHERE request_type = 1 AND (to_user_id = 1 AND from_user_id = 1);
*/

/*
SELECT 
	DISTINCT IF(to_user_id = 1, from_user_id, to_user_id) AS friends
FROM friend_requests
WHERE request_type = 1 AND (to_user_id = 1 AND from_user_id = 1);
*/

SELECT concat(first_name, ' ', last_name) AS name
FROM users
WHERE id IN (2,3,5,7,11);

SELECT concat(first_name, ' ', last_name) AS name
FROM users
WHERE id IN (
		SELECT to_user_id
		FROM friend_requests
		WHERE from_user_id = 25
		UNION
		SELECT from_user_id
		FROM friend_requests
		WHERE to_user_id = 34
);

SET @media_type_id := (SELECT id FROM media_types WHERE name = 'image');

SELECT @media_type_id; -- переменной можно заменить часть кода

SELECT user_id,
	CASE (gender)
		WHEN 'f' THEN 'female'
		WHEN 'm' THEN 'male'
		WHEN 'x' THEN 'not defined'
	END AS gender
FROM profiles;

SELECT user_id, timestampdiff(YEAR, birthday, now()) AS age
FROM profiles;

SELECT concat(first_name, ' ', last_name) AS name,
	(SELECT 
		CASE (gender)
			WHEN 'f' THEN 'female'
			WHEN 'm' THEN 'male'
			WHEN 'x' THEN 'not defined'
		END
	FROM profiles WHERE user_id = users.id) AS gender,
	(SELECT timestampdiff(YEAR, birthday, now()) FROM profiles WHERE user_id = users.id) AS age
FROM users
WHERE id IN (
		SELECT to_user_id
		FROM friend_requests
		WHERE from_user_id = 25
		UNION
		SELECT from_user_id
		FROM friend_requests
		WHERE to_user_id = 34
);


SELECT from_user_id, to_user_id, txt, is_delivered, created_at
FROM messages
WHERE (from_user_id = 1 OR to_user_id = 1) AND is_delivered = FALSE 
ORDER BY (from_user_id = 1) DESC, created_at DESC;
