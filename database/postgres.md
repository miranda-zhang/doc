# login
```sh
sudo -i -u postgres
psql -d databasename -U username -h hostname -p port
```
* `databasename` → the database you want to connect to
* `-U username` → optional, the PostgreSQL user
* `-h hostname` → optional, defaults to localhost
* `-p port` → optional, defaults to 5432


# usefull sql
```sql
-- search all tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_name LIKE '%product%';
```
