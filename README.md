# 🦞 AIDESING Claw

Panel de control plug-and-play para agentes de IA empresariales.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Python 3.8+](https://img.shields.io/badge/python-3.8+-blue.svg)](https://www.python.org/downloads/)
[![Flask](https://img.shields.io/badge/flask-3.0-green.svg)](https://flask.palletsprojects.com/)

## 🎯 Descripción

AIDESING Claw permite a empresas crear y gestionar agentes de IA en minutos, sin configuración técnica compleja.

### Características principales

- ✅ **Setup en 1 click** - Crea agentes sin configuración manual
- ✅ **Canales múltiples** - Telegram, WhatsApp (próximamente)
- ✅ **IA local** - Ollama integrado para privacidad y control
- ✅ **Panel web intuitivo** - Gestión visual de todos tus agentes
- ✅ **White-label** - Personalizable para revendedores

## 🚀 Instalación rápida

```bash
# Clonar repositorio
git clone https://github.com/aidesing/aidesing-claw.git
cd aidesing-claw

# Instalar dependencias
pip install -r requirements.txt

# Iniciar
python app.py
```

Accede a: http://localhost:5000

**Login default:** admin / admin

## 📋 Requisitos

- Python 3.8+
- Ollama (para IA local)
- Nginx (para producción)

## 🏗️ Arquitectura

```
Usuario → Panel Web → Agentes OpenClaw → Canales (Telegram/WhatsApp)
                ↓
            Ollama (IA local)
```

## 📖 Documentación

- [Guía de deploy](DEPLOY_GUIDE.md) - Instalación en servidor
- [API Reference](docs/API.md) - Documentación de API
- [Contribuir](CONTRIBUTING.md) - Guía para contribuidores

## 💰 Modelo de negocio

| Plan | Precio | Agentes | Canales |
|------|--------|---------|---------|
| Starter | $99/mes | 1 | Telegram |
| Business | $299/mes | 3 | Telegram + WhatsApp |
| Enterprise | $799/mes | Ilimitados | Todos |

## 🤝 Contribuir

Las contribuciones son bienvenidas. Por favor lee [CONTRIBUTING.md](CONTRIBUTING.md) para más detalles.

## 📄 Licencia

Este proyecto está licenciado bajo MIT - ver [LICENSE](LICENSE) para más detalles.

## 🏢 Sobre AIDESING

AIDESING SMART SOLUTIONS LLC - Especialistas en soluciones de IA para empresas.

- 🌐 [aidesing.ai.com](https://aidesing.ai.com)
- 📧 aidesingai@gmail.com
- 📍 Tampa, Florida

---

**Desarrollado con ❤️ por el equipo de AIDESING**
