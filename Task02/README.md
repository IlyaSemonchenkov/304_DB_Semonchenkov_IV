# Лабораторная работа 2

## Требования к окружению

Для работы `db_init.bat` нужно:

- Python 3
- SQLite 3
- Bash

## Файлы

- `make_db_init.py` — утилита, генерирующая `db_init.sql`
- `db_init.bat` — скрипт запуска (генерирует SQL + загружает в БД)
- `db_init.sql` — сгенерированный SQL-скрипт
- `movies_rating.db` — база данных SQLite
- `movies.csv`, `ratings.csv`, `tags.csv`, `users.txt` — исходные данные

## Запуск

```bash
bash db_init.bat
