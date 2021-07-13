/* 1. Проанализировать структуру БД vk, которую мы создали на занятии, и внести предложения по усовершенствованию (если такие идеи есть).
Напишите пожалуйста, всё-ли понятно по структуре.


Да, все понятно. Усовершенствовать можно, например, таблицу messages для возможности писать в приватный и групповой чаты.
Для этого добавить две таблицы: chat и chat_members
*/
CREATE TABLE chat(
	id SERIAL PRIMARY KEY,
	chat_type ENUM('private', 'group') NOT NULL,
	chat_name VARCHAR(130)
);

CREATE TABLE chat_members(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	chat_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (user_id) REFERENCES users(id),
	FOREIGN KEY (chat_id) REFERENCES chat(id)
);

-- А таблицу messages немного переделать
CREATE TABLE chat_messages(
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
	chat_id BIGINT UNSIGNED NOT NULL,
	txt TEXT NOT NULL,
	is_delivered BOOLEAN DEFAULT FALSE,
	created_at DATETIME NOT NULL DEFAULT NOW(),
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT "Время обновления строки",
	INDEX messages_from_user_id_idx (from_user_id),
	CONSTRAINT fk_chat_from_user_id FOREIGN KEY (from_user_id) REFERENCES users (id),
	FOREIGN KEY (chat_id) REFERENCES chat(id)
);


/*
 * 2. Добавить необходимую таблицу/таблицы для того, чтобы можно было использовать лайки для медиафайлов, постов и пользователей.
 * 
 * Например, для таблицы media
 */
CREATE TABLE media_reaction(
	user_id BIGINT UNSIGNED NOT NULL,
	reaction_id BIGINT UNSIGNED NOT NULL,
	media_id BIGINT UNSIGNED NOT NULL,
	CONSTRAINT fk_user_react_id FOREIGN KEY (user_id) REFERENCES users (id),
	CONSTRAINT fk_media_react_id FOREIGN KEY (media_id) REFERENCES media (id),
	FOREIGN KEY (reaction_id) REFERENCES reaction (id)
);

CREATE TABLE reaction(
	id SERIAL PRIMARY KEY,
	reaction_type ENUM('like', 'dislike', 'sorry', 'happy', 'anger') DEFAULT NUll
);

