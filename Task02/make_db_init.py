#!/usr/bin/env python3
"""
Утилита для генерации SQL-скрипта db_init.sql
Создаёт таблицы movies, ratings, tags, users и заполняет их данными
из файлов movies.csv, ratings.csv, tags.csv, users.txt
"""

import csv
import re


def escape(value):
    """Экранирует одинарные кавычки для SQL"""
    if value is None:
        return "NULL"
    return "'" + str(value).replace("'", "''") + "'"


def parse_movies(filename):
    """Читает movies.csv, вырезает год из title"""
    rows = []
    with open(filename, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            title = row["title"]
            match = re.search(r"\((\d{4})\)\s*$", title)
            if match:
                year = int(match.group(1))
                title_clean = title[:match.start()].strip()
            else:
                year = None
                title_clean = title
            rows.append((int(row["movieId"]), title_clean, year, row["genres"]))
    return rows


def parse_ratings(filename):
    """Читает ratings.csv"""
    rows = []
    with open(filename, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append((
                int(row["userId"]),
                int(row["movieId"]),
                float(row["rating"]),
                int(row["timestamp"]),
            ))
    return rows


def parse_tags(filename):
    """Читает tags.csv"""
    rows = []
    with open(filename, encoding="utf-8") as f:
        reader = csv.DictReader(f)
        for row in reader:
            rows.append((
                int(row["userId"]),
                int(row["movieId"]),
                row["tag"],
                int(row["timestamp"]),
            ))
    return rows


def parse_users(filename):
    """Читает users.txt (разделитель |)"""
    rows = []
    with open(filename, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            parts = line.split("|")
            rows.append((
                int(parts[0]),
                parts[1],
                parts[2],
                parts[3],
                parts[4],
                parts[5],
            ))
    return rows


def main():
    movies = parse_movies("movies.csv")
    ratings = parse_ratings("ratings.csv")
    tags = parse_tags("tags.csv")
    users = parse_users("users.txt")

    with open("db_init.sql", "w", encoding="utf-8") as f:
        # --- movies ---
        f.write("DROP TABLE IF EXISTS movies;\n")
        f.write("""CREATE TABLE movies (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    year INTEGER,
    genres TEXT
);\n""")
        for m in movies:
            year = m[2] if m[2] is not None else "NULL"
            f.write(f"INSERT INTO movies (id, title, year, genres) VALUES "
                    f"({m[0]}, {escape(m[1])}, {year}, {escape(m[3])});\n")
        f.write("\n")

        # --- ratings ---
        f.write("DROP TABLE IF EXISTS ratings;\n")
        f.write("""CREATE TABLE ratings (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    rating REAL NOT NULL,
    timestamp INTEGER NOT NULL
);\n""")
        for r in ratings:
            f.write(f"INSERT INTO ratings (user_id, movie_id, rating, timestamp) VALUES "
                    f"({r[0]}, {r[1]}, {r[2]}, {r[3]});\n")
        f.write("\n")

        # --- tags ---
        f.write("DROP TABLE IF EXISTS tags;\n")
        f.write("""CREATE TABLE tags (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    user_id INTEGER NOT NULL,
    movie_id INTEGER NOT NULL,
    tag TEXT,
    timestamp INTEGER NOT NULL
);\n""")
        for t in tags:
            f.write(f"INSERT INTO tags (user_id, movie_id, tag, timestamp) VALUES "
                    f"({t[0]}, {t[1]}, {escape(t[2])}, {t[3]});\n")
        f.write("\n")

        # --- users ---
        f.write("DROP TABLE IF EXISTS users;\n")
        f.write("""CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    gender TEXT,
    register_date TEXT,
    occupation TEXT
);\n""")
        for u in users:
            f.write(f"INSERT INTO users (id, name, email, gender, register_date, occupation) VALUES "
                    f"({u[0]}, {escape(u[1])}, {escape(u[2])}, {escape(u[3])}, {escape(u[4])}, {escape(u[5])});\n")

    print("Готово: db_init.sql")
    print(f"  movies: {len(movies)}")
    print(f"  ratings: {len(ratings)}")
    print(f"  tags: {len(tags)}")
    print(f"  users: {len(users)}")


if __name__ == "__main__":
    main()
