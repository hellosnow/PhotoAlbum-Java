-- PostgreSQL initialization script for Photo Album application
-- This script runs automatically when PostgreSQL container starts

-- Create extension for UUID support (optional, using Java UUID generation)
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Grant all privileges to photoalbum user on the photoalbum database
-- Note: The user and database are already created by Docker environment variables
GRANT ALL PRIVILEGES ON DATABASE photoalbum TO photoalbum;

-- Ensure the photoalbum user has proper permissions on the public schema
GRANT ALL ON SCHEMA public TO photoalbum;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO photoalbum;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO photoalbum;

-- Set default privileges for future tables
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO photoalbum;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO photoalbum;
