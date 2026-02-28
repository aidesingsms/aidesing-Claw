# AIDESING Claw - Modificaciones para Ollama

Este repositorio contiene las modificaciones de AIDESING Claw sobre OpenClaw para soporte nativo de Ollama.

## Cambios Principales

### 1. Provider por Defecto (src/agents/defaults.ts)
- Cambiado de `anthropic` a `ollama`
- Modelo por defecto: `qwen2.5:0.5b`

### 2. Configuración de Providers (src/agents/models-config.providers.ts)
- Ollama ahora se carga automáticamente sin necesidad de API key
- Descubre modelos automáticamente desde `http://localhost:11434`

### 3. Branding (package.json)
- Nombre: `aidesing-claw`
- Versión: `1.0.0`
- Autor: `AIDESING SMART SOLUTIONS LLC`

## Instalación

1. Clonar OpenClaw original
2. Aplicar estos parches
3. Compilar con `pnpm build`
4. Configurar agente con modelo `ollama/qwen2.5:0.5b`

## Uso

```bash
# Crear agente
openclaw agents add mi-agente --non-interactive

# Ejecutar con Ollama
openclaw agent --local --agent mi-agente --message "Hola"
```

## Licencia

Basado en OpenClaw (MIT License)
Modificaciones por AIDESING SMART SOLUTIONS LLC
