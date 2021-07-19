-- Подсчитайте произведение чисел в столбце таблицы

DROP TABLE IF EXISTS storehouses_products;

CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('1', 739259, 2063, 7, '2001-09-15 15:28:43', '2018-03-01 16:22:12');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('3', 1890994, 6, 9, '1991-05-28 07:14:15', '1979-10-26 16:22:50');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('4', 9757623, 380081, 4, '1972-03-18 19:30:59', '2008-02-21 00:05:24');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('5', 99730674, 5037, 4, '2002-12-27 11:18:05', '1983-07-07 18:17:44');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('6', 338909257, 378, 6, '2016-10-28 08:25:11', '1976-03-01 16:03:13');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('8', 8970275, 351707, 6, '1984-05-25 13:38:19', '1973-04-16 21:41:10');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('9', 78153604, 156, 3, '1989-07-21 00:37:31', '1999-11-18 17:39:28');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('12', 27, 1124, 0, '1971-06-28 13:05:43', '2007-10-04 13:32:03');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('13', 965789, 39, 3, '1978-01-20 21:15:46', '1997-09-29 18:38:49');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('15', 7, 8048, 6, '1989-12-10 17:09:24', '2020-12-23 04:01:37');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('16', 9847949, 555213553, 7, '1993-12-02 22:35:38', '1981-08-06 04:05:05');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('17', 692949, 676, 3, '2007-10-16 00:15:47', '1989-10-04 10:46:42');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('18', 2499, 68, 1, '2010-01-04 01:11:33', '1996-07-07 11:11:58');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('20', 5430568, 604, 8, '1985-02-11 03:48:37', '1989-01-28 20:05:56');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('21', 657222, 34704, 0, '1981-02-25 10:52:12', '2004-04-20 06:23:51');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('23', 278, 203, 1, '1991-02-15 22:12:56', '1977-12-20 10:19:59');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('24', 9, 898612, 2, '1970-08-30 10:45:36', '2015-05-02 17:32:30');
INSERT INTO `storehouses_products` (`id`, `storehouse_id`, `product_id`, `value`, `created_at`, `updated_at`) VALUES ('25', 273344770, 69683, 4, '2016-01-25 19:07:12', '2019-10-29 16:33:46');

DELETE FROM storehouses_products
WHERE value <= 1;

SELECT EXP(sum(LN(value))) FROM storehouses_products;

