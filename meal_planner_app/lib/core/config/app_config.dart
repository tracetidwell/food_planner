/// Application configuration with environment-specific settings
class AppConfig {
  /// Base URL for the API
  ///
  /// Development: Uses Android emulator localhost (10.0.2.2)
  /// iOS simulator uses localhost:8000
  /// Physical devices should use your computer's IP address
  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  /// Whether the app is running in production mode
  static const bool isProduction = bool.fromEnvironment('PRODUCTION');

  /// Debug mode flag
  static const bool debug = !isProduction;

  /// API timeout duration
  static const Duration apiTimeout = Duration(seconds: 30);

  /// Cache expiration duration
  static const Duration cacheExpiration = Duration(hours: 24);
}
