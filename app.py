#!/usr/bin/env python3
"""
AIDESING Claw - Panel Web
Gestión de agentes IA plug-and-play
"""

import os
import json
import subprocess
import hashlib
from datetime import datetime
from functools import wraps
from flask import Flask, render_template, request, jsonify, session, redirect, url_for

app = Flask(__name__)
app.secret_key = os.urandom(24)

# Configuración
CONFIG_DIR = os.path.expanduser("~/.aidesing-claw")
AGENTS_DIR = os.path.join(CONFIG_DIR, "agents")
CONFIG_FILE = os.path.join(CONFIG_DIR, "config.json")

os.makedirs(AGENTS_DIR, exist_ok=True)

def init_config():
    if not os.path.exists(CONFIG_FILE):
        default_config = {
            "version": "1.0.0",
            "gateway": {"host": "0.0.0.0", "port": 8080},
            "ollama": {"url": "http://localhost:11434", "default_model": "qwen2.5:0.5b"},
            "admin": {"username": "admin", "password_hash": hashlib.sha256("admin".encode()).hexdigest()},
            "agents": []
        }
        with open(CONFIG_FILE, 'w') as f:
            json.dump(default_config, f, indent=2)

def load_config():
    init_config()
    with open(CONFIG_FILE) as f:
        return json.load(f)

@app.route("/")
def index():
    if 'logged_in' not in session:
        return redirect(url_for('login'))
    return render_template("index.html")

@app.route("/login", methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form.get('username')
        password = request.form.get('password')
        config = load_config()
        password_hash = hashlib.sha256(password.encode()).hexdigest()
        if username == config['admin']['username'] and password_hash == config['admin']['password_hash']:
            session['logged_in'] = True
            return redirect(url_for('index'))
        return render_template("login.html", error="Credenciales invalidas")
    return render_template("login.html")

@app.route("/api/agents")
def api_agents():
    if 'logged_in' not in session:
        return jsonify({"error": "Unauthorized"}), 401
    
    agents = []
    for agent_id in os.listdir(AGENTS_DIR):
        agent_path = os.path.join(AGENTS_DIR, agent_id)
        config_path = os.path.join(agent_path, "config.json")
        if os.path.isdir(agent_path) and os.path.exists(config_path):
            try:
                with open(config_path) as f:
                    config = json.load(f)
                running = subprocess.run(["pgrep", "-f", f"{agent_id}/agent.py"], capture_output=True).returncode == 0
                agents.append({"id": agent_id, "name": config.get("name", agent_id), "status": "running" if running else "stopped"})
            except:
                pass
    return jsonify({"agents": agents})

@app.route("/api/agent/create", methods=['POST'])
def api_create():
    if 'logged_in' not in session:
        return jsonify({"error": "Unauthorized"}), 401
    
    data = request.json
    agent_id = f"agent-{datetime.now().strftime('%Y%m%d%H%M%S')}"
    agent_dir = os.path.join(AGENTS_DIR, agent_id)
    os.makedirs(agent_dir, exist_ok=True)
    
    config = {
        "id": agent_id,
        "name": data.get('name', 'Nuevo Agente'),
        "telegram_token": data.get('telegram_token', ''),
        "created": datetime.now().isoformat()
    }
    
    with open(os.path.join(agent_dir, "config.json"), 'w') as f:
        json.dump(config, f, indent=2)
    
    return jsonify({"success": True, "agent_id": agent_id})

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=False)
