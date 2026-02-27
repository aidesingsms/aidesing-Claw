# Guia de Configuracion - AIDESING Claw en aidesing.ai.com

## Paso 1: Configurar DNS

En tu proveedor de DNS (donde gestionas aidesing.ai.com):

```
Tipo: A
Nombre: aidesing.ai.com
Valor: [IP_DE_TU_SERVIDOR]
TTL: 3600
```

## Paso 2: Configurar Servidor

### Instalar Nginx como reverse proxy:

```bash
sudo apt update
sudo apt install nginx certbot python3-certbot-nginx
```

### Configurar Nginx:

```bash
sudo nano /etc/nginx/sites-available/aidesing-claw
```

Contenido:
```nginx
server {
    listen 80;
    server_name aidesing.ai.com;

    location / {
        proxy_pass http://localhost:5000;
        proxy_http_version 1.1;
        proxy_set_header Upgrade $http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_cache_bypass $http_upgrade;
    }
}
```

Activar:
```bash
sudo ln -s /etc/nginx/sites-available/aidesing-claw /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl restart nginx
```

## Paso 3: SSL con Let's Encrypt

```bash
sudo certbot --nginx -d aidesing.ai.com
```

## Paso 4: Deploy del Panel

```bash
# En tu servidor
git clone [URL_DEL_REPO] /opt/aidesing-claw-panel
cd /opt/aidesing-claw-panel
pip install -r requirements.txt

# Crear servicio systemd
sudo nano /etc/systemd/system/aidesing-claw.service
```

Contenido del servicio:
```ini
[Unit]
Description=AIDESING Claw Panel
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/opt/aidesing-claw-panel
ExecStart=/usr/local/bin/gunicorn -w 4 -b 127.0.0.1:5000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
```

Activar:
```bash
sudo systemctl daemon-reload
sudo systemctl enable aidesing-claw
sudo systemctl start aidesing-claw
```

## Paso 5: Verificar

Accede a: https://aidesing.ai.com

Login default:
- Usuario: admin
- Contraseña: admin

## Comandos Utiles

```bash
# Ver estado
sudo systemctl status aidesing-claw

# Ver logs
sudo journalctl -u aidesing-claw -f

# Reiniciar
sudo systemctl restart aidesing-claw

# Actualizar (despues de cambios)
cd /opt/aidesing-claw-panel
git pull
sudo systemctl restart aidesing-claw
```
