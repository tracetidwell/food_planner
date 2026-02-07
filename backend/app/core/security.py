"""
Security utilities for authentication and encryption.
"""
from datetime import datetime, timedelta
from typing import Optional
import base64
import os

from jose import JWTError, jwt
from passlib.context import CryptContext
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

from app.config import settings


# Password hashing context
pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")


def hash_password(password: str) -> str:
    """Hash a password using bcrypt."""
    return pwd_context.hash(password)


def verify_password(plain_password: str, hashed_password: str) -> bool:
    """Verify a password against a hash."""
    return pwd_context.verify(plain_password, hashed_password)


def create_access_token(data: dict, expires_delta: Optional[timedelta] = None) -> str:
    """Create a JWT access token."""
    to_encode = data.copy()

    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(
            minutes=settings.ACCESS_TOKEN_EXPIRE_MINUTES
        )

    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, settings.SECRET_KEY, algorithm=settings.ALGORITHM)
    return encoded_jwt


def verify_token(token: str) -> Optional[dict]:
    """Verify and decode a JWT token."""
    try:
        payload = jwt.decode(token, settings.SECRET_KEY, algorithms=[settings.ALGORITHM])
        return payload
    except JWTError:
        return None


def derive_encryption_key(master_key: str, salt: bytes) -> bytes:
    """Derive an encryption key from master key using PBKDF2."""
    kdf = PBKDF2HMAC(
        algorithm=hashes.SHA256(),
        length=32,
        salt=salt,
        iterations=100000,
        backend=default_backend(),
    )
    return kdf.derive(master_key.encode())


def encrypt_api_key(api_key: str) -> str:
    """Encrypt an API key using AES-256-GCM."""
    # Generate a random salt and nonce
    salt = os.urandom(16)
    nonce = os.urandom(12)

    # Derive encryption key from master key
    key = derive_encryption_key(settings.ENCRYPTION_KEY, salt)

    # Encrypt the API key
    aesgcm = AESGCM(key)
    ciphertext = aesgcm.encrypt(nonce, api_key.encode(), None)

    # Combine salt + nonce + ciphertext and encode as base64
    encrypted_data = salt + nonce + ciphertext
    return base64.b64encode(encrypted_data).decode()


def decrypt_api_key(encrypted_api_key: str) -> str:
    """Decrypt an API key."""
    # Decode from base64
    encrypted_data = base64.b64decode(encrypted_api_key.encode())

    # Extract salt, nonce, and ciphertext
    salt = encrypted_data[:16]
    nonce = encrypted_data[16:28]
    ciphertext = encrypted_data[28:]

    # Derive encryption key from master key
    key = derive_encryption_key(settings.ENCRYPTION_KEY, salt)

    # Decrypt the API key
    aesgcm = AESGCM(key)
    plaintext = aesgcm.decrypt(nonce, ciphertext, None)

    return plaintext.decode()
