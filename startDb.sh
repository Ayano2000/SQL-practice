docker-compose down -v
docker-compose up -d
sleep 3
export PGPASSWORD=postgres
cat databaseCreateSchema.sql | psql -h localhost -U postgres -d applicationsite
sleep 3
export PGPASSWORD=password
cat populateDatabase.sql | psql -h localhost -U service_worker -d applicationsite
