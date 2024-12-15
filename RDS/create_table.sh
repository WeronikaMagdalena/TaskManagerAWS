#!/bin/bash
terraform apply -auto-approve
export PGPASSWORD="password" # set ?
DB_ENDPOINT=$(terraform output -raw db_instance_endpoint)
psql -U wera -h $DB_ENDPOINT postgres -c "CREATE TABLE task (id SERIAL PRIMARY KEY, title VARCHAR(255) NOT NULL, description TEXT, deadline DATE, completed BOOLEAN DEFAULT FALSE);"
