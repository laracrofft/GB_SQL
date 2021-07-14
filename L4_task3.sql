SELECT * FROM media_types;

UPDATE media_types 
SET name = 'image'
WHERE id = 1;

UPDATE media_types 
SET name = 'audio'
WHERE id = 2;

UPDATE media_types 
SET name = 'video'
WHERE id = 3;

UPDATE media_types 
SET name = 'document'
WHERE id = 4;

SELECT * FROM friend_requests;

DELETE FROM friend_requests WHERE from_user_id = to_user_id;

ALTER TABLE friend_requests 
ADD CONSTRAINT sender_not_reciever_check
CHECK (from_user_id != to_user_id);

