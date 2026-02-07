import 'package:flutter/material.dart';

/// Widget to display macronutrient information
class MacroDisplay extends StatelessWidget {
  final double protein;
  final double carbs;
  final double fat;
  final int calories;
  final bool showLabels;

  const MacroDisplay({
    super.key,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.calories,
    this.showLabels = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _MacroItem(
          label: 'Protein',
          value: protein.toStringAsFixed(0),
          unit: 'g',
          color: Colors.red,
          showLabel: showLabels,
        ),
        _MacroItem(
          label: 'Carbs',
          value: carbs.toStringAsFixed(0),
          unit: 'g',
          color: Colors.blue,
          showLabel: showLabels,
        ),
        _MacroItem(
          label: 'Fat',
          value: fat.toStringAsFixed(0),
          unit: 'g',
          color: Colors.orange,
          showLabel: showLabels,
        ),
        _MacroItem(
          label: 'Calories',
          value: calories.toString(),
          unit: 'kcal',
          color: Colors.purple,
          showLabel: showLabels,
        ),
      ],
    );
  }
}

class _MacroItem extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final Color color;
  final bool showLabel;

  const _MacroItem({
    required this.label,
    required this.value,
    required this.unit,
    required this.color,
    required this.showLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showLabel)
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
              fontWeight: FontWeight.w500,
            ),
          ),
        if (showLabel) const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          unit,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
