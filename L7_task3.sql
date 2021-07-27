/* Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label,
name). Поля from, to и label содержат английские названия городов, поле name — русское.
Выведите список рейсов flights с русскими названиями городов */
 

USE test2;

DROP TABLE IF EXISTS flights;
CREATE TABLE flights (
	id SERIAL PRIMARY KEY,
	from_city varchar(255),
	to_city varchar(255)
);

INSERT INTO flights VALUES (1, 'moscow', 'omsk'),
						(2, 'novgorod', 'kazan'),
						(3, 'irkutsk', 'moscow'),
						(4, 'omsk', 'irkutsk'),
						(5, 'moscow', 'kazan');

DROP TABLE IF EXISTS cities;
CREATE TABLE cities (
	id SERIAL PRIMARY KEY,
	label varchar(255),
	name varchar(255)
);

INSERT INTO cities VALUES (1, 'moscow', 'Москва'),
						(2, 'novgorod', 'Новгород'),
						(3, 'irkutsk', 'Иркутск'),
						(4, 'omsk', 'Омск'),
						(5, 'kazan', 'Казань');

SELECT fc.name, tc.name
FROM flights f
	JOIN cities AS fc ON f.from_city = fc.label
	JOIN cities AS tc ON f.to_city = tc.label;

 	