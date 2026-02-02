#!/usr/bin/env python3
"""
API REST para encurtamento de URLs com Redis
"""

from flask import Flask, request, jsonify, redirect
from redis_demo import URLShortener
import os

app = Flask(__name__)

# Configuração do Redis a partir de variáveis de ambiente
REDIS_HOST = os.environ.get('REDIS_HOST', 'localhost')
REDIS_PORT = int(os.environ.get('REDIS_PORT', 6379))

shortener = URLShortener(redis_host=REDIS_HOST, redis_port=REDIS_PORT)

# Configurações
BASE_URL = os.environ.get('BASE_URL', 'http://localhost:5000')


@app.route('/')
def index():
    """Página inicial com documentação da API"""
    return jsonify({
        'service': 'URL Shortener API',
        'version': '1.0.0',
        'endpoints': {
            'POST /api/shorten': 'Criar URL encurtada',
            'GET /<short_code>': 'Redirecionar para URL original',
            'GET /api/urls/<short_code>': 'Obter informações da URL',
            'GET /api/urls/<short_code>/stats': 'Obter estatísticas da URL',
            'GET /api/top': 'Listar URLs mais populares',
            'GET /api/recent': 'Listar URLs mais recentes',
            'GET /api/users/<user_id>/urls': 'Listar URLs de um usuário',
            'PATCH /api/urls/<short_code>': 'Atualizar URL (desativar)',
            'DELETE /api/urls/<short_code>': 'Deletar URL',
            'GET /api/stats': 'Estatísticas gerais do sistema'
        },
        'documentation': f'{BASE_URL}/docs'
    })


@app.route('/docs')
def docs():
    """Documentação detalhada da API"""
    return '''
    <!DOCTYPE html>
    <html>
    <head>
        <title>URL Shortener API - Documentação</title>
        <style>
            body { font-family: Arial, sans-serif; max-width: 900px; margin: 40px auto; padding: 20px; }
            h1 { color: #333; }
            h2 { color: #666; margin-top: 30px; }
            .endpoint { background: #f5f5f5; padding: 15px; margin: 10px 0; border-radius: 5px; }
            .method { display: inline-block; padding: 3px 8px; border-radius: 3px; font-weight: bold; }
            .post { background: #49cc90; color: white; }
            .get { background: #61affe; color: white; }
            .patch { background: #fca130; color: white; }
            .delete { background: #f93e3e; color: white; }
            code { background: #eee; padding: 2px 6px; border-radius: 3px; }
            pre { background: #2d2d2d; color: #f8f8f2; padding: 15px; border-radius: 5px; overflow-x: auto; }
        </style>
    </head>
    <body>
        <h1>📎 URL Shortener API - Documentação</h1>
        <p>API REST para encurtamento de URLs usando Redis como banco de dados.</p>
        
        <h2>Endpoints</h2>
        
        <div class="endpoint">
            <span class="method post">POST</span> <code>/api/shorten</code>
            <p>Cria uma URL encurtada.</p>
            <pre>{
  "url": "https://www.exemplo.com/pagina/longa",
  "user_id": "user123"  // opcional
}</pre>
            <p><strong>Resposta:</strong></p>
            <pre>{
  "short_code": "1",
  "short_url": "http://localhost:5000/1",
  "original_url": "https://www.exemplo.com/pagina/longa",
  "created_at": "2026-01-24T10:30:00"
}</pre>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span> <code>/{short_code}</code>
            <p>Redireciona para a URL original (HTTP 301).</p>
            <p><strong>Exemplo:</strong> <code>GET /1</code> → Redireciona para URL original</p>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span> <code>/api/urls/{short_code}</code>
            <p>Retorna informações da URL sem redirecionar.</p>
            <pre>{
  "short_code": "1",
  "original_url": "https://www.exemplo.com/pagina/longa",
  "created_at": "2026-01-24T10:30:00",
  "is_active": true
}</pre>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span> <code>/api/urls/{short_code}/stats</code>
            <p>Retorna estatísticas detalhadas da URL.</p>
            <pre>{
  "short_code": "1",
  "original_url": "https://www.exemplo.com/pagina/longa",
  "access_count": 42,
  "popularity_rank": 3,
  "is_active": true
}</pre>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span> <code>/api/top?limit=10</code>
            <p>Lista as URLs mais populares.</p>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span> <code>/api/recent?limit=10</code>
            <p>Lista as URLs mais recentes.</p>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span> <code>/api/users/{user_id}/urls</code>
            <p>Lista todas as URLs criadas por um usuário.</p>
        </div>
        
        <div class="endpoint">
            <span class="method patch">PATCH</span> <code>/api/urls/{short_code}</code>
            <p>Desativa uma URL.</p>
            <pre>{ "is_active": false }</pre>
        </div>
        
        <div class="endpoint">
            <span class="method delete">DELETE</span> <code>/api/urls/{short_code}</code>
            <p>Remove completamente uma URL do sistema.</p>
        </div>
        
        <div class="endpoint">
            <span class="method get">GET</span> <code>/api/stats</code>
            <p>Retorna estatísticas gerais do sistema.</p>
            <pre>{
  "total_urls": 156,
  "next_id": 157,
  "redis_keys": 320
}</pre>
        </div>
        
        <h2>Exemplos com cURL</h2>
        
        <h3>Criar URL encurtada</h3>
        <pre>curl -X POST http://localhost:5000/api/shorten \\
  -H "Content-Type: application/json" \\
  -d '{"url": "https://www.google.com", "user_id": "user123"}'</pre>
        
        <h3>Acessar URL (redirecionamento)</h3>
        <pre>curl -L http://localhost:5000/1</pre>
        
        <h3>Obter estatísticas</h3>
        <pre>curl http://localhost:5000/api/urls/1/stats</pre>
        
        <h3>Top URLs</h3>
        <pre>curl http://localhost:5000/api/top?limit=5</pre>
    </body>
    </html>
    '''


@app.route('/api/shorten', methods=['POST'])
def shorten_url():
    """Criar URL encurtada"""
    try:
        data = request.get_json()
        
        if not data or 'url' not in data:
            return jsonify({'error': 'URL é obrigatória'}), 400
        
        original_url = data['url']
        user_id = data.get('user_id')
        
        result = shortener.create_short_url(original_url, user_id)
        result['short_url'] = f"{BASE_URL}/{result['short_code']}"
        
        return jsonify(result), 201
        
    except ValueError as e:
        return jsonify({'error': str(e)}), 400
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


@app.route('/<short_code>')
def redirect_url(short_code):
    """Redirecionar para URL original"""
    try:
        original_url = shortener.get_original_url(short_code, track_access=True)
        return redirect(original_url, code=301)
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


@app.route('/api/urls/<short_code>', methods=['GET'])
def get_url_info(short_code):
    """Obter informações da URL"""
    try:
        stats = shortener.get_url_stats(short_code)
        return jsonify(stats), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


@app.route('/api/urls/<short_code>/stats', methods=['GET'])
def get_url_stats_endpoint(short_code):
    """Obter estatísticas da URL"""
    try:
        stats = shortener.get_url_stats(short_code)
        return jsonify(stats), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


@app.route('/api/top', methods=['GET'])
def get_top_urls():
    """Listar URLs mais populares"""
    try:
        limit = int(request.args.get('limit', 10))
        top_urls = shortener.get_top_urls(limit)
        
        result = []
        for code, count in top_urls:
            stats = shortener.get_url_stats(code)
            result.append({
                'short_code': code,
                'short_url': f"{BASE_URL}/{code}",
                'original_url': stats['original_url'],
                'access_count': count
            })
        
        return jsonify({'top_urls': result}), 200
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


@app.route('/api/recent', methods=['GET'])
def get_recent_urls():
    """Listar URLs mais recentes"""
    try:
        limit = int(request.args.get('limit', 10))
        recent_codes = shortener.get_recent_urls(limit)
        
        result = []
        for code in recent_codes:
            stats = shortener.get_url_stats(code)
            result.append({
                'short_code': code,
                'short_url': f"{BASE_URL}/{code}",
                'original_url': stats['original_url'],
                'created_at': stats['created_at']
            })
        
        return jsonify({'recent_urls': result}), 200
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


@app.route('/api/users/<user_id>/urls', methods=['GET'])
def get_user_urls(user_id):
    """Listar URLs de um usuário"""
    try:
        user_codes = shortener.get_user_urls(user_id)
        
        result = []
        for code in user_codes:
            stats = shortener.get_url_stats(code)
            result.append({
                'short_code': code,
                'short_url': f"{BASE_URL}/{code}",
                'original_url': stats['original_url'],
                'access_count': stats['access_count']
            })
        
        return jsonify({'user_id': user_id, 'urls': result, 'total': len(result)}), 200
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


@app.route('/api/urls/<short_code>', methods=['PATCH'])
def update_url(short_code):
    """Atualizar URL (desativar)"""
    try:
        data = request.get_json()
        
        if 'is_active' in data and not data['is_active']:
            shortener.deactivate_url(short_code)
            return jsonify({'message': 'URL desativada com sucesso'}), 200
        
        return jsonify({'error': 'Operação não suportada'}), 400
        
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


@app.route('/api/urls/<short_code>', methods=['DELETE'])
def delete_url(short_code):
    """Deletar URL"""
    try:
        shortener.delete_url(short_code)
        return jsonify({'message': 'URL removida com sucesso'}), 200
    except ValueError as e:
        return jsonify({'error': str(e)}), 404
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


@app.route('/api/stats', methods=['GET'])
def get_system_stats():
    """Estatísticas gerais do sistema"""
    try:
        stats = shortener.get_stats()
        return jsonify(stats), 200
    except Exception as e:
        return jsonify({'error': f'Erro interno: {str(e)}'}), 500


if __name__ == '__main__':
    print("=" * 60)
    print("  API REST - Encurtador de URLs")
    print("=" * 60)
    print(f"\n  URL Base: {BASE_URL}")
    print(f"  Documentação: {BASE_URL}/docs")
    print("\n" + "=" * 60 + "\n")
    
    app.run(host='0.0.0.0', port=5000, debug=True)
