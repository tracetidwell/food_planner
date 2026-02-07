"""
Tests for authentication endpoints.
"""
import pytest
from fastapi.testclient import TestClient


def test_register_success(client: TestClient):
    """Test successful user registration."""
    response = client.post(
        "/api/v1/auth/register",
        json={"email": "newuser@example.com", "password": "securepass123"},
    )
    assert response.status_code == 201
    data = response.json()
    assert data["email"] == "newuser@example.com"
    assert "id" in data
    assert "hashed_password" not in data  # Should not expose password


def test_register_duplicate_email(client: TestClient, test_user):
    """Test registration with duplicate email fails."""
    response = client.post(
        "/api/v1/auth/register",
        json={"email": "test@example.com", "password": "anotherpass123"},
    )
    assert response.status_code == 400
    assert "already registered" in response.json()["detail"].lower()


def test_register_short_password(client: TestClient):
    """Test registration with short password fails."""
    response = client.post(
        "/api/v1/auth/register",
        json={"email": "newuser@example.com", "password": "short"},
    )
    assert response.status_code == 422  # Validation error


def test_login_success(client: TestClient, test_user):
    """Test successful login."""
    response = client.post(
        "/api/v1/auth/login",
        json={"email": "test@example.com", "password": "testpassword123"},
    )
    assert response.status_code == 200
    data = response.json()
    assert "access_token" in data
    assert data["token_type"] == "bearer"


def test_login_wrong_password(client: TestClient, test_user):
    """Test login with wrong password fails."""
    response = client.post(
        "/api/v1/auth/login",
        json={"email": "test@example.com", "password": "wrongpassword"},
    )
    assert response.status_code == 401
    assert "incorrect" in response.json()["detail"].lower()


def test_login_nonexistent_user(client: TestClient):
    """Test login with nonexistent user fails."""
    response = client.post(
        "/api/v1/auth/login",
        json={"email": "nonexistent@example.com", "password": "password123"},
    )
    assert response.status_code == 401


def test_get_current_user_success(client: TestClient, auth_headers):
    """Test getting current user info with valid token."""
    response = client.get("/api/v1/auth/me", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["email"] == "test@example.com"
    assert "id" in data


def test_get_current_user_no_token(client: TestClient):
    """Test getting current user without token fails."""
    response = client.get("/api/v1/auth/me")
    assert response.status_code == 403  # No auth header


def test_get_current_user_invalid_token(client: TestClient):
    """Test getting current user with invalid token fails."""
    response = client.get(
        "/api/v1/auth/me", headers={"Authorization": "Bearer invalidtoken"}
    )
    assert response.status_code == 401
