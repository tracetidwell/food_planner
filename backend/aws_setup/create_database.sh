#!/bin/bash
# Create the meal_planner database on the existing RDS instance.
# Prerequisites: Port forwarding must be active (run connect_db.sh first in another terminal).

set -e

echo "Creating meal_planner database..."
echo "Make sure port forwarding is active (run connect_db.sh in another terminal)."
echo ""

read -p "Enter RDS master password: " -s MASTER_PASSWORD
echo ""

PGPASSWORD="$MASTER_PASSWORD" psql -h localhost -U postgres -c "CREATE DATABASE meal_planner;" && \
  echo "Database 'meal_planner' created successfully!" || \
  echo "Failed. See error above."
