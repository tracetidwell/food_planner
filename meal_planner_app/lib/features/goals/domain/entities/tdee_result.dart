import 'package:equatable/equatable.dart';

/// TDEE calculation result entity
class TdeeResult extends Equatable {
  final int tdee;
  final int recommendedCalories;
  final int maintenanceCalories;

  const TdeeResult({
    required this.tdee,
    required this.recommendedCalories,
    required this.maintenanceCalories,
  });

  @override
  List<Object> get props => [tdee, recommendedCalories, maintenanceCalories];

  @override
  String toString() => 'TdeeResult(tdee: $tdee, recommended: $recommendedCalories)';
}
