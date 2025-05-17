class AppConstants {
  // App info
  static const String appName = 'LinkedIn Spark';
  static const String appTagline = 'Boost Your LinkedIn Personal Branding';

  // Routes
  static const String routeOnboarding = '/onboarding';
  static const String routeWelcome = '/welcome';
  static const String routePermissions = '/permissions';
  static const String routeProfileInput = '/profile-input';
  static const String routeAnalysis = '/analysis';
  static const String routeDashboard = '/dashboard';

  // API and Auth
  static const String linkedInApiBaseUrl = 'https://api.linkedin.com/v2';
  static const String linkedInAuthUrl =
      'https://www.linkedin.com/oauth/v2/authorization';

  // Storage keys
  static const String keyAccessToken = 'access_token';
  static const String keyUserProfile = 'user_profile';

  // LinkedIn validator
  static final RegExp linkedInUrlRegex = RegExp(
    r'^(https?:\/\/)?(www\.)?linkedin\.com\/in\/[a-zA-Z0-9_-]+\/?$',
    caseSensitive: false,
  );
}
