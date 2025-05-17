import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/animations.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/secondary_button.dart';
import '../domain/profile_repository.dart';
import 'bloc/profile_bloc.dart';

class ProfileInputScreen extends StatefulWidget {
  const ProfileInputScreen({Key? key}) : super(key: key);

  @override
  State<ProfileInputScreen> createState() => _ProfileInputScreenState();
}

class _ProfileInputScreenState extends State<ProfileInputScreen> {
  final TextEditingController _urlController = TextEditingController();
  final FocusNode _urlFocusNode = FocusNode();
  String? _errorText;
  bool _isLoading = false;

  @override
  void dispose() {
    _urlController.dispose();
    _urlFocusNode.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      _errorText = null;
    });

    final url = _urlController.text.trim();

    if (url.isEmpty) {
      setState(() {
        _errorText = 'Please enter a LinkedIn profile URL';
      });
      return;
    }

    // Submit to BLoC
    context.read<ProfileBloc>().add(ProfileUrlSubmitted(url));
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
          onPressed: () => context.go(AppConstants.routePermissions),
        ),
      ),
      body: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileLoadInProgress) {
            setState(() {
              _isLoading = true;
            });
          } else {
            setState(() {
              _isLoading = false;
            });

            if (state is ProfileLoadFailure) {
              setState(() {
                _errorText = state.message;
              });
            } else if (state is ProfileLoadSuccess) {
              // Navigate to results screen
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Profile loaded successfully!'),
                  backgroundColor: Colors.green,
                ),
              );

              // In a real app, we would navigate to the analysis screen
              // context.go(AppConstants.routeAnalysis);

              // For demo purposes, generate recommendations immediately
              context.read<ProfileBloc>().add(const RecommendationsRequested());
              context.go(AppConstants.routeDashboard);
            }
          }
        },
        builder: (context, state) {
          return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: SafeArea(
              child: SingleChildScrollView(
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
                          'Enter LinkedIn Profile',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Subheader
                      SlideAnimation(
                        beginOffset: const Offset(0, 30),
                        delay: const Duration(milliseconds: 100),
                        child: Text(
                          'Provide your LinkedIn profile URL to get personalized recommendations for improving your personal brand.',
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
                            'https://cdni.iconscout.com/illustration/premium/thumb/user-profile-5119929-4283687.png',
                            height: size.height * 0.25,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // LinkedIn URL Input
                      SlideAnimation(
                        beginOffset: const Offset(0, 30),
                        delay: const Duration(milliseconds: 300),
                        child: CustomTextField(
                          label: 'LinkedIn Profile URL',
                          hint: 'https://www.linkedin.com/in/username',
                          controller: _urlController,
                          focusNode: _urlFocusNode,
                          errorText: _errorText,
                          keyboardType: TextInputType.url,
                          prefixIcon: Icon(
                            Icons.link,
                            color: isDarkMode ? Colors.white70 : Colors.grey,
                          ),
                          onSubmitted: (_) => _validateAndSubmit(),
                        ),
                      ),

                      const SizedBox(height: 8),

                      // URL format hint
                      SlideAnimation(
                        beginOffset: const Offset(0, 20),
                        delay: const Duration(milliseconds: 350),
                        child: Text(
                          'e.g., https://www.linkedin.com/in/yourname',
                          style: TextStyle(
                            fontSize: 14,
                            color: isDarkMode ? Colors.white54 : Colors.black54,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Find profile tip
                      SlideAnimation(
                        beginOffset: const Offset(0, 20),
                        delay: const Duration(milliseconds: 400),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color:
                                isDarkMode
                                    ? Colors.blueGrey.shade800.withOpacity(0.5)
                                    : Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color:
                                  isDarkMode
                                      ? Colors.blueGrey.shade700
                                      : Colors.blue.shade100,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color:
                                    isDarkMode
                                        ? Colors.blue.shade300
                                        : Colors.blue.shade700,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'How to find your profile URL',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            isDarkMode
                                                ? Colors.white
                                                : Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '1. Go to your LinkedIn profile\n'
                                      '2. Click on "Edit public profile & URL"\n'
                                      '3. Copy the URL under "Your public profile URL"',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color:
                                            isDarkMode
                                                ? Colors.white70
                                                : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      // Analyze Button
                      SlideAnimation(
                        beginOffset: const Offset(0, 20),
                        delay: const Duration(milliseconds: 500),
                        child: PrimaryButton(
                          text: 'Analyze Profile',
                          isLoading: _isLoading,
                          onPressed: _validateAndSubmit,
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Demo Button
                      SlideAnimation(
                        beginOffset: const Offset(0, 20),
                        delay: const Duration(milliseconds: 600),
                        child: SecondaryButton(
                          text: 'Try Demo Profile',
                          isOutlined: true,
                          onPressed: () {
                            setState(() {
                              _urlController.text =
                                  'https://www.linkedin.com/in/demo-profile';
                              _errorText = null;
                            });
                            _validateAndSubmit();
                          },
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
