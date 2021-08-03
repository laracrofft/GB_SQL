-- Создайте представление, которое выводит название name товарной позиции из таблицы
-- products и соответствующее название каталога name из таблицы catalogs

USE test3;

CREATE OR REPLACE VIEW view_product_catalog
AS
SELECT p.name AS product_name, c.name AS catalog_name
FROM products p
	JOIN catalogs c ON p.catalog_id = c.id;

SELECT * FROM view_product_catalog;
