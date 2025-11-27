# Fix cert not correctly installed

Check chrome cached correct root CA in
[Cert Manager](chrome://certificate-manager/localcerts/platformcerts)

And make sure it is enabled/trusted.

Useful commands:

```bash
# Check what mkcert CAs are in the system store
ls -la /etc/ssl/certs/ | grep mkcert

# Remove any old mkcert root@debian entries
sudo rm -f /usr/local/share/ca-certificates/mkcert*.crt
sudo rm -f /etc/ssl/certs/mkcert*.pem

# Reinstall only the correct one
sudo cp /home/mirandazhang/.local/share/mkcert/rootCA.pem /usr/local/share/ca-certificates/mkcert-ca.crt

# Update system certificates
sudo update-ca-certificates --fresh

# Verify only the correct one remains
ls -la /etc/ssl/certs/ | grep mkcert
```

Nuclear Option - Complete System Reset

```bash
# Remove ALL mkcert traces from system
sudo mkcert -uninstall
sudo rm -f /usr/local/share/ca-certificates/mkcert*
sudo rm -f /etc/ssl/certs/mkcert*
sudo update-ca-certificates --fresh

# Reinstall fresh
mkcert -install
cd /etc/ssl/certs/sydneytools/
mkcert -key-file nginx-mkcert.key -cert-file nginx-mkcert.crt relay-sydneytools.com.au www.relay-sydneytools.com.au localhost 127.0.0.1 ::1

# Restart nginx
sudo systemctl restart nginx
```

## Verify the Fix

After cleaning:

```bash

# Verify your certificate
openssl verify -CApath /etc/ssl/certs/ /etc/ssl/certs/sydneytools/nginx-mkcert.crt

# Test with curl
curl -I https://relay-sydneytools.com.au/

# Check what the server is returning
openssl s_client -connect relay-sydneytools.com.au:443 -servername relay-sydneytools.com.au | openssl x509 -noout -issuer -subject -dates -fingerprint

# check root CA fingerprint should match chrome cert mamager
openssl x509 -noout -fingerprint -sha256 -in "$(mkcert -CAROOT)/rootCA.pem"
```
