-- Создайте SQL-запрос, который помещает в таблицу users миллион записей

DROP PROCEDURE IF EXISTS sp_while_1000000_users;

delimiter //

CREATE PROCEDURE sp_while_1000000_users()
BEGIN
	DECLARE i int DEFAULT 1;
	WHILE i <= 10 DO -- подставить 1000000 вместо 10
		INSERT INTO users (name, birthday_at)
		VALUES (concat('test_user', i), curdate());
		SET i = i + 1;
	END WHILE;
END //

delimiter ;

CALL sp_while_1000000_users();

SELECT * FROM users;
