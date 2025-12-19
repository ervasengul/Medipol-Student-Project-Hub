import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'login_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      child: const Text('Sign In'),
                    ),
                  ],
                ),
              ),

              // Hero Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Connect, Collaborate, and Create Together',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Medipol Student Project Hub connects students and faculty across all departments. Share ideas, find teammates, and bring your projects to life.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF6B7280),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 48,
                          vertical: 16,
                        ),
                      ),
                      child: const Text('Get Started'),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Features Section
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    Text(
                      'Everything You Need for Successful Collaboration',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF111827),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    _buildFeatureCard(
                      context,
                      icon: LucideIcons.lightbulb,
                      title: 'Share Ideas',
                      description:
                          'Post your project ideas and find the perfect team members to bring them to life.',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      context,
                      icon: LucideIcons.users,
                      title: 'Find Teammates',
                      description:
                          'Browse projects and connect with students who share your interests and skills.',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      context,
                      icon: LucideIcons.messageSquare,
                      title: 'Collaborate',
                      description:
                          'Use built-in messaging and collaboration tools to work seamlessly with your team.',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureCard(
                      context,
                      icon: LucideIcons.trendingUp,
                      title: 'Track Progress',
                      description:
                          'Manage milestones, deadlines, and track your project\'s progress in one place.',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 48),

              // Footer
              Container(
                width: double.infinity,
                color: const Color(0xFF111827),
                padding: const EdgeInsets.all(32),
                child: Text(
                  '© 2025 Istanbul Medipol University. All rights reserved.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF9CA3AF),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0EA5E9),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF0EA5E9),
              size: 24,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color.fromRGBO(255, 255, 255, 0.9),
            ),
          ),
        ],
      ),
    );
  }
}
