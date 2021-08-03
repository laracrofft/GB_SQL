/*
 * В таблице products есть два текстовых поля: name с названием товара и description с его
описанием. Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля
принимают неопределенное значение NULL неприемлема. Используя триггеры, добейтесь
того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям
NULL-значение необходимо отменить операцию
 */

DROP TRIGGER IF EXISTS check_field_isnull;

DELIMITER //

CREATE TRIGGER check_field_isnull BEFORE INSERT ON products
FOR EACH ROW
	BEGIN 
		IF NEW.name IS NULL AND NEW.description IS NULL THEN 
			SIGNAL SQLSTATE '45000' SET message_text = 'insert cancelled';
		END IF;
	END //

DELIMITER ;

INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, NULL, 15000, 2);

INSERT INTO products (name, description, price, catalog_id)
VALUES ('GeForce GTX 3080', NULL, 100000, 3);

INSERT INTO products (name, description, price, catalog_id)
VALUES (NULL, 'Оперативка', 15000, 5);
