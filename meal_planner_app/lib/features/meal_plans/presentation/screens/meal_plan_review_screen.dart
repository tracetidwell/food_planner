import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/planned_meal.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/providers/meal_plans_provider.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/widgets/day_summary.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/widgets/macro_display.dart';

/// Screen for reviewing generated meal plan
class MealPlanReviewScreen extends ConsumerStatefulWidget {
  final String mealPlanId;

  const MealPlanReviewScreen({
    super.key,
    required this.mealPlanId,
  });

  @override
  ConsumerState<MealPlanReviewScreen> createState() =>
      _MealPlanReviewScreenState();
}

class _MealPlanReviewScreenState extends ConsumerState<MealPlanReviewScreen>
    with TickerProviderStateMixin {
  TabController? _tabController;
  final Set<String> _regeneratingMealIds = {};
  int _lastTabCount = 0;

  @override
  void initState() {
    super.initState();
    // Load meal plan if not already loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentPlan = ref.read(mealPlanGenerationProvider).value;
      if (currentPlan == null || currentPlan.id != widget.mealPlanId) {
        _loadMealPlan();
      }
    });
  }

  Future<void> _loadMealPlan() async {
    final useCase = ref.read(getMealPlanByIdUseCaseProvider);
    final result = await useCase(widget.mealPlanId);

    result.fold(
      (failure) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error loading meal plan: ${failure.message}')),
          );
        }
      },
      (mealPlan) {
        // Update state properly using notifier method
        final notifier = ref.read(mealPlanGenerationProvider.notifier);
        notifier.state = AsyncValue.data(mealPlan);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final mealPlanState = ref.watch(mealPlanGenerationProvider);

    return mealPlanState.when(
      data: (mealPlan) {
        if (mealPlan == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Meal Plan')),
            body: const Center(child: Text('Meal plan not found')),
          );
        }

        // Group meals by day
        final mealsByDay = <int, List<PlannedMeal>>{};
        for (final meal in mealPlan.meals ?? []) {
          mealsByDay.putIfAbsent(meal.dayIndex, () => []).add(meal);
        }

        // Sort meals within each day
        for (final meals in mealsByDay.values) {
          meals.sort((a, b) => a.mealType.compareTo(b.mealType));
        }

        // Initialize tab controller only when count changes
        if (_lastTabCount != mealsByDay.length) {
          _tabController?.dispose();
          _tabController = TabController(
            length: mealsByDay.length,
            vsync: this,
          );
          _lastTabCount = mealsByDay.length;
        }

        // Calculate plan totals
        final totalCalories = (mealPlan.meals ?? []).fold<int>(
          0,
          (sum, meal) => sum + meal.calories,
        );
        final totalProtein = (mealPlan.meals ?? []).fold<double>(
          0,
          (sum, meal) => sum + meal.protein,
        );
        final totalCarbs = (mealPlan.meals ?? []).fold<double>(
          0,
          (sum, meal) => sum + meal.carbs,
        );
        final totalFat = (mealPlan.meals ?? []).fold<double>(
          0,
          (sum, meal) => sum + meal.fat,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text('Your Meal Plan'),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => _confirmDiscard(context),
            ),
          ),
          body: Column(
            children: [
              // Summary card
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Plan Summary',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_formatDate(mealPlan.startDate)} - ${_formatDate(mealPlan.endDate)}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                          Chip(
                            label: Text('${mealPlan.durationInDays} days'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Total Nutrition',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
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

              // Tabs for days
              if (mealsByDay.isNotEmpty && _tabController != null)
                TabBar(
                  controller: _tabController!,
                  isScrollable: true,
                  tabs: List.generate(
                    mealsByDay.length,
                    (index) => Tab(text: 'Day ${index + 1}'),
                  ),
                ),

              // Day content
              if (_tabController != null)
                Expanded(
                  child: TabBarView(
                    controller: _tabController!,
                    children: List.generate(
                      mealsByDay.length,
                      (dayIndex) {
                        final meals = mealsByDay[dayIndex] ?? [];
                        final date = mealPlan.startDate.add(Duration(days: dayIndex));

                        return DaySummary(
                          dayNumber: dayIndex + 1,
                          date: date,
                          meals: meals,
                          onRegenerateMeal: _regenerateMeal,
                          regeneratingMealIds: _regeneratingMealIds,
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
          bottomNavigationBar: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _rejectPlan(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton(
                      onPressed: () => _acceptPlan(context, mealPlan.id),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Accept Plan'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(title: const Text('Meal Plan')),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (error, stack) => Scaffold(
        appBar: AppBar(title: const Text('Meal Plan')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _loadMealPlan,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _regenerateMeal(String mealId) async {
    setState(() {
      _regeneratingMealIds.add(mealId);
    });

    final success = await ref
        .read(mealPlanGenerationProvider.notifier)
        .regenerateMeal(
          mealPlanId: widget.mealPlanId,
          plannedMealId: mealId,
        );

    if (mounted) {
      setState(() {
        _regeneratingMealIds.remove(mealId);
      });

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Failed to regenerate meal. Please try again.'),
            action: SnackBarAction(
              label: 'OK',
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  Future<void> _acceptPlan(BuildContext context, String mealPlanId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Accept Meal Plan?'),
        content: const Text(
          'This will generate a grocery list for your meal plan. You can view it after accepting.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Accept'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Show loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text('Accepting meal plan...'),
              ],
            ),
          ),
        ),
      ),
    );

    final success = await ref
        .read(mealPlanGenerationProvider.notifier)
        .acceptMealPlan(mealPlanId);

    if (!context.mounted) return;

    Navigator.pop(context); // Close loading dialog

    if (success) {
      // Navigate to grocery list
      context.go('/meal-plans/$mealPlanId/grocery-list');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: const Text('Failed to accept meal plan. Please try again.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _rejectPlan(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Meal Plan?'),
        content: const Text(
          'This will discard this meal plan. You can generate a new one anytime.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      ref.read(mealPlanGenerationProvider.notifier).reset();
      context.go('/');
    }
  }

  Future<void> _confirmDiscard(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Meal Plan?'),
        content: const Text('Are you sure you want to go back?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Discard'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      context.pop();
    }
  }

  String _formatDate(DateTime date) {
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
    return '${months[date.month - 1]} ${date.day}';
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }
}
