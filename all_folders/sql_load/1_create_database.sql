CREATE DATABASE sql_course;

-- DROP DATABASE IF EXISTS sql_course;

SELECT pg_terminate_backend(pid)
FROM pg_stat_activity
WHERE datname = 'sql_course' AND pid <> pg_backend_pid();

DROP DATABASE sql_course;