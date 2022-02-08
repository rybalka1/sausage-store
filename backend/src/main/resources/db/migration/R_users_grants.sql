GRANT CONNECT ON DATABASE "ha-ya-practics" TO read_user;
GRANT CONNECT ON DATABASE "ha-ya-practics" TO write_user;
GRANT CONNECT ON DATABASE "ha-ya-practics" TO admin_user;
GRANT USAGE ON SCHEMA public TO read_user;
GRANT USAGE ON SCHEMA public TO write_user;
GRANT USAGE ON SCHEMA public TO admin_user;
GRANT SELECT ON ALL TABLES IN SCHEMA public TO read_user;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO write_user;
GRANT ALL PRIVILEGES ON DATABASE "ha-ya-practics" TO admin_user;
