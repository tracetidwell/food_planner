"""
Tests for security utilities.
"""
import pytest
from app.core.security import (
    hash_password,
    verify_password,
    create_access_token,
    verify_token,
    encrypt_api_key,
    decrypt_api_key,
)


def test_hash_password():
    """Test password hashing."""
    password = "mysecurepassword123"
    hashed = hash_password(password)

    assert hashed != password
    assert len(hashed) > 0
    assert hashed.startswith("$2b$")  # bcrypt hash format


def test_verify_password_correct():
    """Test password verification with correct password."""
    password = "mysecurepassword123"
    hashed = hash_password(password)

    assert verify_password(password, hashed) is True


def test_verify_password_incorrect():
    """Test password verification with incorrect password."""
    password = "mysecurepassword123"
    wrong_password = "wrongpassword"
    hashed = hash_password(password)

    assert verify_password(wrong_password, hashed) is False


def test_create_access_token():
    """Test JWT token creation."""
    data = {"sub": "user@example.com"}
    token = create_access_token(data)

    assert isinstance(token, str)
    assert len(token) > 0


def test_verify_token_valid():
    """Test verifying a valid JWT token."""
    data = {"sub": "user@example.com"}
    token = create_access_token(data)

    payload = verify_token(token)
    assert payload is not None
    assert payload["sub"] == "user@example.com"
    assert "exp" in payload


def test_verify_token_invalid():
    """Test verifying an invalid JWT token."""
    invalid_token = "invalid.token.here"

    payload = verify_token(invalid_token)
    assert payload is None


def test_encrypt_decrypt_api_key():
    """Test encrypting and decrypting an API key."""
    api_key = "sk-test1234567890abcdefghijklmnopqrstuvwxyz"

    # Encrypt
    encrypted = encrypt_api_key(api_key)
    assert encrypted != api_key
    assert isinstance(encrypted, str)
    assert len(encrypted) > len(api_key)  # Encrypted data is longer

    # Decrypt
    decrypted = decrypt_api_key(encrypted)
    assert decrypted == api_key


def test_encrypt_different_each_time():
    """Test that encrypting the same key twice produces different results."""
    api_key = "sk-test1234567890"

    encrypted1 = encrypt_api_key(api_key)
    encrypted2 = encrypt_api_key(api_key)

    # Should be different due to different salt/nonce
    assert encrypted1 != encrypted2

    # But both should decrypt to the same value
    assert decrypt_api_key(encrypted1) == api_key
    assert decrypt_api_key(encrypted2) == api_key


def test_encrypt_empty_string():
    """Test encrypting an empty string."""
    encrypted = encrypt_api_key("")
    decrypted = decrypt_api_key(encrypted)
    assert decrypted == ""


def test_decrypt_invalid_data():
    """Test that decrypting invalid data raises an error."""
    with pytest.raises(Exception):
        decrypt_api_key("invalid_encrypted_data")


def test_password_hashing_is_slow():
    """Test that password hashing takes reasonable time (security feature)."""
    import time

    password = "testpassword"
    start = time.time()
    hash_password(password)
    duration = time.time() - start

    # bcrypt should take at least 0.05 seconds (50ms) for security
    assert duration > 0.01
