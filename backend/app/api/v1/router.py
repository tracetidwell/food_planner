"""
API v1 router aggregation.
"""
from fastapi import APIRouter

from app.api.v1.endpoints import auth, profile, goals, meal_plans, logs, analytics

api_router = APIRouter()

# Include all endpoint routers
api_router.include_router(auth.router, prefix="/auth", tags=["authentication"])
api_router.include_router(profile.router, tags=["profile"])
api_router.include_router(goals.router, tags=["goals"])
api_router.include_router(meal_plans.router, tags=["meal-plans"])
api_router.include_router(logs.router, tags=["logs"])
api_router.include_router(analytics.router, tags=["analytics"])
