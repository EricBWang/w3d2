PRAGMA foreign_keys = ON;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

DROP TABLE IF EXISTS questions;
CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER NOT NULL,
  FOREIGN KEY (author_id) REFERENCES users(id) 
);

DROP TABLE IF EXISTS question_follows;
CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS replies;
CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  parent_reply_id INTEGER,
  user_id INTEGER NOT NULL,
  body TEXT NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (parent_reply_id) REFERENCES replies(id),
  FOREIGN KEY (user_id) REFERENCES users(id) 
);

DROP TABLE IF EXISTS question_likes;
CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id) 
);

INSERT INTO
  users (fname, lname)
VALUES
  ('Ben', 'Franklin'),
  ('Jim', 'West'),
  ('John', 'Hilfinger'),
  ('Baeu', 'LeWatever');

INSERT INTO
  questions (title, body, author_id)
VALUES
  ('Database Seeding', 'How do I seed a database I need help I feel so dumb right now', 2),
  ('Monitor Help', 'How do I turn on the app Academy monitors?', 2),
  ('Nested Loops', 'How many layers of nested loops would it take to make my computer explode?', 4);

INSERT INTO
  replies (question_id, parent_reply_id, user_id, body)
VALUES
  (2, NULL, 1, 'Smash your head through it.'),
  (3, NULL, 3, 'No definitive answer but a sledge hammer would do the job.'),
  (2, 1, 3, 'Or use a sledge hammer...');

INSERT INTO
  question_follows (question_id, user_id)
VALUES
  (3, 3),
  (3, 1),
  (1, 3),
  (3, 2);

INSERT INTO
  question_likes (question_id, user_id)
VALUES
  (3, 3),
  (2, 2),
  (2, 4),
  (1, 3);