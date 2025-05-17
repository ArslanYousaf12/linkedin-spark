import 'package:equatable/equatable.dart';

class ProfileRecommendation extends Equatable {
  final String? headline;
  final String? aboutSection;
  final List<String>? missingSkills;
  final List<String>? missingEducation;
  final List<String>? missingExperience;
  final List<String>? missingCertifications;
  final String? profilePictureAdvice;
  final String? coverPhotoAdvice;
  final String? postingStyleAdvice;
  final List<String>? generalRecommendations;
  final DateTime generatedAt;

  const ProfileRecommendation({
    this.headline,
    this.aboutSection,
    this.missingSkills,
    this.missingEducation,
    this.missingExperience,
    this.missingCertifications,
    this.profilePictureAdvice,
    this.coverPhotoAdvice,
    this.postingStyleAdvice,
    this.generalRecommendations,
    required this.generatedAt,
  });

  // Empty recommendation
  factory ProfileRecommendation.empty() {
    return ProfileRecommendation(generatedAt: DateTime.now());
  }

  // Copy with method for immutability
  ProfileRecommendation copyWith({
    String? headline,
    String? aboutSection,
    List<String>? missingSkills,
    List<String>? missingEducation,
    List<String>? missingExperience,
    List<String>? missingCertifications,
    String? profilePictureAdvice,
    String? coverPhotoAdvice,
    String? postingStyleAdvice,
    List<String>? generalRecommendations,
    DateTime? generatedAt,
  }) {
    return ProfileRecommendation(
      headline: headline ?? this.headline,
      aboutSection: aboutSection ?? this.aboutSection,
      missingSkills: missingSkills ?? this.missingSkills,
      missingEducation: missingEducation ?? this.missingEducation,
      missingExperience: missingExperience ?? this.missingExperience,
      missingCertifications:
          missingCertifications ?? this.missingCertifications,
      profilePictureAdvice: profilePictureAdvice ?? this.profilePictureAdvice,
      coverPhotoAdvice: coverPhotoAdvice ?? this.coverPhotoAdvice,
      postingStyleAdvice: postingStyleAdvice ?? this.postingStyleAdvice,
      generalRecommendations:
          generalRecommendations ?? this.generalRecommendations,
      generatedAt: generatedAt ?? this.generatedAt,
    );
  }

  // ToJson for serialization
  Map<String, dynamic> toJson() {
    return {
      'headline': headline,
      'aboutSection': aboutSection,
      'missingSkills': missingSkills,
      'missingEducation': missingEducation,
      'missingExperience': missingExperience,
      'missingCertifications': missingCertifications,
      'profilePictureAdvice': profilePictureAdvice,
      'coverPhotoAdvice': coverPhotoAdvice,
      'postingStyleAdvice': postingStyleAdvice,
      'generalRecommendations': generalRecommendations,
      'generatedAt': generatedAt.toIso8601String(),
    };
  }

  // FromJson for deserialization
  factory ProfileRecommendation.fromJson(Map<String, dynamic> json) {
    return ProfileRecommendation(
      headline: json['headline'] as String?,
      aboutSection: json['aboutSection'] as String?,
      missingSkills:
          json['missingSkills'] != null
              ? List<String>.from(json['missingSkills'] as List)
              : null,
      missingEducation:
          json['missingEducation'] != null
              ? List<String>.from(json['missingEducation'] as List)
              : null,
      missingExperience:
          json['missingExperience'] != null
              ? List<String>.from(json['missingExperience'] as List)
              : null,
      missingCertifications:
          json['missingCertifications'] != null
              ? List<String>.from(json['missingCertifications'] as List)
              : null,
      profilePictureAdvice: json['profilePictureAdvice'] as String?,
      coverPhotoAdvice: json['coverPhotoAdvice'] as String?,
      postingStyleAdvice: json['postingStyleAdvice'] as String?,
      generalRecommendations:
          json['generalRecommendations'] != null
              ? List<String>.from(json['generalRecommendations'] as List)
              : null,
      generatedAt: DateTime.parse(json['generatedAt'] as String),
    );
  }

  @override
  List<Object?> get props => [
    headline,
    aboutSection,
    missingSkills,
    missingEducation,
    missingExperience,
    missingCertifications,
    profilePictureAdvice,
    coverPhotoAdvice,
    postingStyleAdvice,
    generalRecommendations,
    generatedAt,
  ];
}
