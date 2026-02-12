#!/usr/bin/env python3
"""
Demonstração interativa do sistema de encurtamento de URLs com Redis
"""

import redis
from datetime import datetime
from utils import encode_base62, validate_url


class URLShortener:
    """Classe para gerenciar encurtamento de URLs com Redis"""
    
    def __init__(self, redis_host='localhost', redis_port=6379):
        """Inicializa conexão com Redis"""
        self.redis = redis.Redis(
            host=redis_host,
            port=redis_port,
            decode_responses=True
        )
        print(f"✓ Conectado ao Redis em {redis_host}:{redis_port}")
    
    def create_short_url(self, original_url: str, user_id: str = None) -> dict:
        """
        Cria uma URL encurtada
        
        Args:
            original_url: URL original completa
            user_id: ID do usuário (opcional)
            
        Returns:
            Dicionário com informações da URL criada
        """
        # 1. Validar URL
        if not validate_url(original_url):
            raise ValueError("URL inválida")
        
        # 2. Gerar ID único e converter para Base62
        url_id = self.redis.incr('counter:url_id')
        short_code = encode_base62(url_id)
        
        # 3. Verificar colisão (improvável, mas seguro)
        if self.redis.exists(f'url:{short_code}'):
            raise Exception(f"Colisão detectada: {short_code} já existe")
        
        # 4. Preparar dados
        timestamp = datetime.now().isoformat()
        url_data = {
            'original_url': original_url,
            'created_at': timestamp,
            'access_count': '0',
            'is_active': '1'
        }
        
        if user_id:
            url_data['user_id'] = user_id
        
        # 5. Armazenar no Redis (Hash)
        self.redis.hset(f'url:{short_code}', mapping=url_data)
        
        # 6. Adicionar aos índices
        timestamp_unix = int(datetime.now().timestamp())
        self.redis.zadd('urls:by_date', {short_code: timestamp_unix})
        self.redis.zadd('urls:by_popularity', {short_code: 0})
        
        if user_id:
            self.redis.sadd(f'user:{user_id}:urls', short_code)
        
        print(f"✓ URL criada: {short_code}")
        return {
            'short_code': short_code,
            'short_url': f'https://tiny.url/{short_code}',
            'original_url': original_url,
            'created_at': timestamp
        }
    
    def get_original_url(self, short_code: str, track_access: bool = True) -> str:
        """
        Recupera a URL original a partir do código curto
        
        Args:
            short_code: Código curto da URL
            track_access: Se deve registrar o acesso
            
        Returns:
            URL original
        """
        # 1. Buscar URL original
        original_url = self.redis.hget(f'url:{short_code}', 'original_url')
        
        if not original_url:
            raise ValueError(f"URL não encontrada: {short_code}")
        
        # 2. Verificar se está ativa
        is_active = self.redis.hget(f'url:{short_code}', 'is_active')
        if is_active != '1':
            raise ValueError(f"URL inativa: {short_code}")
        
        # 3. Registrar acesso (se solicitado)
        if track_access:
            # Incrementar contador
            new_count = self.redis.hincrby(f'url:{short_code}', 'access_count', 1)
            # Atualizar índice de popularidade
            self.redis.zincrby('urls:by_popularity', 1, short_code)
            print(f"✓ Acesso registrado (total: {new_count})")
        
        return original_url
    
    def get_url_stats(self, short_code: str) -> dict:
        """
        Obtém estatísticas de uma URL
        
        Args:
            short_code: Código curto da URL
            
        Returns:
            Dicionário com estatísticas
        """
        url_data = self.redis.hgetall(f'url:{short_code}')
        
        if not url_data:
            raise ValueError(f"URL não encontrada: {short_code}")
        
        # Obter posição no ranking de popularidade
        rank = self.redis.zrevrank('urls:by_popularity', short_code)
        
        return {
            'short_code': short_code,
            'original_url': url_data.get('original_url'),
            'created_at': url_data.get('created_at'),
            'access_count': int(url_data.get('access_count', 0)),
            'is_active': url_data.get('is_active') == '1',
            'popularity_rank': rank + 1 if rank is not None else None
        }
    
    def get_top_urls(self, limit: int = 10) -> list:
        """
        Retorna as URLs mais populares
        
        Args:
            limit: Número máximo de URLs a retornar
            
        Returns:
            Lista de tuplas (short_code, access_count)
        """
        top_urls = self.redis.zrevrange('urls:by_popularity', 0, limit - 1, withscores=True)
        return [(code, int(score)) for code, score in top_urls]
    
    def get_recent_urls(self, limit: int = 10) -> list:
        """
        Retorna as URLs mais recentes
        
        Args:
            limit: Número máximo de URLs a retornar
            
        Returns:
            Lista de short_codes
        """
        recent_urls = self.redis.zrevrange('urls:by_date', 0, limit - 1)
        return recent_urls
    
    def get_user_urls(self, user_id: str) -> list:
        """
        Retorna todas as URLs criadas por um usuário
        
        Args:
            user_id: ID do usuário
            
        Returns:
            Lista de short_codes
        """
        return list(self.redis.smembers(f'user:{user_id}:urls'))
    
    def deactivate_url(self, short_code: str) -> bool:
        """
        Desativa uma URL
        
        Args:
            short_code: Código curto da URL
            
        Returns:
            True se desativada com sucesso
        """
        if not self.redis.exists(f'url:{short_code}'):
            raise ValueError(f"URL não encontrada: {short_code}")
        
        self.redis.hset(f'url:{short_code}', 'is_active', '0')
        print(f"✓ URL desativada: {short_code}")
        return True
    
    def delete_url(self, short_code: str) -> bool:
        """
        Remove completamente uma URL
        
        Args:
            short_code: Código curto da URL
            
        Returns:
            True se removida com sucesso
        """
        if not self.redis.exists(f'url:{short_code}'):
            raise ValueError(f"URL não encontrada: {short_code}")
        
        # Obter user_id antes de deletar
        user_id = self.redis.hget(f'url:{short_code}', 'user_id')
        
        # Remover hash principal
        self.redis.delete(f'url:{short_code}')
        
        # Remover dos índices
        self.redis.zrem('urls:by_date', short_code)
        self.redis.zrem('urls:by_popularity', short_code)
        
        if user_id:
            self.redis.srem(f'user:{user_id}:urls', short_code)
        
        print(f"✓ URL removida: {short_code}")
        return True
    
    def get_stats(self) -> dict:
        """
        Retorna estatísticas gerais do sistema
        
        Returns:
            Dicionário com estatísticas
        """
        total_urls = self.redis.zcard('urls:by_date')
        counter_value = self.redis.get('counter:url_id') or 0
        
        return {
            'total_urls': total_urls,
            'next_id': int(counter_value) + 1,
            'redis_keys': self.redis.dbsize()
        }


def demo_interactive():
    """Demonstração interativa"""
    print("=" * 60)
    print("  LABORATÓRIO: Encurtador de URLs com Redis")
    print("=" * 60)
    print()
    
    shortener = URLShortener()
    
    print("\n--- 1. Criando URLs encurtadas ---\n")
    
    urls_to_shorten = [
        ("https://www.meusite.com.br/blog/categoria/ano/mes/dia/um-titulo-de-um-post-bem-extenso", "user123"),
        ("https://www.google.com/search?q=redis+database", "user123"),
        ("https://github.com/redis/redis", "user456"),
        ("https://www.youtube.com/watch?v=dQw4w9WgXcQ", "user789"),
        ("https://stackoverflow.com/questions/tagged/redis", "user123"),
    ]
    
    created_codes = []
    for url, user in urls_to_shorten:
        result = shortener.create_short_url(url, user)
        created_codes.append(result['short_code'])
        print(f"  {result['short_code']} -> {url[:60]}...")
    
    print("\n--- 2. Simulando acessos (redirecionamentos) ---\n")
    
    # Simular acessos variados
    access_pattern = [
        (created_codes[0], 15),  # Primeira URL: 15 acessos
        (created_codes[1], 8),   # Segunda URL: 8 acessos
        (created_codes[2], 23),  # Terceira URL: 23 acessos (mais popular)
        (created_codes[3], 3),   # Quarta URL: 3 acessos
        (created_codes[4], 12),  # Quinta URL: 12 acessos
    ]
    
    for code, count in access_pattern:
        for i in range(count):
            shortener.get_original_url(code, track_access=True)
        print(f"  {code}: {count} acessos simulados")
    
    print("\n--- 3. Top URLs mais populares ---\n")
    
    top_urls = shortener.get_top_urls(5)
    for i, (code, count) in enumerate(top_urls, 1):
        stats = shortener.get_url_stats(code)
        print(f"  #{i} {code} - {count} acessos")
        print(f"      {stats['original_url'][:70]}...")
    
    print("\n--- 4. URLs criadas pelo user123 ---\n")
    
    user_urls = shortener.get_user_urls('user123')
    print(f"  Total: {len(user_urls)} URLs")
    for code in user_urls:
        stats = shortener.get_url_stats(code)
        print(f"  - {code}: {stats['access_count']} acessos")
    
    print("\n--- 5. Estatísticas do sistema ---\n")
    
    system_stats = shortener.get_stats()
    print(f"  Total de URLs: {system_stats['total_urls']}")
    print(f"  Próximo ID: {system_stats['next_id']}")
    print(f"  Chaves no Redis: {system_stats['redis_keys']}")
    
    print("\n--- 6. Desativando uma URL ---\n")
    
    code_to_deactivate = created_codes[3]
    shortener.deactivate_url(code_to_deactivate)
    
    try:
        shortener.get_original_url(code_to_deactivate)
    except ValueError as e:
        print(f"  ✓ Erro esperado ao acessar URL inativa: {e}")
    
    print("\n" + "=" * 60)
    print("  Demonstração concluída!")
    print("=" * 60)
    print("\nPara explorar mais, use o script interativo ou a API REST.")


if __name__ == "__main__":
    demo_interactive()
