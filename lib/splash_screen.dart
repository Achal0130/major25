import 'package:flutter/material.dart';
import 'starter_screen.dart'; // Make sure this file exists

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller for 3 seconds
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Tween animation for the progress bar (0.0 to 1.0)
    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    // Start the animation
    _animationController.forward();

    // When the animation is finished, navigate directly to the StarterScreen
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 500), () {
          // Navigate without any transition animation
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const StarterScreen(),
            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// Progress Bar Animation Left to Right
  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0),
      child: Container(
        height: 5,
        decoration: BoxDecoration(
          color: Colors.grey[300], // Background bar color
          borderRadius: BorderRadius.circular(5),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: AnimatedBuilder(
                animation: _progressAnimation,
                builder: (context, child) {
                  return Container(
                    height: 5,
                    width: MediaQuery.of(context).size.width *
                        0.8 * // 80% due to horizontal padding
                        _progressAnimation.value,
                    decoration: BoxDecoration(
                      color: const Color(0xFF296E58), // Progress color
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1E6),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 60),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Replace with your logo asset
                    height: 100,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 40),
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Image.asset(
                      'assets/images/leaf_left.png',
                      height: 150,
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Image.asset(
                      'assets/images/leaf_right.png',
                      height: 200,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _buildProgressBar(),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
