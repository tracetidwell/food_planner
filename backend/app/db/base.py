"""
SQLAlchemy declarative base and model imports.

Import all models here so Alembic can auto-detect them for migrations.
"""
from sqlalchemy.ext.declarative import declarative_base

# Create declarative base
Base = declarative_base()

# Import all models here for Alembic auto-detection
from app.models.user import User, UserProfile
from app.models.goal import NutritionGoal
from app.models.meal_plan import MealPlan, PlannedMeal
from app.models.log import MealLog
from app.models.grocery import GroceryList
