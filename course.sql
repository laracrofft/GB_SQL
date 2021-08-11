/*
 * Представленная база данных предназначена для системы электронной регистрации фитнес-центров/спортзалов и т.п.
 * Данная БД обеспечивает возможности регистрации клиентов, ведения записи на занятия, создания расписания.
 * Исходя из анализа предметной области можно выделить несколько основных сущностей: тренер, вид спорта, зал/зона
 * (группа тренажеров), занятие, расписание, клиент.
 */

DROP DATABASE IF EXISTS fitness;

CREATE DATABASE fitness;

USE fitness;

-- "Вид спорта" содержит справочник видов спорта
CREATE TABLE sport_type(
	id SERIAL PRIMARY KEY,
	name VARCHAR(50) NOT NULL UNIQUE
);

-- "Тренер" содержит перечень тренеров
CREATE TABLE coach(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(145) NOT NULL,
	last_name VARCHAR(145) NOT NULL,
	phone_number CHAR(11) NOT NULL,
	birthday DATE NOT NULL,
	about VARCHAR(255) NOT NULL
);

-- "Тренер по виду спорта" хранит данные о виде спорта, который преподает тренер
CREATE TABLE coach_sport_type(
	id SERIAL PRIMARY KEY,
	sport_id BIGINT UNSIGNED NOT NULL,
	coach_id BIGINT UNSIGNED NOT NULL,
	KEY (sport_id, coach_id),
	INDEX sport_id_idx (sport_id),
	INDEX coach_id_idx (coach_id),
	CONSTRAINT fk_sport_type_id FOREIGN KEY (sport_id) REFERENCES sport_type (id),
	CONSTRAINT fk_coach_id FOREIGN KEY (coach_id) REFERENCES coach (id)
);

-- "Зал/зона" содержит перечень имеющихся локаций для занятий

CREATE TABLE gym_zone(
	id SERIAL PRIMARY KEY,
	name VARCHAR(145) NOT NULL,
	floor_number INT UNSIGNED
);

-- "Календарь" хранит дни недели, вид спорта и время занятий

CREATE TABLE calendar(
	id SERIAL PRIMARY KEY,
	week_day ENUM ('1', '2', '3', '4', '5', '6', '7') NOT NULL,
	sport_type_id BIGINT UNSIGNED NOT NULL,
	gym_zone_id BIGINT UNSIGNED NOT NULL,
	start_time TIME NOT NULL,
	duration INT UNSIGNED,
	INDEX (week_day),
	FOREIGN KEY (sport_type_id) REFERENCES sport_type (id),
	FOREIGN KEY (gym_zone_id) REFERENCES gym_zone (id)
);

-- "Клиент" содержит данные о клиентах

CREATE TABLE client(
	id SERIAL PRIMARY KEY,
	first_name VARCHAR(145) NOT NULL,
	last_name VARCHAR(145) NOT NULL,
	phone_number CHAR(11) NOT NULL,
	birthday DATE NOT NULL,
	created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	password_hash CHAR(65) DEFAULT NULL,
	INDEX (phone_number)
);

-- "Членская карта" хранит номера карт в привязке к клиенту

CREATE TABLE membership_card(
	id SERIAL PRIMARY KEY,
	card_number CHAR(10) NOT NULL,
	client_id BIGINT UNSIGNED NOT NULL,
	expired DATE NOT NULL,
	FOREIGN KEY (client_id) REFERENCES client (id)
);

-- "Групповое занятие" содержит список групповых и индивидуальных занятий, количество мест в группе

CREATE TABLE group_activity(
	id SERIAL PRIMARY KEY,
	coach_sport_type_id BIGINT UNSIGNED NOT NULL,
	is_group_activity BOOLEAN DEFAULT FALSE,
	member_quantity INT UNSIGNED DEFAULT 1,
	KEY (coach_sport_type_id),
	FOREIGN KEY (coach_sport_type_id) REFERENCES coach_sport_type (id)
);

-- "Группа" содержит участников занятия по виду спорта

CREATE TABLE group_members(
	member_card_id BIGINT UNSIGNED NOT NULL,
	group_activity_id BIGINT UNSIGNED NOT NULL,
	PRIMARY KEY (member_card_id, group_activity_id),
	KEY (member_card_id, group_activity_id),
	FOREIGN KEY (member_card_id) REFERENCES membership_card (id),
	FOREIGN KEY (group_activity_id) REFERENCES group_activity (id)
);

-- "Статус занятия" содержит справочник статусов занятия

CREATE TABLE activity_status(
	id SERIAL PRIMARY KEY,
	name ENUM('по плану', 'отменено', 'не назначено') NOT NULL
);

-- "Расписание" хранит пересечение представленных выше таблиц

CREATE TABLE schedule(
	id SERIAL PRIMARY KEY,
	group_activity_id BIGINT UNSIGNED NOT NULL,
	calendar_id BIGINT UNSIGNED NOT NULL,
	activity_status_id BIGINT UNSIGNED NOT NULL,
	KEY (group_activity_id, calendar_id, activity_status_id),
	CONSTRAINT fk_group_activity_id FOREIGN KEY (group_activity_id) REFERENCES group_activity (id),
	CONSTRAINT fk_calendar_id FOREIGN KEY (calendar_id) REFERENCES calendar (id),
	CONSTRAINT fk_activity_status_id FOREIGN KEY (activity_status_id) REFERENCES activity_status (id)
);

-- также можно добавить админку для ресепшена
-- и блок авторизации

-- выбираем занятие группы в определенный день недели

SELECT s.id, c.week_day, c.start_time, ga.coach_sport_type_id, ga.id, as2.name 
FROM schedule s 
	JOIN group_activity ga ON s.group_activity_id = ga.id 
	JOIN calendar c ON s.calendar_id = c.id
	JOIN activity_status as2 ON s.activity_status_id = as2.id 
WHERE c.week_day = '1'
	AND ga.id = 'some';

-- выбираем расписание для определенного клиента

SELECT s.id, c.week_day, c.start_time, ga.coach_sport_type_id, ga.id, as2.name, gm.member_card_id
FROM schedule s 
	JOIN group_activity ga ON s.group_activity_id = ga.id 
	JOIN calendar c ON s.calendar_id = c.id
	JOIN activity_status as2 ON s.activity_status_id = as2.id
	JOIN group_members gm ON s.group_activity_id  = gm.group_activity_id
WHERE gm.member_card_id = 'some'
	AND as2.name = 'по плану';

-- выбираем расписание для вида спорта/тренера
-- смотрим загруженность зала/зоны

-- проверяем наличие мест в группе

DROP TRIGGER IF EXISTS check_member_quantity_before_insert;

delimiter //

CREATE TRIGGER check_member_quantity_before_insert BEFORE INSERT ON group_members
FOR EACH ROW
	BEGIN
		IF group_activity.member_quantity = 0 THEN 
			SIGNAL SQLSTATE '45000' SET message_text = 'места в группе закончились';
		END IF;
	END //

delimiter ;

-- записываем в группу, уменьшая кол-во свободных мест (тут я наверное глупость написала и так нельзя или можно?)

delimiter //

CREATE PROCEDURE sp_add_member_to_group (member_card_id int, group_activity_id int)
BEGIN
	START TRANSACTION;
		INSERT INTO group_members (member_card_id, group_activity_id);
		UPDATE group_activity SET member_quantity = member_quantity - 1 WHERE group_members.group_activity_id = group_activity.id;
	COMMIT;
END //

delimiter ;

-- проверка корректности ввода номера телефона
-- проверка корректности ввода номера членской карты



/*
 * Вопросы:
 * - можно ли для таблицы coach_sport_type, где содержатся только пара id, использовать движок archive?
 * - а для справочников - MyISAM?
 * - имеет ли смысл вместо таблицы activity_status добавить одноименное поле в таблицу schedule?
 * - может вместо селектов использовать большое представление? не совсем поняла, что оптимальнее для скорости обработки данных
 */


















