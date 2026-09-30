import 'package:flutter/material.dart';
import 'package:mindly/core/theme/app_colors.dart';
import '../../../widgets/app_button.dart';
import 'goals_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Welcome to Mindly',
      subtitle: 'Your space. Your feelings. Your growth.',
      image: Icons.favorite_rounded,
    ),
    OnboardingData(
      title: 'Your Private Space',
      subtitle: 'Your journal is private. Only you can read what you write.',
      image: Icons.lock_rounded,
    ),
    OnboardingData(
      title: 'Grow Together',
      subtitle: 'Understand your patterns and build healthy habits every day.',
      image: Icons.auto_graph_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Icon(
                  _pages[_currentPage].image,
                  size: 150,
                  color: AppColors.deepPlum.withOpacity(0.8),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? AppColors.amber
                              : AppColors.amber.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  SizedBox(
                    height: 180,
                    child: PageView.builder(
                      controller: _pageController,
                      onPageChanged: (index) => setState(() => _currentPage = index),
                      itemCount: _pages.length,
                      itemBuilder: (context, index) {
                        final data = _pages[index];
                        return Column(
                          children: [
                            Text(
                              data.title,
                              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                                color: AppColors.deepPlum,
                                fontSize: 28,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              data.subtitle,
                              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  AppButton(
                    text: _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                    onPressed: () {
                      if (_currentPage < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const GoalsSelectionScreen()),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final IconData image;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
