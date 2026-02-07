"""
Tests for profile endpoints.
"""
import pytest
from fastapi.testclient import TestClient


def test_get_profile(client: TestClient, auth_headers, test_user):
    """Test getting user profile."""
    response = client.get("/api/v1/profile", headers=auth_headers)
    assert response.status_code == 200
    data = response.json()
    assert data["user_id"] == test_user.id
    assert data["meals_per_day"] == 3
    assert data["snacks_per_day"] == 2
    assert data["has_custom_api_key"] == False


def test_update_profile(client: TestClient, auth_headers):
    """Test updating user profile."""
    response = client.put(
        "/api/v1/profile",
        headers=auth_headers,
        json={
            "food_preferences": "I like chicken and rice, avoid dairy",
            "meals_per_day": 4,
            "snacks_per_day": 1,
        },
    )
    assert response.status_code == 200
    data = response.json()
    assert data["food_preferences"] == "I like chicken and rice, avoid dairy"
    assert data["meals_per_day"] == 4
    assert data["snacks_per_day"] == 1


def test_update_profile_partial(client: TestClient, auth_headers):
    """Test partial profile update."""
    response = client.put(
        "/api/v1/profile",
        headers=auth_headers,
        json={"meals_per_day": 5},
    )
    assert response.status_code == 200
    data = response.json()
    assert data["meals_per_day"] == 5
    assert data["snacks_per_day"] == 2  # Unchanged


def test_update_profile_invalid_meals(client: TestClient, auth_headers):
    """Test updating profile with invalid meal count."""
    response = client.put(
        "/api/v1/profile",
        headers=auth_headers,
        json={"meals_per_day": 10},  # Too many
    )
    assert response.status_code == 422


def test_set_api_key(client: TestClient, auth_headers):
    """Test setting user's OpenAI API key."""
    response = client.post(
        "/api/v1/profile/api-key",
        headers=auth_headers,
        json={"api_key": "sk-test1234567890abcdefghijklmnop"},
    )
    assert response.status_code == 204

    # Verify it's set (but not exposed)
    profile_response = client.get("/api/v1/profile", headers=auth_headers)
    assert profile_response.json()["has_custom_api_key"] == True


def test_delete_api_key(client: TestClient, auth_headers):
    """Test deleting user's OpenAI API key."""
    # First set a key
    client.post(
        "/api/v1/profile/api-key",
        headers=auth_headers,
        json={"api_key": "sk-test1234567890abcdefghijklmnop"},
    )

    # Then delete it
    response = client.delete("/api/v1/profile/api-key", headers=auth_headers)
    assert response.status_code == 204

    # Verify it's removed
    profile_response = client.get("/api/v1/profile", headers=auth_headers)
    assert profile_response.json()["has_custom_api_key"] == False


def test_profile_unauthorized(client: TestClient):
    """Test accessing profile without authentication."""
    response = client.get("/api/v1/profile")
    assert response.status_code == 403
