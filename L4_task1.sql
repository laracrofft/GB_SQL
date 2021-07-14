ALTER TABLE friend_requests 
ADD CONSTRAINT sender_not_reciever_check
CHECK (from_user_id != to_user_id);

ALTER TABLE users
ADD CONSTRAINT phone_check
CHECK (regexp_like(phone, '^[0-9]{11}$'));

ALTER TABLE profiles
ADD CONSTRAINT fk_profiles_media
FOREIGN KEY (photo_id) REFERENCES media (id);

INSERT INTO users (id, first_name, last_name, email, phone, password_hash)
VALUES  (DEFAULT, 'lev', 'tolstoy', 'lt@ya.tu', '89121234567', 'sss');

INSERT INTO users (first_name, last_name, email, phone)
VALUES ('ildar', 'super', 'super@ya.tu', '89124564567'),
	   ('nelly', 'avdalova', 'na@ya.tu', '84441234567');

INSERT users
SET first_name = 'ii',
	last_name = 'sss',
	email = 'is@is.ss',
	phone = '85551234455';

/*
* insert users (first_name, last_name, email, phone)
* select first_name, last_name, email, phone from test1.users;
**/

SELECT * FROM communities;

SELECT first_name FROM users;

SELECT DISTINCT first_name FROM users; -- без повторов

SELECT * FROM users WHERE id <= 5;

SELECT * FROM users WHERE id BETWEEN 3 AND 6; -- границы включаются 

SELECT * FROM users WHERE password_hash IS NULL;

SELECT * FROM users WHERE password_hash IS NOT NULL;

SELECT * FROM users ORDER BY id LIMIT 4;

SELECT * FROM users ORDER BY id DESC LIMIT 4; -- с конца, сортировка в обратном порядке

SELECT * FROM users ORDER BY id LIMIT 1 offset 3;
-- или
SELECT * FROM users ORDER BY id LIMIT 3, 1; -- выбираем 4ю по счету запись



SELECT * FROM users;

UPDATE messages
SET is_delivered = TRUE;

UPDATE messages
SET txt = 'hello'
WHERE id = 2;



DELETE FROM users; -- WHERE last_name = 'super';


-- TRUNCATE TABLE messages - удаляет всю таблицу и создает ее заново, но если на нее есть внешние ключи, то будет ошибка 


-- SET FOREIGN_KEY_Checks = 0 - обнуляет ограничение на проверку наличия на таблицу внешних ключей