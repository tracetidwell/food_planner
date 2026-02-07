import 'package:flutter/material.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/planned_meal.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/widgets/macro_display.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/widgets/meal_card.dart';

/// Widget to display all meals for a single day
class DaySummary extends StatelessWidget {
  final int dayNumber;
  final DateTime date;
  final List<PlannedMeal> meals;
  final Function(String mealId)? onRegenerateMeal;
  final Set<String> regeneratingMealIds;

  const DaySummary({
    super.key,
    required this.dayNumber,
    required this.date,
    required this.meals,
    this.onRegenerateMeal,
    this.regeneratingMealIds = const {},
  });

  @override
  Widget build(BuildContext context) {
    // Calculate daily totals
    final totalProtein = meals.fold<double>(
      0,
      (sum, meal) => sum + meal.protein,
    );
    final totalCarbs = meals.fold<double>(
      0,
      (sum, meal) => sum + meal.carbs,
    );
    final totalFat = meals.fold<double>(
      0,
      (sum, meal) => sum + meal.fat,
    );
    final totalCalories = meals.fold<int>(
      0,
      (sum, meal) => sum + meal.calories,
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day header
          Text(
            'Day $dayNumber',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            _formatDate(date),
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),

          // Meals
          ...meals.map(
            (meal) => MealCard(
              meal: meal,
              onRegenerate: onRegenerateMeal != null
                  ? () => onRegenerateMeal!(meal.id)
                  : null,
              isRegenerating: regeneratingMealIds.contains(meal.id),
            ),
          ),

          const SizedBox(height: 16),

          // Daily totals
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Daily Totals',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 12),
                  MacroDisplay(
                    protein: totalProtein,
                    carbs: totalCarbs,
                    fat: totalFat,
                    calories: totalCalories,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];

    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}
