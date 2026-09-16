#!/bin/bash
# Exports all overdue loans to a dated CSV file

DB_NAME="bank_system"
DB_USER="postgres"
OUTPUT_FILE="overdue_loans_$(date +%F).csv"

"/c/Program Files/PostgreSQL/18/bin/psql.exe" -U "$DB_USER" -d "$DB_NAME" \
  -c "SELECT * FROM loans WHERE status='overdue'" \
  -A -F',' --pset footer=off > "$OUTPUT_FILE"

echo "Report exported to $OUTPUT_FILE"