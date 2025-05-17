import 'package:linkedinspark/src/features/profile_analysis/domain/linkedin_profile.dart';
import 'package:linkedinspark/src/features/profile_analysis/domain/profile_recommendation.dart';

abstract class ProfileRepository {
  /// Fetch profile data from LinkedIn URL
  Future<LinkedInProfile> fetchProfileFromUrl(String profileUrl);

  /// Generate recommendations based on profile data
  Future<ProfileRecommendation> generateRecommendations(
    LinkedInProfile profile,
  );

  /// Save profile data for future reference
  Future<void> saveProfile(LinkedInProfile profile);

  /// Save generated recommendations
  Future<void> saveRecommendations(ProfileRecommendation recommendations);

  /// Get saved profile if available
  Future<LinkedInProfile?> getSavedProfile();

  /// Get saved recommendations if available
  Future<ProfileRecommendation?> getSavedRecommendations();

  /// Check if the URL is a valid LinkedIn profile URL
  bool isValidLinkedInUrl(String url);
}
