import 'package:flutter/material.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/planned_meal.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/widgets/macro_display.dart';

/// Widget to display a single meal card
class MealCard extends StatelessWidget {
  final PlannedMeal meal;
  final VoidCallback? onRegenerate;
  final bool isRegenerating;

  const MealCard({
    super.key,
    required this.meal,
    this.onRegenerate,
    this.isRegenerating = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meal name and regenerate button
            Row(
              children: [
                Expanded(
                  child: Text(
                    meal.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (onRegenerate != null)
                  IconButton(
                    icon: isRegenerating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.refresh),
                    onPressed: isRegenerating ? null : onRegenerate,
                    tooltip: 'Regenerate meal',
                  ),
              ],
            ),
            const SizedBox(height: 12),

            // Foods list
            ...meal.foods.map(
              (food) {
                // Format quantity based on unit
                String quantityText;
                if (food.unit == 'g' && food.quantity == food.quantity.toInt()) {
                  // Show grams without decimal for whole numbers
                  quantityText = '${food.quantity.toInt()}${food.unit}';
                } else if (food.unit == 'g') {
                  // Show grams with one decimal for partial amounts
                  quantityText = '${food.quantity.toStringAsFixed(1)}${food.unit}';
                } else if (food.quantity == food.quantity.toInt()) {
                  // For countable items with whole numbers
                  quantityText = '${food.quantity.toInt()} ${food.unit}';
                } else {
                  // For countable items with decimals
                  quantityText = '${food.quantity.toStringAsFixed(1)} ${food.unit}';
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      const Icon(Icons.fiber_manual_record, size: 8),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${food.name} ($quantityText)',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // Macros
            MacroDisplay(
              protein: meal.protein,
              carbs: meal.carbs,
              fat: meal.fat,
              calories: meal.calories,
              showLabels: false,
            ),
          ],
        ),
      ),
    );
  }
}
