"""
Grocery list generation service.
"""
from collections import defaultdict
from typing import Dict, List
from sqlalchemy.orm import Session

from app.models.meal_plan import MealPlan
from app.models.grocery import GroceryList


class GroceryService:
    """Service for generating grocery lists from meal plans."""

    # Simple food categorization (can be enhanced with ML or more rules)
    CATEGORY_KEYWORDS = {
        "Protein": ["chicken", "beef", "pork", "fish", "salmon", "tuna", "turkey", "egg", "tofu", "tempeh"],
        "Vegetables": ["broccoli", "spinach", "kale", "lettuce", "tomato", "cucumber", "pepper", "carrot", "onion", "garlic"],
        "Fruits": ["apple", "banana", "orange", "berry", "strawberry", "blueberry", "grape", "melon"],
        "Grains": ["rice", "pasta", "bread", "oats", "quinoa", "couscous", "barley"],
        "Dairy": ["milk", "cheese", "yogurt", "butter", "cream"],
        "Nuts & Seeds": ["almond", "walnut", "peanut", "cashew", "seed", "nut"],
        "Oils & Condiments": ["oil", "olive oil", "vinegar", "sauce", "dressing", "mayo"],
        "Other": [],
    }

    @staticmethod
    def categorize_food(food_name: str) -> str:
        """Categorize a food item based on keywords."""
        food_lower = food_name.lower()

        for category, keywords in GroceryService.CATEGORY_KEYWORDS.items():
            if category == "Other":
                continue
            for keyword in keywords:
                if keyword in food_lower:
                    return category

        return "Other"

    @staticmethod
    def generate_grocery_list(db: Session, *, meal_plan: MealPlan) -> GroceryList:
        """
        Generate a grocery list from a meal plan.

        Aggregates all foods from planned meals, sums quantities, and categorizes.
        """
        # Dictionary to aggregate foods: {(food_name, unit): total_quantity}
        food_totals: Dict[tuple, float] = defaultdict(float)

        # Iterate through all planned meals
        for planned_meal in meal_plan.planned_meals:
            for food_item in planned_meal.foods:
                food_name = food_item["food"]

                # Handle both quantity_grams and quantity formats
                if "quantity_grams" in food_item:
                    quantity = food_item["quantity_grams"]
                    unit = "g"
                elif "quantity" in food_item:
                    # Parse quantity string like "2 eggs", "1 cup", "6 oz"
                    quantity_str = food_item["quantity"]
                    parts = quantity_str.strip().split(' ', 1)

                    if len(parts) >= 1:
                        try:
                            quantity = float(parts[0])
                            unit = parts[1] if len(parts) > 1 else "item"
                        except ValueError:
                            # If we can't parse it, treat the whole thing as a unit with quantity 1
                            quantity = 1.0
                            unit = quantity_str
                    else:
                        quantity = 1.0
                        unit = "item"
                else:
                    # Fallback if neither field exists
                    quantity = 0.0
                    unit = "unknown"

                # Aggregate by (food_name, unit) pair
                food_totals[(food_name, unit)] += quantity

        # Create grocery items with categories
        grocery_items = []
        for (food_name, unit), total_quantity in food_totals.items():
            category = GroceryService.categorize_food(food_name)
            grocery_items.append({
                "food": food_name,
                "quantity": round(total_quantity, 1),
                "unit": unit,
                "category": category,
            })

        # Sort by category then by food name
        grocery_items.sort(key=lambda x: (x["category"], x["food"]))

        # Create grocery list in database
        db_grocery = GroceryList(
            meal_plan_id=meal_plan.id,
            items=grocery_items,
        )
        db.add(db_grocery)
        db.commit()
        db.refresh(db_grocery)

        return db_grocery


grocery_service = GroceryService()
