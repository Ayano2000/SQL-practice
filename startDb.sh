docker-compose down -v
docker-compose up -d
sleep 3
export PGPASSWORD=postgres
cat databaseCreateSchema.sql | psql -h localhost -U postgres -d applicationsite
