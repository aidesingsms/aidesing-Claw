#!/bin/bash
# Deploy script para AIDESING Claw Panel

set -e

echo "🚀 Deploy de AIDESING Claw Panel"
echo "================================"

# Variables
DOMAIN="aidesing.ai.com"
SERVER_USER="root"
SERVER_IP="TU_IP_AQUI"  # Cambiar por la IP de tu servidor
PANEL_DIR="/opt/aidesing-claw-panel"

# Instalar dependencias
echo "📦 Instalando dependencias..."
pip install -r requirements.txt

# Crear directorio en servidor
echo "📁 Configurando servidor..."
ssh $SERVER_USER@$SERVER_IP "mkdir -p $PANEL_DIR"

# Copiar archivos
echo "📤 Subiendo archivos..."
scp -r ./* $SERVER_USER@$SERVER_IP:$PANEL_DIR/

# Configurar systemd service
echo "⚙️  Configurando servicio..."
ssh $SERVER_USER@$SERVER_IP "cat > /etc/systemd/system/aidesing-claw.service << 'EOF'
[Unit]
Description=AIDESING Claw Panel
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=$PANEL_DIR
Environment=PATH=/usr/local/bin:/usr/bin
ExecStart=/usr/local/bin/gunicorn -w 4 -b 0.0.0.0:5000 app:app
Restart=always

[Install]
WantedBy=multi-user.target
EOF"

# Iniciar servicio
ssh $SERVER_USER@$SERVER_IP "
    systemctl daemon-reload
    systemctl enable aidesing-claw
    systemctl restart aidesing-claw
"

echo "✅ Deploy completado!"
echo ""
echo "🌐 Accede a: http://$DOMAIN"
echo ""
echo "📋 Comandos utiles:"
echo "  - Ver estado: systemctl status aidesing-claw"
echo "  - Ver logs: journalctl -u aidesing-claw -f"
echo "  - Reiniciar: systemctl restart aidesing-claw"
