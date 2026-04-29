# TLS / HTTPS Setup Guide

## Why HTTPS is required

All login and API traffic must be encrypted in transit.
Passwords, JWT tokens, and financial data travel between the browser and server — **anyone intercepting plain HTTP can read them**.

## Current architecture

```
Browser → [HTTPS required] → Caddy/nginx (TLS termination) → [HTTP, internal Docker network] → frontend → API
```

- Browser ↔ public server: **must be HTTPS**
- Frontend ↔ API: internal Docker bridge (`finance-tracker-network`) — never exposed publicly

## Option A: Caddy (recommended — automatic TLS with Let's Encrypt)

1. Install Caddy on the host:
   ```bash
   apt install -y caddy
   ```

2. Create `/etc/caddy/Caddyfile`:
   ```
   app.yourdomain.com {
       reverse_proxy localhost:3000
   }
   ```
   Caddy automatically provisions and renews a Let's Encrypt certificate.

3. Update `.env`:
   ```
   CORS_ALLOWED_ORIGINS=https://app.yourdomain.com
   ```

4. Restart:
   ```bash
   systemctl reload caddy
   ./redeploy.sh all
   ```

## Option B: nginx with certbot

1. Install certbot and get a certificate:
   ```bash
   certbot --nginx -d app.yourdomain.com
   ```

2. Add to your nginx virtualhost:
   ```nginx
   server {
       listen 443 ssl;
       ssl_certificate     /etc/letsencrypt/live/app.yourdomain.com/fullchain.pem;
       ssl_certificate_key /etc/letsencrypt/live/app.yourdomain.com/privkey.pem;
       ssl_protocols       TLSv1.2 TLSv1.3;
       ssl_ciphers         HIGH:!aNULL:!MD5;

       # Force HTTPS
       add_header Strict-Transport-Security "max-age=31536000; includeSubDomains; preload" always;

       location / {
           proxy_pass http://localhost:3000;
       }
   }

   # Redirect HTTP → HTTPS
   server {
       listen 80;
       return 301 https://$host$request_uri;
   }
   ```

3. Update `.env`:
   ```
   CORS_ALLOWED_ORIGINS=https://app.yourdomain.com
   ```

## Option C: Local development (no TLS needed)

For local development (`localhost`), HTTP is acceptable:
- Browsers treat `localhost` as a secure origin
- Traffic never leaves your machine
- `CORS_ALLOWED_ORIGINS=http://localhost:3000` is fine

## Security checklist

- [ ] HTTPS configured for all public-facing endpoints
- [ ] `CORS_ALLOWED_ORIGINS` set to exact `https://` domain (not `*`)
- [ ] `HSTS` header enabled in nginx (uncomment in `nginx.conf`)
- [ ] Spring Boot `HSTS` header active (already in `SecurityConfig.java`)
- [ ] Firewall: only ports 80/443 open publicly; 3000/8080 internal only
- [ ] No passwords or tokens ever passed in URL query parameters ✅
- [ ] JWT stored in `sessionStorage` (not `localStorage`) ✅
- [ ] All auth endpoints use `POST` with JSON body ✅
