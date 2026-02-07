import 'package:email_validator/email_validator.dart';
import 'package:meal_planner_app/core/constants/app_constants.dart';

/// Form validation utilities
class Validators {
  Validators._();

  /// Validate email address
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    if (!EmailValidator.validate(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  /// Validate password
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < AppConstants.minPasswordLength) {
      return 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }
    if (value.length > AppConstants.maxPasswordLength) {
      return 'Password must be less than ${AppConstants.maxPasswordLength} characters';
    }
    return null;
  }

  /// Validate password confirmation
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != password) {
      return 'Passwords do not match';
    }
    return null;
  }

  /// Validate required field
  static String? required(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }

  /// Validate number within range
  static String? numberInRange(
    String? value,
    String fieldName,
    num min,
    num max,
  ) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = num.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number < min || number > max) {
      return '$fieldName must be between $min and $max';
    }

    return null;
  }

  /// Validate positive number
  static String? positiveNumber(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required';
    }

    final number = num.tryParse(value);
    if (number == null) {
      return 'Please enter a valid number';
    }

    if (number <= 0) {
      return '$fieldName must be greater than 0';
    }

    return null;
  }

  /// Validate meals per day
  static String? mealsPerDay(String? value) {
    return numberInRange(
      value,
      'Meals per day',
      AppConstants.minMealsPerDay,
      AppConstants.maxMealsPerDay,
    );
  }

  /// Validate snacks per day
  static String? snacksPerDay(String? value) {
    return numberInRange(
      value,
      'Snacks per day',
      AppConstants.minSnacksPerDay,
      AppConstants.maxSnacksPerDay,
    );
  }

  /// Validate macro percentage (0-100)
  static String? macroPercentage(String? value, String macroName) {
    return numberInRange(value, macroName, 0, 100);
  }
}
