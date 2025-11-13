# Ngrok
### Without ngrok

* your Phoenix server is at `http://localhost:4000`
* **only** your computer can reach that address
* external webhook services **cannot** POST to that

  * because "localhost" doesn’t exist on the internet

### With ngrok

ngrok gives you a **public https URL** that tunnels into your local machine.

example:

you run this in terminal:

```bash
ngrok http 4000
```

ngrok shows you something like:

```
Forwarding  https://e1x9-23-104-12-99.ngrok-free.app -> http://localhost:4000
```

now the outside world can hit:

```
https://e1x9-23-104-12-99.ngrok-free.app/banked/checkout/result
```

and ngrok will tunnel that POST into your local Phoenix server:

```
http://localhost:4000/banked/checkout/result
```

### what this solves

when you are developing webhooks, most services (Banked, Stripe, Shopify, etc) need to POST to a real publicly accessible URL.

ngrok means:

* you keep coding locally
* you don’t deploy
* but the external service can still POST to you

### bonus: ngrok also gives an inspector UI

open in browser:

```
http://localhost:4040
```

ngrok shows every request it received → headers, body, timing, replay button.

this is insanely useful for webhook debugging.
# Install

### 1) download .deb from ngrok site

```bash
curl -sSL https://ngrok-agent.s3.amazonaws.com/ngrok.asc \
    | sudo tee /etc/apt/trusted.gpg.d/ngrok.asc >/dev/null

echo "deb https://ngrok-agent.s3.amazonaws.com buster main" \
    | sudo tee /etc/apt/sources.list.d/ngrok.list

sudo apt update
sudo apt install ngrok
```

> this is the official repo from ngrok

### 2) get an auth token

create a free account (if you don’t already have one):
[https://dashboard.ngrok.com/get-started/your-authtoken](https://dashboard.ngrok.com/get-started/your-authtoken)

copy the token they give you

### 3) add auth token locally

```bash
ngrok config add-authtoken <your_token_here>
```

### 4) run it

```bash
ngrok http 4000
```

you will then see output like:

```
Forwarding  https://abcd-1-2-3-4.ngrok-free.app -> http://localhost:4000
```

use that https URL at the webhook provider.

---

### alternative super simple one-liner install (if you don’t care about apt)

```bash
curl -s https://ngrok-agent.s3.amazonaws.com/ngrok.asc | sudo apt-key add -
echo "deb https://ngrok-agent.s3.amazonaws.com buster main" | sudo tee /etc/apt/sources.list.d/ngrok.list
sudo apt update && sudo apt install ngrok
```

but the first method is the current recommended.

## Dashboard
- https://dashboard.ngrok.com/traffic-inspector

# Alternative
- https://webhook.site/
