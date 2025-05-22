cat dump.sql | docker exec -i supabase-db psql -U postgres -d postgres
docker compose down
docker compose up -d
