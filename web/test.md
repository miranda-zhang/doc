# ✅ Linux: Block by domain using SNI (TLS hostname) match
```sh
sudo apt update
sudo apt install iptables

```
This works **even if the IP changes**, because the TLS handshake includes the domain.

```bash
sudo iptables -A OUTPUT -p tcp --dport 443 \
  -m string --string "api.banked.com" --algo bm -j REJECT
```

Remove it:

```bash
sudo iptables -D OUTPUT -p tcp --dport 443 \
  -m string --string "api.banked.com" --algo bm -j REJECT
```
