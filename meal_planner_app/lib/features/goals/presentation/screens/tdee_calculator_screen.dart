import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/features/goals/domain/entities/tdee_result.dart';
import 'package:meal_planner_app/features/goals/presentation/providers/goals_provider.dart';

class TdeeCalculatorScreen extends ConsumerStatefulWidget {
  const TdeeCalculatorScreen({super.key});

  @override
  ConsumerState<TdeeCalculatorScreen> createState() => _TdeeCalculatorScreenState();
}

class _TdeeCalculatorScreenState extends ConsumerState<TdeeCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  Gender _selectedGender = Gender.male;
  ActivityLevel _selectedActivityLevel = ActivityLevel.moderatelyActive;
  GoalType _selectedGoalType = GoalType.maintain;
  bool _isCalculating = false;

  @override
  void dispose() {
    _ageController.dispose();
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  void _calculateTdee() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isCalculating = true);

    try {
      final age = int.parse(_ageController.text);
      final weight = double.parse(_weightController.text);
      final height = double.parse(_heightController.text);

      final result = await ref.read(tdeeProvider.notifier).calculateTdee(
            age: age,
            weightKg: weight,
            heightCm: height,
            gender: _selectedGender,
            activityLevel: _selectedActivityLevel,
            goal: _selectedGoalType,
          );

      if (mounted) {
        setState(() => _isCalculating = false);

        if (result != null) {
          _showResultsDialog(result);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Failed to calculate TDEE. Please try again.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isCalculating = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showResultsDialog(TdeeResult result) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          title: const Text('Your TDEE Results'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            _ResultRow(
              label: 'Maintenance Calories',
              value: '${result.maintenanceCalories} kcal/day',
              subtitle: 'To maintain current weight',
            ),
            const SizedBox(height: 16),
            _ResultRow(
              label: 'TDEE',
              value: '${result.tdee} kcal/day',
              subtitle: 'Total Daily Energy Expenditure',
            ),
            const SizedBox(height: 16),
            _ResultRow(
              label: 'Recommended Calories',
              value: '${result.recommendedCalories} kcal/day',
              subtitle: 'Based on your ${_selectedGoalType.displayName} goal',
              highlight: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/goals/create', extra: result.recommendedCalories);
            },
            child: const Text('Set Goal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TDEE Calculator'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text(
              'Calculate Your Total Daily Energy Expenditure',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enter your information to calculate how many calories you need per day.',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Age
            TextFormField(
              controller: _ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                border: OutlineInputBorder(),
                suffixText: 'years',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final age = int.tryParse(value);
                if (age == null || age <= 0 || age > 120) {
                  return 'Enter valid age (1-120)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Weight
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                labelText: 'Weight',
                border: OutlineInputBorder(),
                suffixText: 'kg',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final weight = double.tryParse(value);
                if (weight == null || weight <= 0 || weight > 500) {
                  return 'Enter valid weight (1-500 kg)';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Height
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(
                labelText: 'Height',
                border: OutlineInputBorder(),
                suffixText: 'cm',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final height = double.tryParse(value);
                if (height == null || height <= 0 || height > 300) {
                  return 'Enter valid height (1-300 cm)';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),

            // Gender
            const Text('Gender', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            SegmentedButton<Gender>(
              segments: const [
                ButtonSegment(value: Gender.male, label: Text('Male')),
                ButtonSegment(value: Gender.female, label: Text('Female')),
              ],
              selected: {_selectedGender},
              onSelectionChanged: (Set<Gender> newSelection) {
                setState(() => _selectedGender = newSelection.first);
              },
            ),
            const SizedBox(height: 24),

            // Activity Level
            const Text('Activity Level', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            DropdownButtonFormField<ActivityLevel>(
              value: _selectedActivityLevel,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ActivityLevel.values.map((level) {
                return DropdownMenuItem(
                  value: level,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(level.displayName),
                      Text(
                        level.description,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedActivityLevel = value);
              },
            ),
            const SizedBox(height: 24),

            // Goal Type
            const Text('Goal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            SegmentedButton<GoalType>(
              segments: GoalType.values.map((goal) {
                return ButtonSegment(
                  value: goal,
                  label: Text(goal.displayName),
                );
              }).toList(),
              selected: {_selectedGoalType},
              onSelectionChanged: (Set<GoalType> newSelection) {
                setState(() => _selectedGoalType = newSelection.first);
              },
            ),
            const SizedBox(height: 32),

            // Calculate Button
            FilledButton(
              onPressed: _isCalculating ? null : _calculateTdee,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: _isCalculating
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Calculate TDEE'),
              ),
            ),

            // Error display removed - errors are handled via boolean return from calculateTdee
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final String subtitle;
  final bool highlight;

  const _ResultRow({
    required this.label,
    required this.value,
    required this.subtitle,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: highlight
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: highlight
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 11,
              color: highlight
                  ? Theme.of(context).colorScheme.onPrimaryContainer.withOpacity(0.8)
                  : Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
