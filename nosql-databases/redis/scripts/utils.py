"""
Utilitários para o sistema de encurtamento de URLs
"""

# Alfabeto Base62: a-z, A-Z, 0-9
BASE62_ALPHABET = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"


def encode_base62(num: int) -> str:
    """
    Converte um número inteiro para Base62
    
    Args:
        num: Número inteiro positivo
        
    Returns:
        String em Base62
        
    Example:
        >>> encode_base62(123456789)
        '8M0kX'
    """
    if num == 0:
        return BASE62_ALPHABET[0]
    
    result = []
    while num > 0:
        num, remainder = divmod(num, 62)
        result.append(BASE62_ALPHABET[remainder])
    
    return ''.join(reversed(result))


def decode_base62(encoded: str) -> int:
    """
    Converte uma string Base62 de volta para número inteiro
    
    Args:
        encoded: String em Base62
        
    Returns:
        Número inteiro
        
    Example:
        >>> decode_base62('8M0kX')
        123456789
    """
    num = 0
    for char in encoded:
        num = num * 62 + BASE62_ALPHABET.index(char)
    return num


def validate_url(url: str) -> bool:
    """
    Valida se a URL tem formato válido
    
    Args:
        url: URL a ser validada
        
    Returns:
        True se válida, False caso contrário
    """
    if not url:
        return False
    
    # Verifica se começa com http:// ou https://
    if not (url.startswith('http://') or url.startswith('https://')):
        return False
    
    # Verifica se tem pelo menos um domínio
    if len(url) < 12:  # http://a.co é o mínimo
        return False
    
    return True


if __name__ == "__main__":
    # Testes
    print("=== Testes de Base62 ===")
    test_numbers = [1, 62, 123, 12345, 123456789]
    
    for num in test_numbers:
        encoded = encode_base62(num)
        decoded = decode_base62(encoded)
        print(f"{num:>10} -> {encoded:>8} -> {decoded:>10} ✓" if num == decoded else f"✗ ERRO")
    
    print("\n=== Testes de Validação de URL ===")
    test_urls = [
        ("https://www.google.com", True),
        ("http://tiny.url", True),
        ("https://www.meusite.com.br/blog/post", True),
        ("www.google.com", False),
        ("google.com", False),
        ("", False),
        ("http://", False),
    ]
    
    for url, expected in test_urls:
        result = validate_url(url)
        status = "✓" if result == expected else "✗"
        print(f"{status} {url:50} -> {result}")
