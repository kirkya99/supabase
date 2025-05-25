cp dump.sql dump.sql.bak
rm dump.sql
docker exec -t supabase-db pg_dump -U postgres -d postgres > dump.sql
git add dump.sql
git commit -m "supabase-db backup"
git pull
git push

