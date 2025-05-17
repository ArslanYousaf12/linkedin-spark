import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/animations.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _getStarted() async {
    setState(() {
      _isLoading = true;
    });

    // Simulate loading
    await Future.delayed(const Duration(milliseconds: 800));

    // In a real app, you might do some initialization here
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('has_seen_welcome', true);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
      context.go(AppConstants.routePermissions);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(flex: 1),

              // Logo and App Name
              Center(
                child: SlideAnimation(
                  beginOffset: const Offset(0, 30),
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(
                      Icons.trending_up_rounded,
                      size: 40,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // App Name
              SlideAnimation(
                beginOffset: const Offset(0, 30),
                delay: const Duration(milliseconds: 200),
                child: Center(
                  child: Text(
                    AppConstants.appName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // Tagline
              SlideAnimation(
                beginOffset: const Offset(0, 30),
                delay: const Duration(milliseconds: 300),
                child: Center(
                  child: Text(
                    AppConstants.appTagline,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: isDarkMode ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Illustration
              SlideAnimation(
                beginOffset: const Offset(0, 60),
                delay: const Duration(milliseconds: 400),
                child: Center(
                  child: SizedBox(
                    height: size.height * 0.3,
                    child: AnimatedBuilder(
                      animation: _controller,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, 5 * _controller.value),
                          child: child,
                        );
                      },
                      child: Image.network(
                        'https://cdni.iconscout.com/illustration/premium/thumb/person-working-on-laptop-3411814-2851870.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Feature bullet points
              SlideAnimation(
                beginOffset: const Offset(0, 30),
                delay: const Duration(milliseconds: 500),
                child: Column(
                  children: [
                    _buildFeatureItem(
                      context,
                      icon: Icons.analytics_outlined,
                      text: 'Get personalized LinkedIn profile recommendations',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      context,
                      icon: Icons.person_outline,
                      text: 'Improve your personal branding strategy',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      context,
                      icon: Icons.trending_up_outlined,
                      text: 'Increase your profile visibility and engagement',
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 1),

              // Get Started Button
              SlideAnimation(
                beginOffset: const Offset(0, 30),
                delay: const Duration(milliseconds: 700),
                child: PrimaryButton(
                  text: 'Get Started',
                  isLoading: _isLoading,
                  onPressed: _getStarted,
                ),
              ),

              const SizedBox(height: 16),

              // Login Button
              SlideAnimation(
                beginOffset: const Offset(0, 30),
                delay: const Duration(milliseconds: 800),
                child: SecondaryButton(
                  text: 'Sign in with LinkedIn',
                  isOutlined: false,
                  prefixIcon: Icon(
                    Icons.login_rounded,
                    color:
                        isDarkMode
                            ? Colors.white
                            : Theme.of(context).primaryColor,
                    size: 20,
                  ),
                  onPressed: () {
                    // Not implementing sign-in for this demo
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'LinkedIn sign-in not implemented in this demo',
                        ),
                      ),
                    );
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

  Widget _buildFeatureItem(
    BuildContext context, {
    required IconData icon,
    required String text,
  }) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 20),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 16,
              color: isDarkMode ? Colors.white : Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
