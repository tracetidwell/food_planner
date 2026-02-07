"""
FastAPI main application.
"""
from fastapi import FastAPI, Request, status
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from sqlalchemy.exc import SQLAlchemyError

from app.config import settings
from app.api.v1.router import api_router
from app.core.exceptions import (
    APIKeyLimitExceeded,
    OpenAIAPIError,
    MealPlanNotFound,
    InvalidCredentials,
    ActiveGoalNotFound,
)

# Create FastAPI app
app = FastAPI(
    title=settings.APP_NAME,
    description="Meal planning and nutrition tracking API with OpenAI integration",
    version="1.0.0",
    debug=settings.DEBUG,
)

# Configure CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.BACKEND_CORS_ORIGINS,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


# Exception handlers
@app.exception_handler(APIKeyLimitExceeded)
async def api_key_limit_handler(request: Request, exc: APIKeyLimitExceeded):
    return JSONResponse(
        status_code=status.HTTP_429_TOO_MANY_REQUESTS,
        content={"detail": {"message": str(exc), "code": "API_KEY_LIMIT_EXCEEDED"}},
    )


@app.exception_handler(OpenAIAPIError)
async def openai_error_handler(request: Request, exc: OpenAIAPIError):
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": {"message": str(exc), "code": "OPENAI_API_ERROR"}},
    )


@app.exception_handler(MealPlanNotFound)
async def meal_plan_not_found_handler(request: Request, exc: MealPlanNotFound):
    return JSONResponse(
        status_code=status.HTTP_404_NOT_FOUND,
        content={"detail": {"message": str(exc), "code": "MEAL_PLAN_NOT_FOUND"}},
    )


@app.exception_handler(ActiveGoalNotFound)
async def active_goal_not_found_handler(request: Request, exc: ActiveGoalNotFound):
    return JSONResponse(
        status_code=status.HTTP_404_NOT_FOUND,
        content={"detail": {"message": str(exc), "code": "ACTIVE_GOAL_NOT_FOUND"}},
    )


@app.exception_handler(SQLAlchemyError)
async def database_error_handler(request: Request, exc: SQLAlchemyError):
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={"detail": {"message": "Database error occurred", "code": "DATABASE_ERROR"}},
    )


# Health check endpoint
@app.get("/health", tags=["health"])
def health_check():
    """Health check endpoint."""
    return {
        "status": "healthy",
        "app_name": settings.APP_NAME,
        "version": "1.0.0",
    }


# Include API router
app.include_router(api_router, prefix=settings.API_V1_STR)


# Root endpoint
@app.get("/", tags=["root"])
def root():
    """Root endpoint with API information."""
    return {
        "message": "Meal Planner API",
        "version": "1.0.0",
        "docs": "/docs",
        "health": "/health",
    }
