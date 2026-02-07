import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:meal_planner_app/core/constants/enums.dart';
import 'package:meal_planner_app/features/goals/presentation/providers/goals_provider.dart';

class CreateGoalScreen extends ConsumerStatefulWidget {
  final int? suggestedCalories;

  const CreateGoalScreen({super.key, this.suggestedCalories});

  @override
  ConsumerState<CreateGoalScreen> createState() => _CreateGoalScreenState();
}

class _CreateGoalScreenState extends ConsumerState<CreateGoalScreen> {
  final _formKey = GlobalKey<FormState>();
  final _caloriesController = TextEditingController();
  final _proteinController = TextEditingController();
  final _carbController = TextEditingController();
  final _fatController = TextEditingController();

  MacroFormat _macroFormat = MacroFormat.percentage;

  @override
  void initState() {
    super.initState();
    if (widget.suggestedCalories != null) {
      _caloriesController.text = widget.suggestedCalories.toString();
    }
    // Set default values
    _proteinController.text = '30';
    _carbController.text = '40';
    _fatController.text = '30';
  }

  @override
  void dispose() {
    _caloriesController.dispose();
    _proteinController.dispose();
    _carbController.dispose();
    _fatController.dispose();
    super.dispose();
  }

  double get _proteinValue => double.tryParse(_proteinController.text) ?? 0;
  double get _carbValue => double.tryParse(_carbController.text) ?? 0;
  double get _fatValue => double.tryParse(_fatController.text) ?? 0;

  double get _totalPercentage => _proteinValue + _carbValue + _fatValue;

  bool get _isValidPercentage => (_totalPercentage - 100).abs() < 0.1;

  int _calculateCaloriesFromMacros() {
    if (_macroFormat == MacroFormat.absolute) {
      // Calculate calories from grams
      final proteinCals = _proteinValue * 4;
      final carbCals = _carbValue * 4;
      final fatCals = _fatValue * 9;
      return (proteinCals + carbCals + fatCals).round();
    }
    // In percentage mode, return the target calories
    return int.tryParse(_caloriesController.text) ?? 0;
  }

  int _calculateGrams(double value, String macro) {
    final calories = int.tryParse(_caloriesController.text) ?? 2000;
    if (_macroFormat == MacroFormat.percentage) {
      // Protein and Carbs: 4 cal/g, Fat: 9 cal/g
      if (macro == 'fat') {
        return ((calories * value / 100) / 9).round();
      } else {
        return ((calories * value / 100) / 4).round();
      }
    }
    return value.round();
  }

  void _saveGoal() async {
    if (!_formKey.currentState!.validate()) return;

    if (_macroFormat == MacroFormat.percentage && !_isValidPercentage) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Macro percentages must add up to 100%')),
      );
      return;
    }

    final calories = int.parse(_caloriesController.text);

    final success = await ref.read(goalsProvider.notifier).createGoal(
          macroFormat: _macroFormat,
          proteinTarget: _proteinValue,
          carbTarget: _carbValue,
          fatTarget: _fatValue,
          calorieTarget: calories,
        );

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal saved successfully!')),
      );
      context.go('/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final goalsState = ref.watch(goalsProvider);
    final calculatedCalories = _calculateCaloriesFromMacros();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Set Nutrition Goal'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Calorie Target
            const Text(
              'Daily Calorie Target',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _caloriesController,
              decoration: const InputDecoration(
                labelText: 'Target Calories',
                border: OutlineInputBorder(),
                suffixText: 'kcal/day',
                helperText: 'Your daily calorie goal',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              validator: (value) {
                if (value == null || value.isEmpty) return 'Required';
                final calories = int.tryParse(value);
                if (calories == null || calories <= 0) {
                  return 'Enter valid calorie target';
                }
                return null;
              },
              onChanged: (_) => setState(() {}), // Update calculations
            ),
            const SizedBox(height: 24),

            // Macro Format Toggle
            const Text(
              'Macro Format',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SegmentedButton<MacroFormat>(
              segments: const [
                ButtonSegment(
                  value: MacroFormat.percentage,
                  label: Text('Percentage'),
                  icon: Icon(Icons.percent),
                ),
                ButtonSegment(
                  value: MacroFormat.absolute,
                  label: Text('Grams'),
                  icon: Icon(Icons.fitness_center),
                ),
              ],
              selected: {_macroFormat},
              onSelectionChanged: (Set<MacroFormat> newSelection) {
                setState(() => _macroFormat = newSelection.first);
              },
            ),
            const SizedBox(height: 24),

            // Macros Section
            const Text(
              'Macronutrient Targets',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            // Protein Input
            _MacroInputField(
              label: 'Protein',
              controller: _proteinController,
              color: Colors.red,
              format: _macroFormat,
              grams: _calculateGrams(_proteinValue, 'protein'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Carbs Input
            _MacroInputField(
              label: 'Carbohydrates',
              controller: _carbController,
              color: Colors.blue,
              format: _macroFormat,
              grams: _calculateGrams(_carbValue, 'carb'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Fat Input
            _MacroInputField(
              label: 'Fat',
              controller: _fatController,
              color: Colors.orange,
              format: _macroFormat,
              grams: _calculateGrams(_fatValue, 'fat'),
              onChanged: (_) => setState(() {}),
            ),
            const SizedBox(height: 16),

            // Calculated Calories Display (for grams mode)
            if (_macroFormat == MacroFormat.absolute) ...[
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Calculated Total Calories',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                      Text(
                        '$calculatedCalories kcal',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],

            // Percentage Warning/Summary
            if (_macroFormat == MacroFormat.percentage) ...[
              Card(
                color: _isValidPercentage
                    ? Theme.of(context).colorScheme.primaryContainer
                    : Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        _isValidPercentage ? Icons.check_circle : Icons.warning,
                        color: _isValidPercentage
                            ? Theme.of(context).colorScheme.onPrimaryContainer
                            : Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _isValidPercentage
                              ? 'Total: ${_totalPercentage.toStringAsFixed(0)}% ✓'
                              : 'Total: ${_totalPercentage.toStringAsFixed(0)}% (must equal 100%)',
                          style: TextStyle(
                            color: _isValidPercentage
                                ? Theme.of(context).colorScheme.onPrimaryContainer
                                : Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Macro Summary
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Daily Breakdown',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    _MacroSummaryRow(
                      label: 'Protein',
                      grams: _calculateGrams(_proteinValue, 'protein'),
                      percentage: _proteinValue,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 8),
                    _MacroSummaryRow(
                      label: 'Carbs',
                      grams: _calculateGrams(_carbValue, 'carb'),
                      percentage: _carbValue,
                      color: Colors.blue,
                    ),
                    const SizedBox(height: 8),
                    _MacroSummaryRow(
                      label: 'Fat',
                      grams: _calculateGrams(_fatValue, 'fat'),
                      percentage: _fatValue,
                      color: Colors.orange,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Save Button
            FilledButton(
              onPressed: goalsState.isLoading ? null : _saveGoal,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: goalsState.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save Goal'),
              ),
            ),

            // Error Display
            if (goalsState.hasError) ...[
              const SizedBox(height: 16),
              Card(
                color: Theme.of(context).colorScheme.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    goalsState.error.toString(),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MacroInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final Color color;
  final MacroFormat format;
  final int grams;
  final ValueChanged<String> onChanged;

  const _MacroInputField({
    required this.label,
    required this.controller,
    required this.color,
    required this.format,
    required this.grams,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        suffixText: format == MacroFormat.percentage ? '%' : 'g',
        helperText: format == MacroFormat.percentage
            ? '$grams g per day'
            : null,
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
      ),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,1}')),
      ],
      validator: (value) {
        if (value == null || value.isEmpty) return 'Required';
        final num = double.tryParse(value);
        if (num == null || num < 0) {
          return 'Enter valid number';
        }
        if (format == MacroFormat.percentage && num > 100) {
          return 'Cannot exceed 100%';
        }
        return null;
      },
      onChanged: onChanged,
    );
  }
}

class _MacroSummaryRow extends StatelessWidget {
  final String label;
  final int grams;
  final double percentage;
  final Color color;

  const _MacroSummaryRow({
    required this.label,
    required this.grams,
    required this.percentage,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label),
        ),
        Text(
          '$grams g',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(width: 16),
        Text(
          '${percentage.toStringAsFixed(0)}%',
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    );
  }
}
