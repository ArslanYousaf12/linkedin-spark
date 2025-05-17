import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/animations.dart';
import '../../../core/widgets/primary_button.dart';
import '../domain/linkedin_profile.dart';
import '../domain/profile_recommendation.dart';
import 'bloc/profile_bloc.dart';
import 'widgets/recommendation_card.dart';
import 'widgets/section_criteria.dart';

class HeadlineAnalysisScreen extends StatelessWidget {
  const HeadlineAnalysisScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        if (state is RecommendationsLoadSuccess) {
          return _buildContent(context, state.profile, state.recommendations);
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  Widget _buildContent(
    BuildContext context,
    LinkedInProfile profile,
    ProfileRecommendation recommendations,
  ) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Calculate headline score (0-100)
    final headlineScore = _calculateHeadlineScore(profile.headline);
    final headlineColor = _getScoreColor(headlineScore);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Headline Analysis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit headline
            },
            tooltip: 'Edit Headline',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Headline
            SlideAnimation(
              beginOffset: const Offset(0, 20),
              child: Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Current Headline',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: headlineColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              '$headlineScore%',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: headlineColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        profile.headline ?? 'No headline set',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontStyle:
                              profile.headline == null
                                  ? FontStyle.italic
                                  : FontStyle.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Analysis Criteria
            SlideAnimation(
              beginOffset: const Offset(0, 20),
              delay: const Duration(milliseconds: 100),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Analysis Criteria',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  SectionCriteria(
                    title: 'Keyword Usage',
                    description:
                        'Include industry-specific keywords that recruiters search for',
                    score: _getKeywordScore(profile.headline),
                  ),
                  const SizedBox(height: 12),
                  SectionCriteria(
                    title: 'Length & Detail',
                    description: 'Optimal headlines are 60-120 characters',
                    score: _getLengthScore(profile.headline),
                  ),
                  const SizedBox(height: 12),
                  SectionCriteria(
                    title: 'Clarity & Specificity',
                    description:
                        'Clearly communicate your expertise and value proposition',
                    score: _getClarityScore(profile.headline),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // AI Recommendations
            SlideAnimation(
              beginOffset: const Offset(0, 20),
              delay: const Duration(milliseconds: 200),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AI-Powered Recommendations',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  RecommendationCard(
                    title: 'Add Industry Keywords',
                    description:
                        'Include "Digital Marketing Strategist" to increase visibility in searches',
                    icon: Icons.search,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 12),
                  RecommendationCard(
                    title: 'Add Emojis for Visibility',
                    description:
                        'Strategic emojis can make your headline stand out in feeds',
                    icon: Icons.emoji_emotions,
                    color: Colors.amber,
                  ),
                  const SizedBox(height: 12),
                  RecommendationCard(
                    title: 'Quantify Your Impact',
                    description:
                        'Add metrics like "10+ Years Experience" or "Helped 50+ Clients"',
                    icon: Icons.bar_chart,
                    color: Colors.green,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Example Headlines
            SlideAnimation(
              beginOffset: const Offset(0, 20),
              delay: const Duration(milliseconds: 300),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Successful Headline Examples',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildExampleHeadline(
                    context,
                    headline:
                        '🚀 Senior Software Engineer | Flutter Expert | Building Beautiful Mobile Experiences | 100K+ App Downloads',
                    industry: 'Software Development',
                  ),
                  const SizedBox(height: 12),
                  _buildExampleHeadline(
                    context,
                    headline:
                        '💼 Digital Marketing Strategist | Helping SaaS Companies Grow 3x | SEO, Content & Paid Social Expert | Top 10 Marketing Writer on LinkedIn',
                    industry: 'Digital Marketing',
                  ),
                  const SizedBox(height: 12),
                  _buildExampleHeadline(
                    context,
                    headline:
                        '⚡ HR Director | Transforming Company Culture | 15+ Years Building High-Performance Teams | Speaker & Consultant',
                    industry: 'Human Resources',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Suggested Headline Button
            SlideAnimation(
              beginOffset: const Offset(0, 20),
              delay: const Duration(milliseconds: 400),
              child: Center(
                child: PrimaryButton(
                  text: 'Generate Personalized Headline',
                  onPressed: () {
                    // Generate and show personalized headline suggestion
                    _showHeadlineSuggestionDialog(context, recommendations);
                  },
                  width: 300,
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  void _showHeadlineSuggestionDialog(
    BuildContext context,
    ProfileRecommendation recommendations,
  ) {
    final suggestedHeadline =
        recommendations.headline ??
        'Flutter Developer | Mobile App Specialist | Creating Beautiful, High-Performance Mobile Experiences | 5+ Years in Cross-Platform Development';

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Suggested Headline'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(suggestedHeadline),
                const SizedBox(height: 16),
                const Text(
                  'This headline includes relevant keywords, quantifies experience, and clearly communicates your expertise.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  // In a real app, this would update the profile
                  Navigator.of(context).pop();
                  // Show success message
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Headline updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
                child: const Text('Use This Headline'),
              ),
            ],
          ),
    );
  }

  Widget _buildExampleHeadline(
    BuildContext context, {
    required String headline,
    required String industry,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDarkMode ? Colors.grey.shade800 : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDarkMode ? Colors.grey.shade700 : Colors.grey.shade300,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            headline,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  industry,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {
                  // Copy to clipboard
                },
                icon: const Icon(Icons.copy, size: 16),
                label: const Text('Copy'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Helper methods for calculating scores
  int _calculateHeadlineScore(String? headline) {
    if (headline == null || headline.isEmpty) return 0;

    int score = 0;

    // Keyword score (0-40 points)
    score += _getKeywordScore(headline);

    // Length score (0-30 points)
    score += _getLengthScore(headline);

    // Clarity score (0-30 points)
    score += _getClarityScore(headline);

    return score;
  }

  int _getKeywordScore(String? headline) {
    if (headline == null || headline.isEmpty) return 0;

    // For demo purposes, check for common job title keywords
    final keywords = [
      'engineer',
      'developer',
      'designer',
      'manager',
      'director',
      'specialist',
      'expert',
      'consultant',
      'flutter',
      'mobile',
      'web',
      'software',
      'product',
      'marketing',
      'sales',
      'HR',
      'finance',
      'data',
    ];

    int keywordCount = 0;
    for (final keyword in keywords) {
      if (headline.toLowerCase().contains(keyword.toLowerCase())) {
        keywordCount++;
      }
    }

    if (keywordCount >= 3) return 40;
    if (keywordCount == 2) return 30;
    if (keywordCount == 1) return 20;
    return 10;
  }

  int _getLengthScore(String? headline) {
    if (headline == null) return 0;

    final length = headline.length;

    if (length == 0) return 0;
    if (length < 30) return 10;
    if (length < 60) return 20;
    if (length <= 120) return 30;
    return 25; // Too long (over 120 chars)
  }

  int _getClarityScore(String? headline) {
    if (headline == null || headline.isEmpty) return 0;

    // For demo purposes, check for clarity indicators like separators and structure
    bool hasStructure = headline.contains('|');
    bool hasEmojis = RegExp(r'[\p{Emoji}]', unicode: true).hasMatch(headline);
    bool hasActionVerbs =
        headline.toLowerCase().contains('building') ||
        headline.toLowerCase().contains('helping') ||
        headline.toLowerCase().contains('creating');

    int score = 0;
    if (hasStructure) score += 15;
    if (hasEmojis) score += 5;
    if (hasActionVerbs) score += 10;

    return score;
  }

  Color _getScoreColor(int score) {
    if (score < 40) return Colors.red;
    if (score < 70) return Colors.orange;
    return Colors.green;
  }
}
