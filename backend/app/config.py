"""
Application configuration using Pydantic Settings.
"""
from typing import List, Optional
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables."""

    # Application
    APP_NAME: str = "Meal Planner API"
    DEBUG: bool = False
    API_V1_STR: str = "/api/v1"

    # Database
    DATABASE_URL: str = "sqlite:///./meal_planner.db"

    # Security
    SECRET_KEY: str  # Required, no default
    ALGORITHM: str = "HS256"
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 10080  # 7 days
    ENCRYPTION_KEY: str  # Required for API key encryption, no default

    # OpenAI
    OPENAI_API_KEY: Optional[str] = None  # Default app key
    OPENAI_MODEL: str = "gpt-4o"
    OPENAI_TEMPERATURE: float = 0.7
    OPENAI_MAX_TOKENS: int = 16384
    OPENAI_TIMEOUT: int = 90

    # Rate Limiting
    API_USAGE_LIMIT_PER_MONTH: int = 1000  # For users without own key

    # CORS
    BACKEND_CORS_ORIGINS: List[str] = ["*"]

    class Config:
        env_file = ".env"
        case_sensitive = True

        @staticmethod
        def parse_env_var(field_name: str, raw_val: str):
            """Parse environment variables, especially lists."""
            if field_name == "BACKEND_CORS_ORIGINS":
                return [origin.strip() for origin in raw_val.split(",")]
            return raw_val


# Global settings instance
settings = Settings()
