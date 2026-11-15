-- 1. Добавляем 5 новых пользователей (себя + 4 соседей)
INSERT INTO users (name, email, gender, register_date, occupation_id)
VALUES 
    ('Семонченков Илья Витальевич', 'semonchenkov@student.mrsu.ru', 'male', date('now'),
        (SELECT id FROM occupations WHERE name = 'student')),
    ('Сульдина Алина Николаевна', 'suldina@student.mrsu.ru', 'female', date('now'),
        (SELECT id FROM occupations WHERE name = 'student')),
    ('Тужилкин Егор Витальевич', 'tuzhilkin@student.mrsu.ru', 'male', date('now'),
        (SELECT id FROM occupations WHERE name = 'student')),
    ('Федорова Дарья Алексеевна', 'fedorova@student.mrsu.ru', 'female', date('now'),
        (SELECT id FROM occupations WHERE name = 'student')),
    ('Чадин Евгений Юрьевич', 'chadin@student.mrsu.ru', 'male', date('now'),
        (SELECT id FROM occupations WHERE name = 'student'));

-- 2. Добавляем 3 новых фильма разных жанров
INSERT INTO movies (title, year)
VALUES 
    ('Дюна: Часть вторая (Dune: Part Two)', 2024),
    ('Оппенгеймер (Oppenheimer)', 2023),
    ('Человек-паук: Паутина вселенных (Spider-Man: Across the Spider-Verse)', 2023);

-- Добавляем жанры (если их нет)
INSERT OR IGNORE INTO genres (name) VALUES ('Sci-Fi');
INSERT OR IGNORE INTO genres (name) VALUES ('Biography');
INSERT OR IGNORE INTO genres (name) VALUES ('History');
INSERT OR IGNORE INTO genres (name) VALUES ('Animation');

-- Связываем фильмы с жанрами (ID через подзапросы — не хардкодим)
INSERT INTO movie_genres (movie_id, genre_id)
VALUES 
    ((SELECT id FROM movies WHERE title = 'Дюна: Часть вторая (Dune: Part Two)'), 
     (SELECT id FROM genres WHERE name = 'Sci-Fi')),
    ((SELECT id FROM movies WHERE title = 'Оппенгеймер (Oppenheimer)'), 
     (SELECT id FROM genres WHERE name = 'Biography')),
    ((SELECT id FROM movies WHERE title = 'Человек-паук: Паутина вселенных (Spider-Man: Across the Spider-Verse)'), 
     (SELECT id FROM genres WHERE name = 'Animation'));

-- 3. Добавляем 3 отзыва о новых фильмах от меня
INSERT INTO ratings (user_id, movie_id, rating, timestamp)
VALUES 
    ((SELECT id FROM users WHERE email = 'semonchenkov@student.mrsu.ru'),
     (SELECT id FROM movies WHERE title = 'Дюна: Часть вторая (Dune: Part Two)'),
     5.0, strftime('%s', 'now')),
    ((SELECT id FROM users WHERE email = 'semonchenkov@student.mrsu.ru'),
     (SELECT id FROM movies WHERE title = 'Оппенгеймер (Oppenheimer)'),
     4.5, strftime('%s', 'now')),
    ((SELECT id FROM users WHERE email = 'semonchenkov@student.mrsu.ru'),
     (SELECT id FROM movies WHERE title = 'Человек-паук: Паутина вселенных (Spider-Man: Across the Spider-Verse)'),
     5.0, strftime('%s', 'now'));
