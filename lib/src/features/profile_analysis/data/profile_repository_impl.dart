import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:linkedinspark/src/core/constants/app_constants.dart';
import 'package:linkedinspark/src/features/profile_analysis/domain/linkedin_profile.dart';
import 'package:linkedinspark/src/features/profile_analysis/domain/profile_recommendation.dart';
import 'package:linkedinspark/src/features/profile_analysis/domain/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final Dio _dio;
  final SharedPreferences _prefs;

  // Mock data flag for development
  final bool _useMockData;

  ProfileRepositoryImpl({
    required Dio dio,
    required SharedPreferences prefs,
    bool useMockData = true, // Use mock data by default during development
  }) : _dio = dio,
       _prefs = prefs,
       _useMockData = useMockData;

  @override
  Future<LinkedInProfile> fetchProfileFromUrl(String profileUrl) async {
    if (_useMockData) {
      // Return mock data for development
      return _getMockProfile(profileUrl);
    }

    try {
      // In a real app, this would be the API call to your backend that does the scraping
      final response = await _dio.get(
        'YOUR_BACKEND_API_ENDPOINT',
        queryParameters: {'profileUrl': profileUrl},
      );

      if (response.statusCode == 200) {
        return LinkedInProfile.fromJson(response.data);
      } else {
        throw Exception('Failed to fetch profile data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching profile data: $e');
    }
  }

  @override
  Future<ProfileRecommendation> generateRecommendations(
    LinkedInProfile profile,
  ) async {
    if (_useMockData) {
      // Return mock recommendations for development
      return _getMockRecommendations();
    }

    try {
      // In a real app, this would call your backend API or an AI model
      final response = await _dio.post(
        'YOUR_BACKEND_API_ENDPOINT/recommendations',
        data: profile.toJson(),
      );

      if (response.statusCode == 200) {
        return ProfileRecommendation.fromJson(response.data);
      } else {
        throw Exception(
          'Failed to generate recommendations: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Error generating recommendations: $e');
    }
  }

  @override
  Future<void> saveProfile(LinkedInProfile profile) async {
    try {
      final profileJson = jsonEncode(profile.toJson());
      await _prefs.setString(AppConstants.keyUserProfile, profileJson);
    } catch (e) {
      throw Exception('Error saving profile: $e');
    }
  }

  @override
  Future<void> saveRecommendations(
    ProfileRecommendation recommendations,
  ) async {
    try {
      final recommendationsJson = jsonEncode(recommendations.toJson());
      await _prefs.setString('user_recommendations', recommendationsJson);
    } catch (e) {
      throw Exception('Error saving recommendations: $e');
    }
  }

  @override
  Future<LinkedInProfile?> getSavedProfile() async {
    try {
      final profileJson = _prefs.getString(AppConstants.keyUserProfile);
      if (profileJson != null) {
        return LinkedInProfile.fromJson(jsonDecode(profileJson));
      }
      return null;
    } catch (e) {
      throw Exception('Error getting saved profile: $e');
    }
  }

  @override
  Future<ProfileRecommendation?> getSavedRecommendations() async {
    try {
      final recommendationsJson = _prefs.getString('user_recommendations');
      if (recommendationsJson != null) {
        return ProfileRecommendation.fromJson(jsonDecode(recommendationsJson));
      }
      return null;
    } catch (e) {
      throw Exception('Error getting saved recommendations: $e');
    }
  }

  @override
  bool isValidLinkedInUrl(String url) {
    return AppConstants.linkedInUrlRegex.hasMatch(url);
  }

  // Mock data methods for development
  LinkedInProfile _getMockProfile(String profileUrl) {
    // Simulate network delay
    return LinkedInProfile(
      profileUrl: profileUrl,
      fullName: 'Alex Johnson',
      headline:
          'Senior Software Engineer at TechCorp | Mobile Development | Flutter',
      profileImageUrl: 'https://randomuser.me/api/portraits/men/32.jpg',
      coverImageUrl:
          'https://images.unsplash.com/photo-1579546929662-711aa81148cf',
      aboutSection:
          'Passionate software engineer with 5+ years of experience in mobile app development. Expertise in Flutter, React Native, and native Android/iOS development. Strong problem-solving skills and a knack for creating beautiful, performant mobile experiences.',
      skills: [
        Skill(name: 'Flutter', endorsementCount: '27'),
        Skill(name: 'Dart', endorsementCount: '23'),
        Skill(name: 'Mobile App Development', endorsementCount: '31'),
        Skill(name: 'React Native', endorsementCount: '18'),
        Skill(name: 'JavaScript', endorsementCount: '15'),
      ],
      experiences: [
        Experience(
          title: 'Senior Software Engineer',
          company: 'TechCorp',
          duration: 'Jan 2020 - Present',
          location: 'San Francisco, CA',
          description:
              'Leading mobile app development using Flutter. Responsible for architecture design, performance optimization, and mentoring junior developers.',
        ),
        Experience(
          title: 'Mobile Developer',
          company: 'MobileInnovations',
          duration: 'Mar 2018 - Dec 2019',
          location: 'New York, NY',
          description:
              'Developed cross-platform mobile applications using React Native. Implemented clean architecture patterns and unit testing practices.',
        ),
      ],
      education: [
        Education(
          school: 'University of Technology',
          degree: 'Bachelor of Science',
          fieldOfStudy: 'Computer Science',
          duration: '2014 - 2018',
        ),
      ],
      certifications: [
        Certification(
          name: 'Google Associate Android Developer',
          organization: 'Google',
          issueDate: 'Jan 2019',
        ),
      ],
      posts: [
        Post(
          content:
              'Just published my new article on Flutter state management patterns. Check it out!',
          date: '2 weeks ago',
          likes: 48,
          comments: 13,
          shares: 7,
        ),
        Post(
          content:
              'Excited to announce that our app reached 100k downloads on the App Store! #MobileApp #Success',
          date: '1 month ago',
          likes: 124,
          comments: 32,
          shares: 18,
        ),
      ],
    );
  }

  ProfileRecommendation _getMockRecommendations() {
    return ProfileRecommendation(
      generatedAt: DateTime.now(),
      headline:
          'Flutter Developer | Mobile App Specialist | Creating Beautiful, High-Performance Mobile Experiences | 5+ Years in Cross-Platform Development',
      aboutSection:
          'I am a passionate mobile developer with over 5 years of experience crafting elegant, user-centric applications that solve real-world problems. My expertise spans Flutter, React Native, and native Android/iOS development, with a focus on creating smooth, responsive user experiences.\n\nAs a Senior Software Engineer at TechCorp, I lead the development of enterprise-grade mobile solutions that serve thousands of users daily. My approach combines technical excellence with a deep understanding of user needs, ensuring that every app I build not only functions flawlessly but also delights its users.\n\nIm particularly skilled in:\n• Architecting complex mobile applications using clean architecture principles\n• Optimizing performance for smooth animations and transitions\n• Implementing robust state management solutions\n• Creating beautiful, intuitive UIs that follow platform design guidelines\n• Mentoring junior developers and fostering team growth\n\nIm always eager to connect with fellow developers, potential clients, and anyone passionate about mobile technology. Let\'s chat about how we can create amazing mobile experiences together!',
      missingSkills: [
        'UI/UX Design',
        'Firebase',
        'GitHub Actions',
        'CI/CD',
        'App Store Optimization',
      ],
      missingEducation: [
        'Consider adding any relevant certifications or courses in UI/UX design',
        'Add details about any Flutter-specific training or workshops attended',
      ],
      missingExperience: [
        'Consider adding volunteer experience or mentorship roles to showcase leadership',
        'Add information about any freelance or side projects to demonstrate versatility',
      ],
      profilePictureAdvice:
          'Your current profile picture is good, but consider updating to a professional headshot with a neutral background. Dress professionally and ensure good lighting for the best impression.',
      coverPhotoAdvice:
          'Your cover photo is generic. Consider using an image related to your field, such as a clean code snippet, app interface you have designed, or a photo from a tech conference you have attended.',
      postingStyleAdvice:
          'Your posts receive good engagement, but try to post more consistently (aim for 1-2 times per week). Include more technical insights, code snippets, and lessons learned from your projects. Use relevant hashtags to increase visibility.',
      generalRecommendations: [
        'Complete the "Featured" section with your best projects or articles',
        'Request recommendations from colleagues and supervisors',
        'Join and engage with Flutter and mobile development groups',
        'Comment thoughtfully on posts in your field to increase visibility',
        'Consider publishing articles on LinkedIn about mobile development best practices',
      ],
    );
  }
}
