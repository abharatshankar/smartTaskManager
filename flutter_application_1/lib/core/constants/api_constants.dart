class ApiConstants {
  ApiConstants._();

  /// Android emulator: http://10.0.2.2:5000
  /// iOS simulator: http://127.0.0.1:5000
  /// Real device: your LAN IP (example: http://192.168.1.10:5000)
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:5000',
  );

  static const String loginPath = '/api/auth/login';
  static const String registerPath = '/api/auth/register';
  static const String logoutPath = '/api/auth/logout';
  static const String mePath = '/api/auth/me';
  static const String tasksPath = '/api/tasks';
  static const String analyticsPath = '/api/analytics';
}
