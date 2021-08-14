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
	member_quantity INT DEFAULT 1,
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
	name VARCHAR(50) NOT NULL UNIQUE
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
