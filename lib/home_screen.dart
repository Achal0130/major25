import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController(viewportFraction: 0.8);
  double _pageOffset = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildTopIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Settings Icon
          IconButton(
            icon: Image.asset(
              'assets/icons/settings.png',
              height: 24,
              width: 24,
            ),
            onPressed: () {},
          ),
          // Center Logo
          Image.asset(
            'assets/icons/logo2.png',
            height: 40,
            width: 40,
          ),
          // Bell and Profile icons
          Row(
            children: [
              IconButton(
                icon: Image.asset(
                  'assets/icons/bell.png',
                  height: 24,
                  width: 24,
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image.asset(
                  'assets/icons/profile.png',
                  height: 24,
                  width: 24,
                ),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOfferSlider() {
    List<String> sliderImages = [
      'assets/images/s1.png',
      'assets/images/s2.png',
      'assets/images/s3.png',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _pageController,
            itemCount: sliderImages.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              double scale = (_pageOffset - index).abs() < 1
                  ? 1 - (_pageOffset - index).abs() * 0.1
                  : 0.9;
              return Transform.scale(
                scale: scale,
                child: Padding(
                  padding: const EdgeInsets.only(right: 0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: AssetImage(sliderImages[index]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        _buildSliderIndicator(sliderImages.length),
      ],
    );
  }

  Widget _buildSliderIndicator(int itemCount) {
    return Container(
      alignment: Alignment.centerLeft,
      height: 10,
      child: Stack(
        children: [
          Row(
            children: List.generate(itemCount, (index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          Positioned(
            left: _pageOffset * 16,
            child: Container(
              width: 16,
              height: 8,
              decoration: BoxDecoration(
                color: const Color(0xFF386230),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageCard() {
    return Container(
      margin: const EdgeInsets.only(top: 20),
      width: MediaQuery.of(context).size.width * 0.8,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Ankur",
            style: TextStyle(
              fontSize: 12,
              color: Color(0xFF386230),
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Please, Click the Scan button!",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF386230),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _bottomNavItem('assets/icons/home.png', 0),
                _bottomNavItem('assets/icons/shop.png', 1),
                const SizedBox(width: 64), // Space for scan button
                _bottomNavItem('assets/icons/basket.png', 3),
                _bottomNavItem('assets/icons/box.png', 4),
              ],
            ),
          ),
          Positioned(
            top: -30,
            left: MediaQuery.of(context).size.width / 2 - 32 - 20,
            child: _buildScanButton(),
          ),
        ],
      ),
    );
  }

  Widget _bottomNavItem(String iconPath, int index) {
    return GestureDetector(
      onTap: () {
        // Handle bottom nav tap
      },
      child: Image.asset(
        iconPath,
        height: 28,
        width: 28,
        color: index == 0 ? const Color(0xFF386230) : Colors.grey,
      ),
    );
  }

  Widget _buildScanButton() {
    return GestureDetector(
      onTap: () {
        // Handle scan button tap
      },
      child: Container(
        height: 64,
        width: 64,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [
              Color(0xFF7C9D4E),
              Color(0xFF386230),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF386230).withOpacity(0.6),
              blurRadius: 20,
              spreadRadius: 5,
            ),
          ],
        ),
        child: Center(
          child: Image.asset(
            'assets/icons/scan.png',
            height: 28,
            width: 28,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF1E6),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopIcons(),
                _buildOfferSlider(),
                _buildMessageCard(),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }
}
