"""
TDEE (Total Daily Energy Expenditure) calculation service.
"""


class TDEEService:
    """Service for calculating TDEE and recommended calories."""

    # Activity level multipliers
    ACTIVITY_MULTIPLIERS = {
        "sedentary": 1.2,
        "lightly_active": 1.375,
        "moderately_active": 1.55,
        "very_active": 1.725,
        "extra_active": 1.9,
    }

    # Goal adjustments (calories per day)
    GOAL_ADJUSTMENTS = {
        "lose_weight": -500,
        "maintain": 0,
        "gain_weight": 500,
    }

    @staticmethod
    def calculate_bmr(*, age: int, weight_kg: float, height_cm: float, gender: str) -> int:
        """
        Calculate Basal Metabolic Rate using Mifflin-St Jeor Equation.

        Men: BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age(y) + 5
        Women: BMR = 10 * weight(kg) + 6.25 * height(cm) - 5 * age(y) - 161
        """
        bmr = 10 * weight_kg + 6.25 * height_cm - 5 * age

        if gender == "male":
            bmr += 5
        else:  # female
            bmr -= 161

        return int(bmr)

    @staticmethod
    def calculate_tdee(*, bmr: int, activity_level: str) -> int:
        """Calculate TDEE by multiplying BMR with activity level."""
        multiplier = TDEEService.ACTIVITY_MULTIPLIERS.get(activity_level, 1.2)
        return int(bmr * multiplier)

    @staticmethod
    def calculate_recommended_calories(*, tdee: int, goal: str) -> int:
        """Calculate recommended calories based on goal."""
        adjustment = TDEEService.GOAL_ADJUSTMENTS.get(goal, 0)
        return tdee + adjustment

    @classmethod
    def calculate_full(
        cls,
        *,
        age: int,
        weight_kg: float,
        height_cm: float,
        gender: str,
        activity_level: str,
        goal: str
    ) -> dict:
        """Calculate BMR, TDEE, and recommended calories."""
        bmr = cls.calculate_bmr(
            age=age, weight_kg=weight_kg, height_cm=height_cm, gender=gender
        )
        tdee = cls.calculate_tdee(bmr=bmr, activity_level=activity_level)
        recommended_calories = cls.calculate_recommended_calories(tdee=tdee, goal=goal)

        return {
            "bmr": bmr,
            "tdee": tdee,
            "recommended_calories": recommended_calories,
            "activity_level": activity_level,
            "goal": goal,
        }


tdee_service = TDEEService()
