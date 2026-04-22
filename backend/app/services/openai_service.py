"""
OpenAI API integration service for meal plan generation.
"""
import json
from typing import Dict, Any, Optional
from openai import OpenAI

from app.config import settings
from app.core.exceptions import OpenAIAPIError
from app.utils.retry import retry_openai


class OpenAIService:
    """Service for interacting with OpenAI API."""

    def __init__(self, api_key: Optional[str] = None):
        """Initialize OpenAI client with API key."""
        self.api_key = api_key or settings.OPENAI_API_KEY
        if not self.api_key:
            raise ValueError("OpenAI API key not provided")
        self.client = OpenAI(api_key=self.api_key, timeout=settings.OPENAI_TIMEOUT)

    def _construct_prompt(
        self,
        *,
        daily_calories: int,
        protein_grams: float,
        carb_grams: float,
        fat_grams: float,
        meals_per_day: int,
        snacks_per_day: int,
        food_preferences: str,
        duration_days: int
    ) -> str:
        """Construct the prompt for meal plan generation."""
        total_items_per_day = meals_per_day + snacks_per_day
        # Suggested per-occasion targets: meals ~75% of daily calories, snacks ~25% of daily calories
        meal_calories = int(daily_calories * 0.75 / meals_per_day) if meals_per_day > 0 else 0
        snack_calories = int(daily_calories * 0.25 / snacks_per_day) if snacks_per_day > 0 else 0
        meal_cal_min = int(meal_calories * 0.75)
        meal_cal_max = int(meal_calories * 1.25)
        snack_cal_min = int(snack_calories * 0.75)
        snack_cal_max = int(snack_calories * 1.25)

        prompt = f"""You are a nutrition expert creating a personalized meal plan.

            USER GOALS (MUST BE MET DAILY):
            - Daily Calories: {daily_calories} (CRITICAL: Must hit this target within ±5%)
            - Protein: {protein_grams:.1f}g per day
            - Carbohydrates: {carb_grams:.1f}g per day
            - Fat: {fat_grams:.1f}g per day

            MEAL STRUCTURE (MUST INCLUDE ALL):
            - EXACTLY {meals_per_day} meals per day (type: "meal", index: 1, 2, 3, etc.)
            - EXACTLY {snacks_per_day} snacks per day (type: "snack", index: 1, 2, etc.)
            - Total of {total_items_per_day} eating occasions per day

            CALORIE DISTRIBUTION (IMPORTANT):
            - Each MEAL should contain roughly {meal_calories} (acceptable range: {meal_cal_min} to {meal_cal_max} calories)
            - Each SNACK should contain roughly {snack_calories} (acceptable range: {snack_cal_min} to {snack_cal_max} calories)
            - No single meal should exceed 40% of the daily target ({int(daily_calories * 0.4)} calories)
            - No single snack should exceed 20% of the daily target ({int(daily_calories * 0.2)} calories)
            - Calories must be spread evely - avoid making any one meal significantly larger than the others

            FOOD PREFERENCES:
            {food_preferences or 'No specific preferences'}

            CRITICAL REQUIREMENTS:
            1. Generate a {duration_days}-day meal plan
            2. MUST include ALL {meals_per_day} meals AND ALL {snacks_per_day} snacks EVERY day
            3. Daily calorie total MUST be {daily_calories} ±5% (between {int(daily_calories * 0.95)} and {int(daily_calories * 1.05)})
            4. Distribute calories across all {total_items_per_day} eating occasions
            5. Provide specific foods with portions:
            - For countable items (eggs, fruits, vegetables, etc.): use natural quantities (e.g., "2 eggs", "1 banana", "3 oz chicken")
            - For other items: use grams
            6. Calculate exact macros for each meal/snack
            7. Vary meals across days to prevent boredom
            8. All non-countable foods (including protein powder, milk, meat, rice, pasta, yogurt, beans, oils, butter) must be specified in grams.
            Only eggs and whole fruits may use natural units.
            9. Snacks should have 15-20 grams of protein.
            10. Protein distribution constraint:
            - Each snack MUST contain between 15–20g protein.
            - Remaining daily protein (total_protein − sum(snack protein)) MUST be distributed across meals.
            - Each meal’s protein MUST be within ±10% of the per-meal average protein target.
            11. Calorie distribution constraint:
            - Each snack MUST contain 150–250 calories.
            - Remaining daily calories (total_calories − sum(snack calories)) MUST be distributed across meals.
            - Each meal’s calories MUST be within ±10% of the per-meal average calorie target.
                    
            MATHEMATICAL CONSTRAINTS (MANDATORY)
            For every meal, snack, and daily total:
            calories = (protein_grams x 4) + (carb_grams x 4) + (fat_grams x 9)
            These must match exactly (no rounding drift).

            Also include a per-day totals object with:

            total_protein_grams
            total_carb_grams
            total_fat_grams
            total_calories
            calories_from_macros (computed as 4P+4C+9F)
            total_calories must equal calories_from_macros and be within {daily_calories} ±5%.


            Return the meal plan in the following JSON format:
            {{
            "days": [
                {{
                "day": 1,
                "totals": {{
                    "total_protein_grams": 0,
                    "total_carb_grams": 0,
                    "total_fat_grams": 0,
                    "total_calories": 0,
                    "calories_from_macros": 0
                }},
                "meals": [
                    {{
                    "type": "meal",
                    "index": 1,
                    "name": "Breakfast Bowl",
                    "foods": [
                        {{"food": "Oatmeal", "quantity_grams": 80}},
                        {{"food": "Banana", "quantity": "1 large"}}
                    ],
                    "protein_grams": 15.0,
                    "carb_grams": 70.0,
                    "fat_grams": 8.0,
                    "calories": 400
                    }},
                    {{
                    "type": "snack",
                    "index": 1,
                    "name": "Protein Shake",
                    "foods": [
                        {{"food": "Protein powder", "quantity": "1 scoop"}},
                        {{"food": "Milk", "quantity": "1 cup"}}
                    ],
                    "protein_grams": 30.0,
                    "carb_grams": 15.0,
                    "fat_grams": 5.0,
                    "calories": 220
                    }},
                    {{
                    "type": "meal",
                    "index": 2,
                    "name": "Lunch",
                    "foods": [
                        {{"food": "Chicken breast", "quantity": "6 oz"}},
                        {{"food": "Rice, brown", "quantity_grams": 150}},
                        {{"food": "Broccoli", "quantity": "1 cup"}}
                    ],
                    "protein_grams": 45.0,
                    "carb_grams": 50.0,
                    "fat_grams": 12.0,
                    "calories": 480
                    }}
                ]
                }}
            ]
            }}

            IMPORTANT: Each day must have {total_items_per_day} items total ({meals_per_day} meals + {snacks_per_day} snacks) to reach the daily calorie target."""
        return prompt

    @retry_openai
    def generate_meal_plan(
        self,
        *,
        daily_calories: int,
        protein_grams: float,
        carb_grams: float,
        fat_grams: float,
        meals_per_day: int,
        snacks_per_day: int,
        food_preferences: str,
        duration_days: int,
        previous_attempt: Optional[Dict[str, Any]] = None,
        validation_errors: Optional[list] = None,
    ) -> Dict[str, Any]:
        """
        Generate a meal plan using OpenAI API.

        Returns the parsed JSON response from OpenAI.
        """
        try:
            # Construct prompt
            prompt = self._construct_prompt(
                daily_calories=daily_calories,
                protein_grams=protein_grams,
                carb_grams=carb_grams,
                fat_grams=fat_grams,
                meals_per_day=meals_per_day,
                snacks_per_day=snacks_per_day,
                food_preferences=food_preferences,
                duration_days=duration_days,
            )


            # Build messages based on whether this is a retry
            if previous_attempt and validation_errors:
                # This is a retry - provide context about the failed attempt
                print(f"[INFO] Retry attempt - including previous response and validation errors")
                messages = [
                    {
                        "role": "system",
                        "content": "You are a professional nutritionist and meal planner. Always respond with valid JSON.",
                    },
                    {"role": "user", "content": prompt},
                    {
                        "role": "assistant",
                        "content": json.dumps(previous_attempt),
                    },
                    {
                        "role": "user",
                        "content": f"""The meal plan you provided does not meet the requirements. It failed validation with the following errors:

{chr(10).join(f"- {error}" for error in validation_errors)}

Please update the existing meal plan that fixes these issues and meets ALL the requirements specified in the original prompt. Pay special attention to:
1. Including EXACTLY {meals_per_day} meals AND {snacks_per_day} snacks for each day
2. Ensuring daily calories are within ±5% of {daily_calories} (between {int(daily_calories * 0.95)} and {int(daily_calories * 1.05)})
3. Properly distributing macros across all eating occasions""",
                    },
                ]
            else:
                # First attempt - use standard messages
                messages = [
                    {
                        "role": "system",
                        "content": "You are a professional nutritionist and meal planner. Always respond with valid JSON.",
                    },
                    {"role": "user", "content": prompt},
                ]

                        # Log the prompt for debugging
            print(f"[DEBUG] OpenAI Prompt:\n{messages}")

            # Call OpenAI API
            response = self.client.chat.completions.create(
                model=settings.OPENAI_MODEL,
                messages=messages,
                temperature=settings.OPENAI_TEMPERATURE,
                max_tokens=settings.OPENAI_MAX_TOKENS,
                response_format={"type": "json_object"},
            )

            # Extract and parse response
            content = response.choices[0].message.content

            # Log the response for debugging
            print(f"[DEBUG] OpenAI Response Length: {len(content)} characters")

            # Try to clean up common JSON issues
            content = content.strip()

            # Remove markdown code blocks if present
            if content.startswith("```json"):
                content = content[7:]
            if content.startswith("```"):
                content = content[3:]
            if content.endswith("```"):
                content = content[:-3]
            content = content.strip()

            try:
                meal_plan_data = json.loads(content)
            except json.JSONDecodeError as e:
                # Log first 500 and last 500 characters for debugging
                print(f"[ERROR] JSON Parse Error: {str(e)}")
                print(f"[ERROR] Response Start: {content[:500]}")
                print(f"[ERROR] Response End: {content[-500:]}")
                raise OpenAIAPIError(f"Failed to parse OpenAI response: {str(e)}")

            return meal_plan_data

        except OpenAIAPIError:
            raise
        except json.JSONDecodeError as e:
            raise OpenAIAPIError(f"Failed to parse OpenAI response: {str(e)}")
        except Exception as e:
            print(f"[ERROR] OpenAI API exception: {type(e).__name__}: {str(e)}", flush=True)
            raise OpenAIAPIError(f"OpenAI API error: {str(e)}")

    @retry_openai
    def regenerate_single_meal(
        self,
        *,
        meal_type: str,
        meal_index: int,
        daily_calories: int,
        target_protein: float,
        target_carbs: float,
        target_fat: float,
        target_calories: int,
        food_preferences: str
    ) -> Dict[str, Any]:
        """
        Regenerate a single meal using OpenAI API.

        Returns a single meal object.
        """
        try:
            prompt = f"""Generate a single {meal_type} (number {meal_index}) with the following targets:

TARGETS:
- Protein: {target_protein:.1f}g
- Carbohydrates: {target_carbs:.1f}g
- Fat: {target_fat:.1f}g
- Calories: approximately {target_calories}

FOOD PREFERENCES:
{food_preferences or 'No specific preferences'}

Return the meal in this JSON format:
{{
  "type": "{meal_type}",
  "index": {meal_index},
  "name": "Meal name",
  "foods": [
    {{"food": "Food name", "quantity_grams": 200}}
  ],
  "protein_grams": 50.0,
  "carb_grams": 60.0,
  "fat_grams": 15.0,
  "calories": 550
}}"""

            response = self.client.chat.completions.create(
                model=settings.OPENAI_MODEL,
                messages=[
                    {
                        "role": "system",
                        "content": "You are a professional nutritionist. Always respond with valid JSON.",
                    },
                    {"role": "user", "content": prompt},
                ],
                temperature=settings.OPENAI_TEMPERATURE,
                max_tokens=1000,
                response_format={"type": "json_object"},
            )

            content = response.choices[0].message.content
            meal_data = json.loads(content)

            return meal_data

        except json.JSONDecodeError as e:
            raise OpenAIAPIError(f"Failed to parse OpenAI response: {str(e)}")
        except Exception as e:
            raise OpenAIAPIError(f"OpenAI API error: {str(e)}")
