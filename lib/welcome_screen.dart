import 'package:flutter/material.dart';
import 'home_screen.dart'; // Make sure you have this file!

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1E6), // Light beige background
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 24),

            /// Logo at the top-left
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Image.asset(
                    'assets/images/logo.png', // Replace with your actual logo asset path
                    height: 40,
                  ),
                  // const SizedBox(width: 8),
                  // const Text(
                  //   'ANKUR',
                  //   style: TextStyle(
                  //     fontSize: 24,
                  //     fontWeight: FontWeight.bold,
                  //     color: Color(0xFF296E58),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Welcome Image (Main illustration)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Image.asset(
                  'assets/images/welcome_image.png', // Replace with your image asset path
                ),
              ),
            ),

            const SizedBox(height: 16),

            /// Headline and Subtext
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Welcome to Ankur',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF296E58),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'The farmer\'s companion',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF5E5E5E),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            /// Page Indicator Dots (2 dots)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDot(isActive: false),
                const SizedBox(width: 8),
                _buildDot(isActive: true),
              ],
            ),

            const SizedBox(height: 24),

            /// Gradient "Start Scanning..." Button (with navigation to HomeScreen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: GestureDetector(
                onTap: () {
                  // Navigation to HomeScreen, replace HomeScreen with your actual screen
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const HomeScreen(),
                    ),
                  );
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F9D58), Color(0xFF34A853)], // Google-style green gradient
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Center(
                    child: Text(
                      'Start Scanning...',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Progress Dot Widget
  static Widget _buildDot({required bool isActive}) {
    return Container(
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF296E58) : Colors.grey[400],
        shape: BoxShape.circle,
      ),
    );
  }
}
