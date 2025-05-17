import 'package:equatable/equatable.dart';

class LinkedInProfile extends Equatable {
  final String profileUrl;
  final String? fullName;
  final String? headline;
  final String? profileImageUrl;
  final String? coverImageUrl;
  final String? aboutSection;
  final List<Skill>? skills;
  final List<Experience>? experiences;
  final List<Education>? education;
  final List<Certification>? certifications;
  final List<Post>? posts;

  const LinkedInProfile({
    required this.profileUrl,
    this.fullName,
    this.headline,
    this.profileImageUrl,
    this.coverImageUrl,
    this.aboutSection,
    this.skills,
    this.experiences,
    this.education,
    this.certifications,
    this.posts,
  });

  // Create an empty profile with just the URL
  factory LinkedInProfile.initial(String profileUrl) {
    return LinkedInProfile(profileUrl: profileUrl);
  }

  // Copy with method for immutability
  LinkedInProfile copyWith({
    String? profileUrl,
    String? fullName,
    String? headline,
    String? profileImageUrl,
    String? coverImageUrl,
    String? aboutSection,
    List<Skill>? skills,
    List<Experience>? experiences,
    List<Education>? education,
    List<Certification>? certifications,
    List<Post>? posts,
  }) {
    return LinkedInProfile(
      profileUrl: profileUrl ?? this.profileUrl,
      fullName: fullName ?? this.fullName,
      headline: headline ?? this.headline,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      coverImageUrl: coverImageUrl ?? this.coverImageUrl,
      aboutSection: aboutSection ?? this.aboutSection,
      skills: skills ?? this.skills,
      experiences: experiences ?? this.experiences,
      education: education ?? this.education,
      certifications: certifications ?? this.certifications,
      posts: posts ?? this.posts,
    );
  }

  // ToJson for serialization
  Map<String, dynamic> toJson() {
    return {
      'profileUrl': profileUrl,
      'fullName': fullName,
      'headline': headline,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'aboutSection': aboutSection,
      'skills': skills?.map((skill) => skill.toJson()).toList(),
      'experiences': experiences?.map((exp) => exp.toJson()).toList(),
      'education': education?.map((edu) => edu.toJson()).toList(),
      'certifications': certifications?.map((cert) => cert.toJson()).toList(),
      'posts': posts?.map((post) => post.toJson()).toList(),
    };
  }

  // FromJson for deserialization
  factory LinkedInProfile.fromJson(Map<String, dynamic> json) {
    return LinkedInProfile(
      profileUrl: json['profileUrl'] as String,
      fullName: json['fullName'] as String?,
      headline: json['headline'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      aboutSection: json['aboutSection'] as String?,
      skills:
          json['skills'] != null
              ? List<Skill>.from(
                (json['skills'] as List).map((x) => Skill.fromJson(x)),
              )
              : null,
      experiences:
          json['experiences'] != null
              ? List<Experience>.from(
                (json['experiences'] as List).map(
                  (x) => Experience.fromJson(x),
                ),
              )
              : null,
      education:
          json['education'] != null
              ? List<Education>.from(
                (json['education'] as List).map((x) => Education.fromJson(x)),
              )
              : null,
      certifications:
          json['certifications'] != null
              ? List<Certification>.from(
                (json['certifications'] as List).map(
                  (x) => Certification.fromJson(x),
                ),
              )
              : null,
      posts:
          json['posts'] != null
              ? List<Post>.from(
                (json['posts'] as List).map((x) => Post.fromJson(x)),
              )
              : null,
    );
  }

  @override
  List<Object?> get props => [
    profileUrl,
    fullName,
    headline,
    profileImageUrl,
    coverImageUrl,
    aboutSection,
    skills,
    experiences,
    education,
    certifications,
    posts,
  ];
}

class Skill extends Equatable {
  final String name;
  final String? endorsementCount;

  const Skill({required this.name, this.endorsementCount});

  Map<String, dynamic> toJson() {
    return {'name': name, 'endorsementCount': endorsementCount};
  }

  factory Skill.fromJson(Map<String, dynamic> json) {
    return Skill(
      name: json['name'] as String,
      endorsementCount: json['endorsementCount'] as String?,
    );
  }

  @override
  List<Object?> get props => [name, endorsementCount];
}

class Experience extends Equatable {
  final String title;
  final String company;
  final String? duration;
  final String? description;
  final String? location;

  const Experience({
    required this.title,
    required this.company,
    this.duration,
    this.description,
    this.location,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'company': company,
      'duration': duration,
      'description': description,
      'location': location,
    };
  }

  factory Experience.fromJson(Map<String, dynamic> json) {
    return Experience(
      title: json['title'] as String,
      company: json['company'] as String,
      duration: json['duration'] as String?,
      description: json['description'] as String?,
      location: json['location'] as String?,
    );
  }

  @override
  List<Object?> get props => [title, company, duration, description, location];
}

class Education extends Equatable {
  final String school;
  final String? degree;
  final String? fieldOfStudy;
  final String? duration;
  final String? description;

  const Education({
    required this.school,
    this.degree,
    this.fieldOfStudy,
    this.duration,
    this.description,
  });

  Map<String, dynamic> toJson() {
    return {
      'school': school,
      'degree': degree,
      'fieldOfStudy': fieldOfStudy,
      'duration': duration,
      'description': description,
    };
  }

  factory Education.fromJson(Map<String, dynamic> json) {
    return Education(
      school: json['school'] as String,
      degree: json['degree'] as String?,
      fieldOfStudy: json['fieldOfStudy'] as String?,
      duration: json['duration'] as String?,
      description: json['description'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    school,
    degree,
    fieldOfStudy,
    duration,
    description,
  ];
}

class Certification extends Equatable {
  final String name;
  final String? organization;
  final String? issueDate;
  final String? expirationDate;
  final String? credentialId;

  const Certification({
    required this.name,
    this.organization,
    this.issueDate,
    this.expirationDate,
    this.credentialId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'organization': organization,
      'issueDate': issueDate,
      'expirationDate': expirationDate,
      'credentialId': credentialId,
    };
  }

  factory Certification.fromJson(Map<String, dynamic> json) {
    return Certification(
      name: json['name'] as String,
      organization: json['organization'] as String?,
      issueDate: json['issueDate'] as String?,
      expirationDate: json['expirationDate'] as String?,
      credentialId: json['credentialId'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    name,
    organization,
    issueDate,
    expirationDate,
    credentialId,
  ];
}

class Post extends Equatable {
  final String content;
  final String? date;
  final int? likes;
  final int? comments;
  final int? shares;

  const Post({
    required this.content,
    this.date,
    this.likes,
    this.comments,
    this.shares,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'date': date,
      'likes': likes,
      'comments': comments,
      'shares': shares,
    };
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      content: json['content'] as String,
      date: json['date'] as String?,
      likes: json['likes'] as int?,
      comments: json['comments'] as int?,
      shares: json['shares'] as int?,
    );
  }

  @override
  List<Object?> get props => [content, date, likes, comments, shares];
}
