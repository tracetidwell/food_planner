import 'package:intl/intl.dart';
import 'package:meal_planner_app/core/constants/app_constants.dart';

/// Extension methods for DateTime
extension DateTimeExtension on DateTime {
  /// Format date for API (yyyy-MM-dd)
  String toApiFormat() {
    return DateFormat(AppConstants.apiDateFormat).format(this);
  }

  /// Format date for display (EEEE, MMMM d, y)
  String toDisplayFormat() {
    return DateFormat(AppConstants.displayDateFormat).format(this);
  }

  /// Format date for short display (MMM d, y)
  String toShortFormat() {
    return DateFormat(AppConstants.shortDateFormat).format(this);
  }

  /// Check if date is today
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Check if date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Get date without time
  DateTime get dateOnly {
    return DateTime(year, month, day);
  }
}

/// Extension methods for String
extension StringExtension on String {
  /// Capitalize first letter
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Convert string to title case
  String toTitleCase() {
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Parse API date string (yyyy-MM-dd) to DateTime
  DateTime? toApiDate() {
    try {
      return DateFormat(AppConstants.apiDateFormat).parse(this);
    } catch (e) {
      return null;
    }
  }
}

/// Extension methods for num
extension NumExtension on num {
  /// Format as calories (no decimals)
  String toCalories() {
    return '${toInt()} cal';
  }

  /// Format as grams (1 decimal)
  String toGrams() {
    return '${toStringAsFixed(1)}g';
  }

  /// Format as percentage
  String toPercentage() {
    return '${toInt()}%';
  }
}

/// Extension methods for List
extension ListExtension<T> on List<T> {
  /// Get first element or null
  T? get firstOrNull {
    return isEmpty ? null : first;
  }

  /// Get last element or null
  T? get lastOrNull {
    return isEmpty ? null : last;
  }
}
