CREATE ROLE ml_readonly
WITH
    NOLOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    NOBYPASSRLS;

CREATE ROLE ml_service
WITH
    LOGIN
    NOSUPERUSER
    NOCREATEDB
    NOCREATEROLE
    NOREPLICATION
    NOBYPASSRLS
    CONNECTION LIMIT 20;

GRANT ml_readonly to ml_service;

ALTER ROLE ml_service
SET default_transaction_read_only = on;
ALTER ROLE ml_service
SET statement_timeout = '30s';
ALTER ROLE ml_service
SET idle_in_transaction_session_timeout = '60s';

CREATE SCHEMA IF NOT EXISTS ml AUTHORIZATION CURRENT_USER;

GRANT USAGE ON SCHEMA ml to ml_readonly;

CREATE OR REPLACE VIEW ml.user_features AS
SELECT
    id,
    faculty,
    date_joined,
    active,
    comments,
    posts,
    expired,
    locked
FROM public.users;

CREATE OR REPLACE VIEW ml.user_activity AS
SELECT
    user_id,
    active_in
FROM public.users_active_in;

CREATE OR REPLACE VIEW ml.resources AS
SELECT
    id,
    title,
    course,
    uploader,
    uploaded_at,
    download_url
FROM public.resources;

GRANT CONNECT ON DATABASE myappdb
TO ml_readonly;

GRANT USAGE ON SCHEMA ml
TO ml_readonly;

GRANT SELECT ON ALL TABLES IN SCHEMA ml
TO ml_readonly;
