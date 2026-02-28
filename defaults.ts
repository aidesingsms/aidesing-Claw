// Defaults for agent metadata when upstream does not supply them.
// AIDESING Claw - Usando Ollama local por defecto
export const DEFAULT_PROVIDER = "ollama";
export const DEFAULT_MODEL = "qwen2.5:0.5b";
// Conservative fallback used when model metadata is unavailable.
export const DEFAULT_CONTEXT_TOKENS = 200_000;
