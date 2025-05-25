#!/bin/bash

set -e  # Exit immediately on any error

# Function to restore backup if something goes wrong
handle_error() {
  echo "Error occurred. Restoring previous dump..."
  if [ -f dump.sql.bak ]; then
    cp dump.sql.bak dump.sql
    echo "dump.sql restored from backup."
  else
    echo "No backup found to restore."
  fi
  exit 1
}

# Trap errors and call handler
trap 'handle_error' ERR

# Step 1: Backup existing dump.sql if it exists
if [ -f dump.sql ]; then
  cp dump.sql dump.sql.bak
  echo "Existing dump.sql backed up to dump.sql.bak"
fi

# Step 2: Create new dump
echo "Dumping supabase-db..."
docker exec -t supabase-db pg_dump -U postgres -d postgres > dump.sql

# Step 3: Add and commit to git
echo "Committing dump.sql to git..."
git add dump.sql
git commit -m "supabase-db backup"
git pull --rebase
git push
rm dump.sql.bak
echo "Backup complete and synced with GitHub."
