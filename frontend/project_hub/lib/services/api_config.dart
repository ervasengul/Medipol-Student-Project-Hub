/// API Configuration
/// Contains base URLs and API endpoints configuration
class ApiConfig {
  // Base URL - change this to match your backend server
  // For Android emulator: use 10.0.2.2
  // For iOS simulator: use localhost
  // For physical device: use your computer's local IP address
  static const String baseUrl = 'http://localhost:8000';

  // Alternative URLs for different environments
  static const String androidEmulatorUrl = 'http://10.0.2.2:8000';
  static const String productionUrl = 'https://your-production-url.com';

  // API Endpoints
  static const String apiPrefix = '/api';

  // Auth endpoints (backend: /api/auth/...)
  static const String loginEndpoint = '$apiPrefix/auth/login/';
  static const String registerStudentEndpoint = '$apiPrefix/auth/register/student/';
  static const String registerFacultyEndpoint = '$apiPrefix/auth/register/faculty/';
  static const String refreshTokenEndpoint = '$apiPrefix/auth/refresh/';
  static const String logoutEndpoint = '$apiPrefix/auth/logout/';
  static const String profileEndpoint = '$apiPrefix/auth/profile/';
  static const String changePasswordEndpoint = '$apiPrefix/auth/change-password/';

  // Users endpoints
  static const String usersEndpoint = '$apiPrefix/users/';

  // Projects endpoints (backend: /api/projects/...)
  static const String projectsEndpoint = '$apiPrefix/projects/';
  static const String joinRequestsEndpoint = '$apiPrefix/requests/';
  static const String milestonesEndpoint = '$apiPrefix/milestones/';

  // Teams endpoints (backend: /api/teams/...)
  static const String teamsEndpoint = '$apiPrefix/teams/';

  // Messaging endpoints (backend: /api/messaging/...)
  static const String conversationsEndpoint = '$apiPrefix/messaging/conversations/';
  static const String messagesEndpoint = '$apiPrefix/messaging/messages/';

  // Request timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  /// Get base URL based on platform / build-time define.
  /// You can override with:
  /// flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:8000
  static String getBaseUrl() {
    const defined = String.fromEnvironment('API_BASE_URL', defaultValue: '');
    if (defined.isNotEmpty) return defined;
    return baseUrl;
  }
}
