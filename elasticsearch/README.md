Change elasticsearch jvm setting to use only 1 GB of memory.
> /etc/elasticsearch/jvm.options
```sh
sudo nano /etc/elasticsearch/jvm.options
```
-Xms1g
-Xmx1g
```
Make sure the file permission is correct
```sh
sudo chown -R elasticsearch:elasticsearch /etc/elasticsearch
```
Check log for error msg
```sh
sudo journalctl -u elasticsearch.service -b
```
