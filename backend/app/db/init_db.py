"""
Database initialization utilities.
"""
from app.db.base import Base
from app.db.session import engine


def init_db():
    """Create all database tables."""
    Base.metadata.create_all(bind=engine)


def drop_db():
    """Drop all database tables."""
    Base.metadata.drop_all(bind=engine)


if __name__ == "__main__":
    init_db()
    print("Database initialized successfully!")
