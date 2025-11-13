# Backgropund knowledge
## JWE

### 1️⃣ What is a JWE?

* **JWE** = **JSON Web Encryption**, a standard (RFC 7516).
* Purpose: **encrypt a JWT** (or any JSON data) to keep its contents confidential.
* Unlike **JWS**, which **signs** data, **JWE encrypts** it so only the intended recipient can read it.

---

### 2️⃣ JWE Structure

A JWE is usually composed of **five base64url-encoded parts**, separated by dots:

```
HEADER.ENCRYPTED_KEY.IV.CIPHERTEXT.AUTH_TAG
```

Where:

1. **Header** → JSON metadata about encryption algorithms (e.g., `"alg": "RSA-OAEP-256"`, `"enc": "A256GCM"`)
2. **Encrypted Key** → The content encryption key (CEK) encrypted with the recipient’s key
3. **IV (Initialization Vector)** → Random value for encryption
4. **Ciphertext** → The encrypted payload (your claims or data)
5. **Authentication Tag** → Used to verify integrity (like a MAC)

---

### 3️⃣ Example Header

```json
{
  "alg": "RSA-OAEP-256",
  "enc": "A256GCM",
  "typ": "JWT"
}
```

* `alg`: Algorithm used to encrypt the key (RSA-OAEP-256 in this example)
* `enc`: Algorithm used to encrypt the payload (AES-256-GCM here)
* `typ`: Token type (JWT)

---

### 4️⃣ Key Points

* **JWE protects confidentiality**, unlike JWS, which protects **integrity and authenticity**.
* JWE can also be **signed and then encrypted** (nested tokens) for **both authenticity and confidentiality**.
* Decrypting a JWE requires the **recipient’s private key** if asymmetric encryption was used.

---

## JWS vs JWE

**Side-by-side comparison diagram** of a signed JWT (JWS) vs an encrypted JWT (JWE):

```
┌─────────────────────────────┐        ┌──────────────────────────────────────────┐
│       JWS (Signed JWT)      │        │          JWE (Encrypted JWT)             │
├─────────────────────────────┤        ├──────────────────────────────────────────┤
│ Purpose:                     │        │ Purpose:                                 │
│ - Verify integrity           │        │ - Protect confidentiality               │
│ - Authenticate issuer        │        │ - Ensure only intended recipient reads │
├─────────────────────────────┤        ├──────────────────────────────────────────┤
│ Structure:                   │        │ Structure:                               │
│ HEADER.PAYLOAD.SIGNATURE      │        │ HEADER.ENCRYPTED_KEY.IV.CIPHERTEXT.AUTH_TAG │
├─────────────────────────────┤        ├──────────────────────────────────────────┤
│ Header example:              │        │ Header example:                          │
│ {                            │        │ {                                        │
│   "alg": "PS512",           │        │   "alg": "RSA-OAEP-256",               │
│   "typ": "JWT"              │        │   "enc": "A256GCM",                     │
│ }                            │        │   "typ": "JWT"                          │
├─────────────────────────────┤        ├──────────────────────────────────────────┤
│ Signature:                   │        │ Encrypted payload:                        │
│ - Created with private key   │        │ - Payload encrypted using CEK           │
│ - Verified with public key   │        │ - CEK encrypted with recipient's key   │
├─────────────────────────────┤        ├──────────────────────────────────────────┤
│ Use case:                    │        │ Use case:                                │
│ - Identity tokens (auth)     │        │ - Sensitive info (credit cards, SSN)   │
│ - Data integrity             │        │ - Confidential claims                    │
└─────────────────────────────┘        └──────────────────────────────────────────┘
```

💡 **Extra note:**

You can also do **nested JWTs**:

* First **sign (JWS)** → ensures authenticity
* Then **encrypt (JWE)** → ensures confidentiality
* Result: a **signed + encrypted JWT**, which is common in high-security applications.

Alright! Let’s break down **OAuth** clearly, step by step, and connect it to JWT, JWS, and JWE.

---
# OAuth
## What is OAuth?

* **OAuth** = **Open Authorization**
* It’s an **open standard for access delegation**.
* Purpose: Allow one application (the “client”) to **access resources on behalf of a user** without sharing the user’s password.

Example: “Log in with Google” on a third-party app — the app doesn’t get your Google password; it gets a **token** that grants limited access.

---

## Access Tokens

* Tokens are what the client uses to access resources.
* Can be in different formats:

  * **Opaque token** → random string, server stores the actual data.
  * **JWT token** → self-contained token, often **signed with JWS** (PS512, RS256, etc.) or **encrypted with JWE**.

**Example: JWT as OAuth Access Token**

```json
{
  "sub": "1234567890",
  "name": "Alice",
  "scope": "read:calendar",
  "iat": 1700000000,
  "exp": 1700003600
}
```

* **Signed** → integrity and authenticity (JWS)
* **Encrypted** → confidentiality (JWE)

# Webhook Security Considerations

Since webhooks are **incoming requests from an external service**, you need to verify that the request is authentic:

| Method                      | Description                                                                                   |
| --------------------------- | --------------------------------------------------------------------------------------------- |
| **Secret / HMAC Signature** | Sender signs the payload using a shared secret. Receiver recomputes HMAC to verify integrity. |
| **JWT / JWS**               | Sender signs the webhook payload as a JWT. Receiver verifies signature using public key.      |
| **TLS/HTTPS**               | Ensure data is encrypted in transit.                                                          |
| **IP Whitelisting**         | Only accept requests from known sender IP addresses.                                          |

**Example using JWS:**

* Sender creates a JWT with payload: `{ "event": "payment_succeeded", "amount": 100 }`
* Signs it with PS512.
* Sends JWT in `Authorization` header or request body.
* Receiver verifies the signature using sender’s public key.
