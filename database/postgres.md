# login
```sh
sudo -i -u postgres
```
# usefull sql
```sql
-- search all tables
SELECT table_name 
FROM information_schema.tables 
WHERE table_name LIKE '%payment%';
```
