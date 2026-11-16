
PRAGMA foreign_keys = ON;

-- 1. Категории автомобилей
CREATE TABLE car_categories (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- 2. Справочник услуг
CREATE TABLE services (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    category_id INTEGER NOT NULL,
    name TEXT NOT NULL,
    duration_minutes INTEGER NOT NULL CHECK (duration_minutes > 0),
    price REAL NOT NULL CHECK (price >= 0),
    FOREIGN KEY (category_id) REFERENCES car_categories(id) ON DELETE RESTRICT
);

-- 3. Сотрудники (история сохраняется, уволенных не удаляем)
CREATE TABLE employees (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    full_name TEXT NOT NULL,
    phone TEXT UNIQUE,
    hire_date DATE NOT NULL DEFAULT (date('now')),
    fire_date DATE DEFAULT NULL,
    salary_percent REAL NOT NULL CHECK (salary_percent > 0 AND salary_percent <= 100)
);

-- 4. Боксы
CREATE TABLE boxes (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT NOT NULL UNIQUE
);

-- 5. Записи на работу (бронирование)
CREATE TABLE appointments (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    client_name TEXT NOT NULL,
    client_phone TEXT NOT NULL,
    service_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    box_id INTEGER NOT NULL,
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT,
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT,
    FOREIGN KEY (box_id) REFERENCES boxes(id) ON DELETE RESTRICT
);

-- 6. Выполненные работы (Заказ-наряды)
CREATE TABLE work_orders (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    employee_id INTEGER NOT NULL,
    service_id INTEGER NOT NULL,
    box_id INTEGER NOT NULL,
    completion_date DATETIME NOT NULL DEFAULT (datetime('now')),
    price_paid REAL NOT NULL CHECK (price_paid >= 0),
    FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE RESTRICT,
    FOREIGN KEY (service_id) REFERENCES services(id) ON DELETE RESTRICT,
    FOREIGN KEY (box_id) REFERENCES boxes(id) ON DELETE RESTRICT
);

-- ==========================================
-- ТЕСТОВЫЕ ДАННЫЕ
-- ==========================================

-- Категории
INSERT INTO car_categories (name) VALUES ('Легковая'), ('Внедорожник'), ('Мотоцикл');

-- Услуги
INSERT INTO services (category_id, name, duration_minutes, price) VALUES 
(1, 'Мойка кузова', 30, 500), 
(1, 'Химчистка салона', 120, 3000),
(2, 'Мойка кузова', 45, 800), 
(2, 'Химчистка салона', 180, 4500),
(3, 'Мойка', 15, 300);

-- Сотрудники
INSERT INTO employees (full_name, phone, hire_date, salary_percent) VALUES 
('Иванов Иван', '+79990001122', '2023-01-15', 30),
('Петров Петр', '+79990003344', '2022-05-10', 40);

UPDATE employees SET fire_date = '2024-01-01' WHERE full_name = 'Петров Петр';

-- Боксы
INSERT INTO boxes (name) VALUES ('Бокс 1'), ('Бокс 2');

-- Записи
INSERT INTO appointments (client_name, client_phone, service_id, employee_id, box_id, start_time, end_time) VALUES 
('Клиент А', '+79991112233', 1, 1, 1, '2024-05-20 10:00:00', '2024-05-20 10:30:00'),
('Клиент Б', '+79994445566', 3, 1, 2, '2024-05-20 11:00:00', '2024-05-20 11:45:00');

-- Выполненные работы
INSERT INTO work_orders (employee_id, service_id, box_id, price_paid) VALUES 
(1, 1, 1, 500),
(1, 2, 2, 3000),
(2, 3, 1, 800);
