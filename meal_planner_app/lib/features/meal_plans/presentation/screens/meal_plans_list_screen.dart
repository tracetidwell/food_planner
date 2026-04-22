import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/features/meal_plans/domain/entities/meal_plan.dart';
import 'package:meal_planner_app/features/meal_plans/presentation/providers/meal_plans_provider.dart';

class MealPlansListScreen extends ConsumerWidget {
  const MealPlansListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final plansAsync = ref.watch(mealPlansListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Meal Plans'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/meal-plans/configure'),
        icon: const Icon(Icons.add),
        label: const Text('New Plan'),
      ),
      body: plansAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 12),
              Text('Failed to load plans: $e'),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: () => ref.invalidate(mealPlansListProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (plans) {
          if (plans.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 64,
                    color: Theme.of(context).colorScheme.outline,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No meal plans yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Generate your first plan to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () => context.push('/meal-plans/configure'),
                    icon: const Icon(Icons.add),
                    label: const Text('Generate Plan'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async => ref.invalidate(mealPlansListProvider),
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: plans.length,
              itemBuilder: (context, index) =>
                  _MealPlanCard(plan: plans[index]),
            ),
          );
        },
      ),
    );
  }
}

class _MealPlanCard extends StatelessWidget {
  final MealPlan plan;

  const _MealPlanCard({required this.plan});

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM d, yyyy');
    final isAccepted = plan.status == PlanStatus.accepted;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          if (isAccepted) {
            context.push('/meal-plans/${plan.id}/grocery-list');
          } else {
            context.push('/meal-plans/review/${plan.id}');
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${plan.durationInDays}-Day Plan',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  _StatusChip(status: plan.status),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                  const SizedBox(width: 6),
                  Text(
                    '${dateFormat.format(plan.startDate)} – ${dateFormat.format(plan.endDate)}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isAccepted) ...[
                    OutlinedButton.icon(
                      onPressed: () =>
                          context.push('/meal-plans/review/${plan.id}'),
                      icon: const Icon(Icons.restaurant_menu, size: 16),
                      label: const Text('View Plan'),
                    ),
                    const SizedBox(width: 8),
                    FilledButton.icon(
                      onPressed: () =>
                          context.push('/meal-plans/${plan.id}/grocery-list'),
                      icon: const Icon(Icons.shopping_cart, size: 16),
                      label: const Text('Grocery List'),
                    ),
                  ] else
                    FilledButton.icon(
                      onPressed: () =>
                          context.push('/meal-plans/review/${plan.id}'),
                      icon: const Icon(Icons.visibility, size: 16),
                      label: const Text('Review Plan'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final PlanStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      PlanStatus.accepted => ('Accepted', Colors.green),
      PlanStatus.pending => ('Pending', Colors.orange),
      PlanStatus.archived => ('Archived', Colors.grey),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
