/*
 * Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, catalogs и products
 * в таблицу logs помещается время и дата создания записи, название таблицы, идентификатор первичного ключа
 * и содержимое поля name.
 */

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
			created_at datetime NOT NULL,
			table_name varchar(55) NOT NULL,
			value_id int NOT NULL,
			value_name varchar(255) NOT NULL
) comment = 'Логи создания новых записей' engine=archive;

DROP TRIGGER IF EXISTS check_users_log;

delimiter //

CREATE TRIGGER check_users_log AFTER INSERT ON users
FOR EACH ROW
	BEGIN 
		INSERT INTO logs (created_at, table_name, value_id, value_name)
		VALUES (now(), 'users', NEW.id, NEW.name);
	END //

delimiter ;

DROP TRIGGER IF EXISTS check_catalogs_log;

delimiter //

CREATE TRIGGER check_catalogs_log AFTER INSERT ON catalogs
FOR EACH ROW
	BEGIN 
		INSERT INTO logs (created_at, table_name, value_id, value_name)
		VALUES (now(), 'catalogs', NEW.id, NEW.name);
	END //

delimiter ;

DROP TRIGGER IF EXISTS check_products_log;

delimiter //

CREATE TRIGGER check_products_log AFTER INSERT ON products
FOR EACH ROW
	BEGIN 
		INSERT INTO logs (created_at, table_name, value_id, value_name)
		VALUES (now(), 'products', NEW.id, NEW.name);
	END //

delimiter ;

INSERT INTO users (name, birthday_at)
VALUES ('Кирилл', '1990-01-02');

INSERT INTO catalogs (name)
VALUES ('Клавиатуры');

INSERT INTO products (name, description, price, catalog_id)
VALUES ('logitech g-20', 'Клава', 5000, 6);

SELECT * FROM logs;
