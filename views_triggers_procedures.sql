-- представление, показывающее расписание запланированных занятий

CREATE OR REPLACE VIEW view_planned_activity_schedule
AS
SELECT s.id, c.week_day AS week_day, c.start_time AS start_time, ga.coach_sport_type_id AS coach_sport, ga.id AS group_id, as2.name AS status, gm.member_card_id AS card
FROM schedule s 
	JOIN group_activity ga ON s.group_activity_id = ga.id 
	JOIN calendar c ON s.calendar_id = c.id
	JOIN activity_status as2 ON s.activity_status_id = as2.id
	JOIN group_members gm ON s.group_activity_id  = gm.group_activity_id
WHERE as2.name = 'по плану';

SELECT * FROM view_planned_activity_schedule WHERE card = 1 ORDER BY week_day; -- выбираем расписание для конкретного клиента

SELECT week_day, start_time, coach_sport, group_id, status 
FROM view_planned_activity_schedule
WHERE week_day = '1'
GROUP BY group_id
ORDER BY start_time; -- выбираем занятия в определенный день недели

-- представление, показывающее тренеров и виды спорта

CREATE OR REPLACE VIEW view_coach_sport_type
AS
SELECT cst.id AS cst_id, st.name AS sport_type, concat(c.first_name, ' ', c.last_name) AS coach_name, c.id AS coach_id
FROM coach_sport_type cst 
	JOIN coach c ON c.id = cst.coach_id 
	JOIN sport_type st ON st.id = cst.sport_id;

SELECT week_day, start_time, group_id, status, vcst.coach_id, vcst.coach_name, vcst.sport_type 
FROM view_planned_activity_schedule vpas
	JOIN view_coach_sport_type vcst ON cst_id = coach_sport
WHERE coach_id = 4
GROUP BY start_time
ORDER BY week_day; -- объединяем два представления, чтобы увидеть расписание тренера


-- смотрим загруженность зала/зоны

SELECT week_day AS week_day_number, 
	CASE (week_day)
		WHEN '1' THEN 'понедельник'
		WHEN '2' THEN 'вторник'
		WHEN '3' THEN 'среда'
		WHEN '4' THEN 'четверг'
		WHEN '5' THEN 'пятница'
		WHEN '6' THEN 'суббота'
		WHEN '7' THEN 'воскресенье'
	END AS week_day, 
		start_time,
	(SELECT
		(SELECT name
		FROM activity_status
		WHERE id = schedule.activity_status_id)
	FROM schedule
	WHERE calendar_id = calendar.id) AS activity_status,
	(SELECT name
	FROM gym_zone
	WHERE id = calendar.gym_zone_id) AS gym_zone
FROM calendar
WHERE gym_zone_id = 1
ORDER BY week_day_number;
-- триггер. проверяем наличие мест в группе

DROP TRIGGER IF EXISTS check_member_quantity_before_update;

delimiter //

CREATE TRIGGER check_member_quantity_before_update BEFORE UPDATE ON group_activity
FOR EACH ROW
	BEGIN
		IF NEW.member_quantity < 0 THEN 
			SIGNAL SQLSTATE '45000' SET message_text = 'места в группе закончились';
		END IF;
	END //

delimiter ;

-- процедура. записываем в группу, уменьшая кол-во свободных мест

DROP PROCEDURE IF EXISTS sp_add_member_to_group;

delimiter //

CREATE PROCEDURE sp_add_member_to_group (member_card_id int, group_activity_id int)
BEGIN
	START TRANSACTION;
		INSERT INTO group_members (member_card_id, group_activity_id)
		VALUES (member_card_id, group_activity_id);
		UPDATE group_activity SET member_quantity = member_quantity-1 WHERE id = group_activity_id;
	COMMIT;
END //

delimiter ;
