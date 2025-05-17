import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/animations.dart';
import '../../../core/widgets/primary_button.dart';
import '../domain/linkedin_profile.dart';
import '../domain/profile_recommendation.dart';
import 'bloc/profile_bloc.dart';
import 'widgets/action_card.dart';
import 'widgets/progress_section.dart';
import 'widgets/quick_stat_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is RecommendationsLoadSuccess) {
          return _buildDashboard(context, state.profile, state.recommendations);
        } else if (state is ProfileLoadSuccess) {
          // If only profile is loaded but not recommendations yet
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  const Text('Analyzing your profile...'),
                  const SizedBox(height: 32),
                  PrimaryButton(
                    text: 'Generate Recommendations',
                    onPressed: () {
                      context.read<ProfileBloc>().add(
                        const RecommendationsRequested(),
                      );
                    },
                    width: 250,
                  ),
                ],
              ),
            ),
          );
        } else {
          // Default or error state
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('No profile loaded'),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Go to Profile Input',
                    onPressed: () {
                      context.go(AppConstants.routeProfileInput);
                    },
                    width: 200,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    LinkedInProfile profile,
    ProfileRecommendation recommendations,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final completenessScore = _calculateProfileCompleteness(profile);
    final sectionsNeedingImprovement = _getSectionsNeedingImprovement(
      recommendations,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              // Implement theme toggle
            },
            tooltip: 'Toggle theme',
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
            tooltip: 'Settings',
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // Refresh profile data
            context.read<ProfileBloc>().add(const ProfileFetchRequested());
            context.read<ProfileBloc>().add(const RecommendationsRequested());
          },
          child: SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  _buildProfileHeader(context, profile),

                  const SizedBox(height: 24),

                  // Completeness score
                  SlideAnimation(
                    beginOffset: const Offset(0, 20),
                    child: _buildCompletenessScore(context, completenessScore),
                  ),

                  const SizedBox(height: 32),

                  // Quick stats
                  SlideAnimation(
                    beginOffset: const Offset(0, 20),
                    delay: const Duration(milliseconds: 100),
                    child: _buildQuickStats(
                      context,
                      sectionsNeedingImprovement.length,
                      recommendations,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Section progress
                  SlideAnimation(
                    beginOffset: const Offset(0, 20),
                    delay: const Duration(milliseconds: 200),
                    child: Text(
                      'Section Analysis',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Section progress bars
                  ..._buildSectionProgress(context, profile, recommendations),

                  const SizedBox(height: 32),

                  // Action cards
                  SlideAnimation(
                    beginOffset: const Offset(0, 20),
                    delay: const Duration(milliseconds: 300),
                    child: Text(
                      'Recommended Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ..._buildActionCards(context, sectionsNeedingImprovement),

                  const SizedBox(height: 16),

                  // View all button
                  SlideAnimation(
                    beginOffset: const Offset(0, 20),
                    delay: const Duration(milliseconds: 400),
                    child: Align(
                      alignment: Alignment.center,
                      child: TextButton.icon(
                        onPressed: () {
                          // Navigate to full recommendations screen
                        },
                        icon: const Icon(Icons.list_alt),
                        label: const Text('View All Recommendations'),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_quote),
            label: 'Rewrite',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.trending_up),
            label: 'Progress',
          ),
        ],
        onTap: (index) {
          // Handle navigation
        },
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, LinkedInProfile profile) {
    return SlideAnimation(
      beginOffset: const Offset(0, 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage:
                profile.profileImageUrl != null
                    ? NetworkImage(profile.profileImageUrl!)
                    : null,
            child:
                profile.profileImageUrl == null
                    ? const Icon(Icons.person, size: 30)
                    : null,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile.fullName ?? 'LinkedIn User',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  profile.headline ?? 'No headline',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompletenessScore(BuildContext context, int score) {
    final color =
        score < 50
            ? Colors.red
            : score < 80
            ? Colors.orange
            : Colors.green;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            height: 80,
            width: 80,
            child: Stack(
              children: [
                Center(
                  child: SizedBox(
                    height: 80,
                    width: 80,
                    child: CircularProgressIndicator(
                      value: score / 100,
                      strokeWidth: 8,
                      backgroundColor: Colors.grey.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    '$score%',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Completeness',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  score < 50
                      ? 'Your profile needs significant improvement'
                      : score < 80
                      ? 'Your profile is good, but could be better'
                      : 'Your profile is excellent!',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(
    BuildContext context,
    int sectionsNeedingImprovement,
    ProfileRecommendation recommendations,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: QuickStatCard(
                icon: Icons.warning_amber_outlined,
                title: '$sectionsNeedingImprovement sections',
                subtitle: 'need improvement',
                color: Colors.orange,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: QuickStatCard(
                icon: Icons.text_fields,
                title: '30% weaker',
                subtitle: 'headline than top profiles',
                color: Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<Widget> _buildSectionProgress(
    BuildContext context,
    LinkedInProfile profile,
    ProfileRecommendation recommendations,
  ) {
    return [
      // Headline
      ProgressSection(
        title: 'Headline',
        progress: _calculateHeadlineScore(profile.headline),
        icon: Icons.text_fields,
        onTap: () {
          // Navigate to headline detail
        },
      ),

      const SizedBox(height: 12),

      // About
      ProgressSection(
        title: 'About Section',
        progress: _calculateAboutScore(profile.aboutSection),
        icon: Icons.description,
        onTap: () {
          // Navigate to about detail
        },
      ),

      const SizedBox(height: 12),

      // Experience
      ProgressSection(
        title: 'Experience',
        progress: _calculateExperienceScore(profile.experiences),
        icon: Icons.work,
        onTap: () {
          // Navigate to experience detail
        },
      ),

      const SizedBox(height: 12),

      // Education
      ProgressSection(
        title: 'Education',
        progress: _calculateEducationScore(profile.education),
        icon: Icons.school,
        onTap: () {
          // Navigate to education detail
        },
      ),

      const SizedBox(height: 12),

      // Skills
      ProgressSection(
        title: 'Skills & Endorsements',
        progress: _calculateSkillsScore(profile.skills),
        icon: Icons.psychology,
        onTap: () {
          // Navigate to skills detail
        },
      ),

      const SizedBox(height: 12),

      // Profile Photo
      ProgressSection(
        title: 'Profile & Cover Photos',
        progress: _calculatePhotoScore(profile),
        icon: Icons.image,
        onTap: () {
          // Navigate to photo detail
        },
      ),
    ];
  }

  List<Widget> _buildActionCards(
    BuildContext context,
    List<String> sectionsNeedingImprovement,
  ) {
    // Build only 3 action cards for dashboard
    final limitedActions = sectionsNeedingImprovement.take(3).toList();

    return limitedActions.map((section) {
      IconData icon;
      String title;
      String description;
      Color color;

      switch (section) {
        case 'headline':
          icon = Icons.text_fields;
          title = 'Improve Your Headline';
          description = 'Add industry keywords to increase profile visibility';
          color = Colors.blue;
          break;
        case 'about':
          icon = Icons.description;
          title = 'Optimize About Section';
          description =
              'Tell your professional story with a compelling narrative';
          color = Colors.purple;
          break;
        case 'education':
          icon = Icons.school;
          title = 'Add Education';
          description = 'Include your educational background for credibility';
          color = Colors.green;
          break;
        case 'experience':
          icon = Icons.work;
          title = 'Enhance Experience';
          description = 'Add metrics and results to showcase impact';
          color = Colors.orange;
          break;
        case 'skills':
          icon = Icons.psychology;
          title = 'Update Skills';
          description = 'Add relevant skills that highlight your expertise';
          color = Colors.teal;
          break;
        case 'photo':
          icon = Icons.image;
          title = 'Upgrade Profile Photo';
          description =
              'Use a professional headshot to make a strong impression';
          color = Colors.pink;
          break;
        default:
          icon = Icons.edit;
          title = 'Improve Your Profile';
          description = 'Take action to increase your profile strength';
          color = Colors.grey;
      }

      return Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: ActionCard(
          icon: icon,
          title: title,
          description: description,
          color: color,
          onTap: () {
            // Navigate to appropriate section detail
          },
        ),
      );
    }).toList();
  }

  // Helper methods to calculate various scores
  int _calculateProfileCompleteness(LinkedInProfile profile) {
    int score = 0;

    // Basic profile
    if (profile.fullName != null && profile.fullName!.isNotEmpty) score += 10;
    if (profile.headline != null && profile.headline!.isNotEmpty) score += 15;
    if (profile.profileImageUrl != null) score += 10;
    if (profile.coverImageUrl != null) score += 5;

    // About section
    if (profile.aboutSection != null && profile.aboutSection!.isNotEmpty) {
      score += profile.aboutSection!.length > 500 ? 15 : 10;
    }

    // Experience
    if (profile.experiences != null && profile.experiences!.isNotEmpty) {
      score += min(15, profile.experiences!.length * 5);
    }

    // Education
    if (profile.education != null && profile.education!.isNotEmpty) {
      score += min(10, profile.education!.length * 5);
    }

    // Skills
    if (profile.skills != null && profile.skills!.isNotEmpty) {
      score += min(15, profile.skills!.length);
    }

    // Certifications
    if (profile.certifications != null && profile.certifications!.isNotEmpty) {
      score += min(5, profile.certifications!.length * 2);
    }

    return score;
  }

  int _calculateHeadlineScore(String? headline) {
    if (headline == null || headline.isEmpty) return 0;
    if (headline.length < 30) return 40;
    if (headline.length < 60) return 70;
    return 90;
  }

  int _calculateAboutScore(String? about) {
    if (about == null || about.isEmpty) return 0;
    if (about.length < 200) return 30;
    if (about.length < 500) return 60;
    return 85;
  }

  int _calculateExperienceScore(List<Experience>? experiences) {
    if (experiences == null || experiences.isEmpty) return 0;
    if (experiences.length == 1) return 50;
    if (experiences.length >= 3) return 90;
    return 70;
  }

  int _calculateEducationScore(List<Education>? education) {
    if (education == null || education.isEmpty) return 0;
    return 85;
  }

  int _calculateSkillsScore(List<Skill>? skills) {
    if (skills == null || skills.isEmpty) return 0;
    if (skills.length < 5) return 40;
    if (skills.length < 15) return 70;
    return 90;
  }

  int _calculatePhotoScore(LinkedInProfile profile) {
    int score = 0;
    if (profile.profileImageUrl != null) score += 50;
    if (profile.coverImageUrl != null) score += 50;
    return score;
  }

  List<String> _getSectionsNeedingImprovement(
    ProfileRecommendation recommendations,
  ) {
    List<String> sections = [];

    if (recommendations.headline != null) sections.add('headline');
    if (recommendations.aboutSection != null) sections.add('about');
    if (recommendations.missingEducation != null &&
        recommendations.missingEducation!.isNotEmpty)
      sections.add('education');
    if (recommendations.missingExperience != null &&
        recommendations.missingExperience!.isNotEmpty)
      sections.add('experience');
    if (recommendations.missingSkills != null &&
        recommendations.missingSkills!.isNotEmpty)
      sections.add('skills');
    if (recommendations.profilePictureAdvice != null) sections.add('photo');

    return sections;
  }
}

int min(int a, int b) {
  return a < b ? a : b;
}
