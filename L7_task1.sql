-- Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине

USE test3;

SELECT * FROM orders;

INSERT INTO orders VALUES (2, 1, current_timestamp, current_timestamp), 
						(3, 2, current_timestamp, current_timestamp),
					(4, 3, current_timestamp, current_timestamp),
				(5, 4, current_timestamp, current_timestamp),
			(6, 4, current_timestamp, current_timestamp);
		
SELECT u.id, u.name, count(*) AS orders_total
FROM users u
	JOIN orders o ON u.id = o.user_id
GROUP BY u.id;
