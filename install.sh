#!/bin/bash
# AIDESING Claw - Script de Instalación Automática
# One-click setup for AIDESING Claw

set -e

echo "🦞 AIDESING Claw - Instalación Automática"
echo "=========================================="
echo ""

# Colores
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Verificar requisitos
echo -e "${BLUE}📋 Verificando requisitos...${NC}"

# Node.js
if ! command -v node &> /dev/null; then
    echo -e "${YELLOW}⚠️  Node.js no encontrado. Instalando...${NC}"
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash -
    apt-get install -y nodejs
fi

NODE_VERSION=$(node --version)
echo -e "${GREEN}✅ Node.js ${NODE_VERSION} instalado${NC}"

# Git
if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}⚠️  Git no encontrado. Instalando...${NC}"
    apt-get update && apt-get install -y git
fi
echo -e "${GREEN}✅ Git instalado${NC}"

# Directorio de instalación
INSTALL_DIR="${HOME}/.aidesing-claw"
echo -e "${BLUE}📁 Directorio de instalación: ${INSTALL_DIR}${NC}"

# Crear directorio
mkdir -p ${INSTALL_DIR}
cd ${INSTALL_DIR}

# Clonar repositorio (o actualizar si existe)
if [ -d "aidesing-claw-core" ]; then
    echo -e "${BLUE}🔄 Actualizando AIDESING Claw...${NC}"
    cd aidesing-claw-core
    git pull origin main
else
    echo -e "${BLUE}📥 Descargando AIDESING Claw...${NC}"
    git clone https://github.com/aidesingsms/aidesing-claw.git aidesing-claw-core
    cd aidesing-claw-core
fi

# Instalar dependencias
echo -e "${BLUE}📦 Instalando dependencias...${NC}"
npm install

# Compilar
echo -e "${BLUE}🔨 Compilando...${NC}"
npm run build

# Crear enlace simbólico global
if [ -f "aidesing-claw.mjs" ]; then
    chmod +x aidesing-claw.mjs
    ln -sf ${INSTALL_DIR}/aidesing-claw-core/aidesing-claw.mjs /usr/local/bin/aidesing-claw
    echo -e "${GREEN}✅ Comando 'aidesing-claw' disponible globalmente${NC}"
fi

# Configuración inicial
echo ""
echo -e "${BLUE}⚙️  Configuración inicial...${NC}"

# Crear directorio de configuración
mkdir -p ${HOME}/.aidesing-claw/config

# Configuración por defecto
cat > ${HOME}/.aidesing-claw/config/default.json << 'EOF'
{
  "branding": {
    "name": "AIDESING Claw",
    "company": "AIDESING SMART SOLUTIONS LLC",
    "email": "aidesingsmartsolutions@gmail.com",
    "website": "https://aidesing.ai.com"
  },
  "gateway": {
    "port": 8080,
    "host": "0.0.0.0"
  },
  "plans": {
    "starter": {
      "name": "Starter",
      "price": 99,
      "agents": 1,
      "channels": ["telegram"]
    },
    "business": {
      "name": "Business",
      "price": 299,
      "agents": 3,
      "channels": ["telegram", "whatsapp"]
    },
    "enterprise": {
      "name": "Enterprise",
      "price": 799,
      "agents": -1,
      "channels": ["telegram", "whatsapp", "discord", "slack"]
    }
  }
}
EOF

echo -e "${GREEN}✅ Configuración creada${NC}"

# Mensaje final
echo ""
echo -e "${GREEN}🎉 AIDESING Claw instalado exitosamente!${NC}"
echo ""
echo "📚 Comandos útiles:"
echo "  aidesing-claw --help          Ver ayuda"
echo "  aidesing-claw --version       Ver versión"
echo "  aidesing-claw gateway         Iniciar gateway"
echo ""
echo "🌐 Panel web: http://localhost:8080"
echo ""
echo "📖 Documentación: https://docs.aidesing.ai"
echo ""
echo -e "${YELLOW}💡 Próximo paso: Configura tu primer agente con:${NC}"
echo "  aidesing-claw agent create"
echo ""
