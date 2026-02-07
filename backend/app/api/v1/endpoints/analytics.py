"""
Analytics API endpoints.
"""
from datetime import date
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user
from app.schemas.analytics import DailyTotals, SummaryStatsResponse, WeeklySummary
from app.services.analytics_service import analytics_service
from app.models.user import User

router = APIRouter()


@router.get("/analytics/daily/{target_date}", response_model=DailyTotals)
def get_daily_totals(
    target_date: date,
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get daily macro totals for a specific date."""
    totals = analytics_service.get_daily_totals(
        db, user_id=current_user.id, target_date=target_date
    )
    return totals


@router.get("/analytics/summary", response_model=SummaryStatsResponse)
def get_summary_stats(
    current_user: User = Depends(get_current_user),
    db: Session = Depends(get_db),
):
    """Get summary statistics (7-day and 30-day averages)."""
    # Get 7-day summary
    seven_day = analytics_service.get_summary_stats(db, user_id=current_user.id, days=7)
    seven_day_summary = WeeklySummary(**seven_day)

    # Get 30-day summary
    thirty_day = analytics_service.get_summary_stats(db, user_id=current_user.id, days=30)
    thirty_day_summary = WeeklySummary(**thirty_day)

    # Get logging consistency
    consistency = analytics_service.calculate_logging_consistency(
        db, user_id=current_user.id, days=30
    )

    return SummaryStatsResponse(
        seven_day_summary=seven_day_summary,
        thirty_day_summary=thirty_day_summary,
        logging_consistency_percentage=consistency,
    )
