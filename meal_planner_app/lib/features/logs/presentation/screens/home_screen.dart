import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_planner_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:meal_planner_app/features/goals/presentation/providers/goals_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsState = ref.watch(goalsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Planner'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/profile'),
            tooltip: 'Settings',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authNotifierProvider.notifier).logout();
            },
            tooltip: 'Logout',
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Current Goal Card
          goalsState.when(
            data: (goal) {
              if (goal == null) {
                return _NoGoalCard(
                  onSetGoal: () => context.push('/goals/tdee-calculator'),
                );
              }
              return _CurrentGoalCard(
                calorieTarget: goal.calorieTarget,
                proteinTarget: goal.proteinTarget,
                carbTarget: goal.carbTarget,
                fatTarget: goal.fatTarget,
                onEdit: () => context.push('/goals/create'),
              );
            },
            loading: () => const Card(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Center(child: CircularProgressIndicator()),
              ),
            ),
            error: (error, _) => Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 8),
                    Text('Error loading goal: $error'),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () => context.push('/goals/tdee-calculator'),
                      child: const Text('Set Goal'),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Quick Actions
          const Text(
            'Quick Actions',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
            children: [
              _ActionCard(
                icon: Icons.calculate,
                label: 'TDEE Calculator',
                color: Colors.blue,
                onTap: () => context.push('/goals/tdee-calculator'),
              ),
              _ActionCard(
                icon: Icons.restaurant,
                label: 'Generate Meal Plan',
                color: Colors.green,
                onTap: () {
                  // Check if user has active goal first
                  goalsState.when(
                    data: (goal) {
                      if (goal == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Please set a nutrition goal first'),
                            action: SnackBarAction(
                              label: 'Set Goal',
                              onPressed: () => context.push('/goals/tdee-calculator'),
                            ),
                          ),
                        );
                      } else {
                        context.push('/meal-plans/configure');
                      }
                    },
                    loading: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Loading...')),
                      );
                    },
                    error: (_, __) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Please set a nutrition goal first'),
                          action: SnackBarAction(
                            label: 'Set Goal',
                            onPressed: () => context.push('/goals/tdee-calculator'),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              _ActionCard(
                icon: Icons.food_bank,
                label: "Today's Meals",
                color: Colors.orange,
                onTap: () {
                  // TODO: Navigate to today's meals
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon!')),
                  );
                },
              ),
              _ActionCard(
                icon: Icons.analytics,
                label: 'View Analytics',
                color: Colors.purple,
                onTap: () {
                  // TODO: Navigate to analytics
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coming soon!')),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Status Card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Development Status',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _StatusItem(
                    icon: Icons.check_circle,
                    label: 'Authentication',
                    status: 'Complete',
                    color: Colors.green,
                  ),
                  _StatusItem(
                    icon: Icons.check_circle,
                    label: 'Goals & TDEE',
                    status: 'Complete',
                    color: Colors.green,
                  ),
                  _StatusItem(
                    icon: Icons.construction,
                    label: 'Meal Plans',
                    status: 'In Progress',
                    color: Colors.orange,
                  ),
                  _StatusItem(
                    icon: Icons.construction,
                    label: 'Meal Logging',
                    status: 'In Progress',
                    color: Colors.orange,
                  ),
                  _StatusItem(
                    icon: Icons.construction,
                    label: 'Analytics',
                    status: 'In Progress',
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoGoalCard extends StatelessWidget {
  final VoidCallback onSetGoal;

  const _NoGoalCard({required this.onSetGoal});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.primaryContainer,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.flag_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(height: 12),
            Text(
              'Set Your Nutrition Goal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Calculate your TDEE and set your daily calorie and macro targets',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onSetGoal,
              icon: const Icon(Icons.calculate),
              label: const Text('Calculate TDEE'),
            ),
          ],
        ),
      ),
    );
  }
}

class _CurrentGoalCard extends StatelessWidget {
  final int calorieTarget;
  final double proteinTarget;
  final double carbTarget;
  final double fatTarget;
  final VoidCallback onEdit;

  const _CurrentGoalCard({
    required this.calorieTarget,
    required this.proteinTarget,
    required this.carbTarget,
    required this.fatTarget,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Current Goal',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: onEdit,
                  tooltip: 'Edit Goal',
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MacroDisplay(
                  label: 'Calories',
                  value: '$calorieTarget',
                  unit: 'kcal',
                  color: Theme.of(context).colorScheme.primary,
                ),
                _MacroDisplay(
                  label: 'Protein',
                  value: '${proteinTarget.toStringAsFixed(0)}',
                  unit: 'g',
                  color: Colors.red,
                ),
                _MacroDisplay(
                  label: 'Carbs',
                  value: '${carbTarget.toStringAsFixed(0)}',
                  unit: 'g',
                  color: Colors.blue,
                ),
                _MacroDisplay(
                  label: 'Fat',
                  value: '${fatTarget.toStringAsFixed(0)}',
                  unit: 'g',
                  color: Colors.orange,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MacroDisplay extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;

  const _MacroDisplay({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String status;
  final Color color;

  const _StatusItem({
    required this.icon,
    required this.label,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            status,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
