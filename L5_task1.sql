-- ����� � ������� users ���� created_at � updated_at ��������� ��������������. ��������� �� �������� ����� � ��������.

USE test1;

DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT '��� ����������',
  birthday_at DATE COMMENT '���� ��������',
  created_at DATE,
  updated_at DATE
) COMMENT = '����������';

INSERT INTO users (name, birthday_at) VALUES
  ('��������', '1990-10-05'),
  ('����', '1998-01-12'),
  ('�����', '1992-08-29');

UPDATE users
SET
	created_at = now(),
	updated_at = now()
WHERE
	id >= 1;

