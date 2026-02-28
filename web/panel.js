/**
 * AIDESING Claw Web Panel
 * Panel de administración integrado en el Gateway
 */

import express from 'express';
import path from 'path';
import { fileURLToPath } from 'url';
import { AgentManager } from './agent-manager.js';
import { ConfigManager } from './config-manager.js';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export class WebPanel {
  constructor(gateway) {
    this.app = express();
    this.gateway = gateway;
    this.agentManager = new AgentManager(gateway);
    this.configManager = new ConfigManager();
    this.port = process.env.AIDESING_WEB_PORT || 3000;
    
    this.setupMiddleware();
    this.setupRoutes();
  }

  setupMiddleware() {
    this.app.use(express.json());
    this.app.use(express.static(path.join(__dirname, 'static')));
    this.app.set('view engine', 'ejs');
    this.app.set('views', path.join(__dirname, 'templates'));
  }

  setupRoutes() {
    // Health check
    this.app.get('/health', (req, res) => {
      res.json({
        status: 'ok',
        version: '1.0.0',
        branding: 'AIDESING Claw',
        timestamp: new Date().toISOString()
      });
    });

    // Dashboard
    this.app.get('/', (req, res) => {
      res.render('dashboard', {
        title: 'AIDESING Claw - Dashboard',
        company: 'AIDESING SMART SOLUTIONS LLC',
        agents: this.agentManager.getAgents(),
        stats: this.getStats()
      });
    });

    // API - Listar agentes
    this.app.get('/api/agents', async (req, res) => {
      try {
        const agents = await this.agentManager.getAgents();
        res.json({ success: true, agents });
      } catch (error) {
        res.status(500).json({ success: false, error: error.message });
      }
    });

    // API - Crear agente
    this.app.post('/api/agents', async (req, res) => {
      try {
        const { name, channel, config } = req.body;
        const agent = await this.agentManager.createAgent({
          name,
          channel,
          config,
          createdAt: new Date().toISOString()
        });
        res.json({ success: true, agent });
      } catch (error) {
        res.status(500).json({ success: false, error: error.message });
      }
    });

    // API - Iniciar/Detener agente
    this.app.post('/api/agents/:id/:action', async (req, res) => {
      try {
        const { id, action } = req.params;
        if (action === 'start') {
          await this.agentManager.startAgent(id);
        } else if (action === 'stop') {
          await this.agentManager.stopAgent(id);
        }
        res.json({ success: true });
      } catch (error) {
        res.status(500).json({ success: false, error: error.message });
      }
    });

    // API - Configuración
    this.app.get('/api/config', (req, res) => {
      res.json({
        branding: {
          name: 'AIDESING Claw',
          company: 'AIDESING SMART SOLUTIONS LLC',
          email: 'aidesingsmartsolutions@gmail.com',
          website: 'https://aidesing.ai.com'
        },
        plans: {
          starter: { name: 'Starter', agents: 1, channels: ['telegram'] },
          business: { name: 'Business', agents: 3, channels: ['telegram', 'whatsapp'] },
          enterprise: { name: 'Enterprise', agents: -1, channels: ['all'] }
        }
      });
    });
  }

  getStats() {
    return {
      totalAgents: this.agentManager.getAgentCount(),
      activeAgents: this.agentManager.getActiveAgentCount(),
      totalMessages: 0,
      uptime: process.uptime()
    };
  }

  start() {
    return new Promise((resolve) => {
      this.server = this.app.listen(this.port, () => {
        console.log(`🌐 AIDESING Claw Web Panel running on http://localhost:${this.port}`);
        resolve();
      });
    });
  }

  stop() {
    if (this.server) {
      this.server.close();
    }
  }
}

// Clases placeholder (se implementarán completamente después)
class AgentManager {
  constructor(gateway) {
    this.gateway = gateway;
    this.agents = new Map();
  }

  async getAgents() {
    return Array.from(this.agents.values());
  }

  getAgentCount() {
    return this.agents.size;
  }

  getActiveAgentCount() {
    return Array.from(this.agents.values()).filter(a => a.status === 'running').length;
  }

  async createAgent(config) {
    const id = `agent-${Date.now()}`;
    const agent = { id, ...config, status: 'stopped' };
    this.agents.set(id, agent);
    return agent;
  }

  async startAgent(id) {
    const agent = this.agents.get(id);
    if (agent) {
      agent.status = 'running';
    }
  }

  async stopAgent(id) {
    const agent = this.agents.get(id);
    if (agent) {
      agent.status = 'stopped';
    }
  }
}

class ConfigManager {
  getConfig() {
    return {
      branding: {
        name: 'AIDESING Claw',
        company: 'AIDESING SMART SOLUTIONS LLC'
      }
    };
  }
}
