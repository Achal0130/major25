import 'package:flutter/material.dart';
import 'welcome_screen.dart'; // Make sure you have this screen created

class StarterScreen extends StatelessWidget {
  const StarterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1E6),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
          children: [
            const SizedBox(height: 20),

            // ✅ TOP CENTER logo3 ADDED
            Center(
              child: Image.asset(
                'assets/images/logo3.png', // Make sure this is correct
                height: 50,
              ),
            ),

            const SizedBox(height: 40), // Space between logo and content

            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // ❌ Removed logo2 from here!

                  // 🌿 Main Image
                  Image.asset(
                    'assets/images/starter_image.png', // Your main image here
                    height: 250,
                  ),

                  const SizedBox(height: 24),

                  // ✅ Text Changed
                  const Text(
                    'Scan to discover',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF296E58),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // ✅ Subtitle Changed
                  const Text(
                    'Open up a world of possibilities',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ Dots - 2 dots only, first active
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDot(isActive: true),
                  const SizedBox(width: 8),
                  _buildDot(isActive: false),
                ],
              ),
            ),

            // ✅ Next button (style, size, color matched)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to WelcomeScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WelcomeScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF296E58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }

  /// Dot indicator widget for page position
  Widget _buildDot({required bool isActive}) {
    return Container(
      width: isActive ? 12 : 8,
      height: isActive ? 12 : 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF296E58) : Colors.grey,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}
