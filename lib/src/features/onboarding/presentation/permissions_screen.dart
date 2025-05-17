import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/animations.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';

class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({Key? key}) : super(key: key);

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  bool _isLoading = false;

  Future<void> _continueWithLinkedIn() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_granted_permissions', true);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      context.go(AppConstants.routeProfileInput);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => context.go(AppConstants.routeWelcome),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),

              // Header
              SlideAnimation(
                beginOffset: const Offset(0, 30),
                child: Text(
                  'LinkedIn Permissions',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Subheader
              SlideAnimation(
                beginOffset: const Offset(0, 30),
                delay: const Duration(milliseconds: 100),
                child: Text(
                  'In order to provide personalized recommendations, we need access to your LinkedIn profile data.',
                  style: TextStyle(
                    fontSize: 16,
                    color: isDarkMode ? Colors.white70 : Colors.black87,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Illustration
              SlideAnimation(
                beginOffset: const Offset(0, 40),
                delay: const Duration(milliseconds: 200),
                child: Center(
                  child: Image.network(
                    'https://cdni.iconscout.com/illustration/premium/thumb/data-privacy-3428201-2910650.png',
                    height: size.height * 0.25,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Permissions list
              SlideAnimation(
                beginOffset: const Offset(0, 30),
                delay: const Duration(milliseconds: 300),
                child: Column(
                  children: [
                    _buildPermissionItem(
                      context,
                      icon: Icons.person_outline,
                      title: 'Profile Information',
                      description:
                          'Name, headline, about section, and profile picture',
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionItem(
                      context,
                      icon: Icons.work_outline,
                      title: 'Experience & Education',
                      description:
                          'Work history, education details, and certifications',
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionItem(
                      context,
                      icon: Icons.psychology_outlined,
                      title: 'Skills & Endorsements',
                      description:
                          'Professional skills and received endorsements',
                    ),
                    const SizedBox(height: 16),
                    _buildPermissionItem(
                      context,
                      icon: Icons.post_add_outlined,
                      title: 'Posts & Activity',
                      description:
                          'Recent posts, comments, and engagement metrics',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Privacy note
              SlideAnimation(
                beginOffset: const Offset(0, 20),
                delay: const Duration(milliseconds: 400),
                child: Text(
                  'We value your privacy. Your data is securely processed and never shared with third parties.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: isDarkMode ? Colors.white54 : Colors.black54,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Continue button
              SlideAnimation(
                beginOffset: const Offset(0, 20),
                delay: const Duration(milliseconds: 500),
                child: PrimaryButton(
                  text: 'Continue with LinkedIn',
                  isLoading: _isLoading,
                  onPressed: _continueWithLinkedIn,
                ),
              ),

              const SizedBox(height: 16),

              // Skip button
              SlideAnimation(
                beginOffset: const Offset(0, 20),
                delay: const Duration(milliseconds: 600),
                child: SecondaryButton(
                  text: 'Skip for now',
                  isOutlined: false,
                  onPressed: () {
                    // We'll still go to profile input, but for manual URL entry
                    context.go(AppConstants.routeProfileInput);
                  },
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDarkMode ? Colors.white : Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  fontSize: 14,
                  color: isDarkMode ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
