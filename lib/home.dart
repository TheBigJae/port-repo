import 'package:flutter/material.dart';

void main() {
  runApp(const PortfolioApp());
}

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({Key? key}) : super(key: key);

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  bool isDark = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFFF5F7FA),
        fontFamily: 'Inter',
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: const Color(0xFF0F172A),
        fontFamily: 'Inter',
      ),
      themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
      home: PortfolioHome(
        isDark: isDark,
        onThemeToggle: () {
          setState(() {
            isDark = !isDark;
          });
        },
      ),
    );
  }
}

class PortfolioHome extends StatefulWidget {
  final bool isDark;
  final VoidCallback onThemeToggle;

  const PortfolioHome({
    Key? key,
    required this.isDark,
    required this.onThemeToggle,
  }) : super(key: key);

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDark;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? [
                    const Color(0xFF0F172A),
                    const Color(0xFF1E293B),
                    const Color(0xFF334155),
                  ]
                : [
                    const Color(0xFFF5F7FA),
                    const Color(0xFFE0E7FF),
                    const Color(0xFFC7D2FE),
                  ],
          ),
        ),
        child: SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: _buildHeader(isDark),
                ),
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (index) {
                      setState(() {
                        _selectedIndex = index;
                      });
                    },
                    children: [
                      _buildHomePage(isDark),
                      _buildAboutPage(isDark),
                      _buildSkillsPage(isDark),
                      _buildContactPage(isDark),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(isDark),
    );
  }

  Widget _buildHomePage(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildProfileCard(isDark),
          const SizedBox(height: 20),
          Text(
            'Swipe or use navigation below to explore',
            style: TextStyle(
              fontSize: 14,
              color: isDark ? Colors.white60 : const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildAboutPage(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildAboutSection(isDark),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSkillsPage(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildSkillsSection(isDark),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildContactPage(bool isDark) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildContactSection(isDark),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF1E293B).withOpacity(0.95)
            : Colors.white.withOpacity(0.95),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'Home', isDark),
              _buildNavItem(1, Icons.person_outline_rounded, 'About', isDark),
              _buildNavItem(2, Icons.code_rounded, 'Skills', isDark),
              _buildNavItem(3, Icons.contact_mail_rounded, 'Contact', isDark),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label, bool isDark) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isSelected ? 16 : 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          gradient: isSelected
              ? LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF4F46E5), const Color(0xFF7C3AED)]
                      : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                )
              : null,
          borderRadius: BorderRadius.circular(15),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Colors.white
                  : isDark
                      ? Colors.white60
                      : const Color(0xFF64748B),
              size: 24,
            ),
            if (isSelected) ...[
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Portfolio',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : const Color(0xFF1E293B),
          ),
        ),
        GestureDetector(
          onTap: widget.onThemeToggle,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isDark
                  ? Colors.white.withOpacity(0.1)
                  : Colors.black.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.black.withOpacity(0.1),
              ),
            ),
            child: Icon(
              isDark ? Icons.light_mode : Icons.dark_mode,
              color: isDark ? Colors.amber : const Color(0xFF4F46E5),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isDark
              ? [
                  const Color(0xFF4F46E5),
                  const Color(0xFF7C3AED),
                ]
              : [
                  const Color(0xFF6366F1),
                  const Color(0xFF8B5CF6),
                ],
        ),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: (isDark ? const Color(0xFF4F46E5) : const Color(0xFF6366F1))
                .withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 4),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const Icon(
              Icons.person,
              size: 60,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'John Bamigbola',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Flutter Developer',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildSocialButton(Icons.code, isDark),
              const SizedBox(width: 15),
              _buildSocialButton(Icons.email, isDark),
              const SizedBox(width: 15),
              _buildSocialButton(Icons.link, isDark),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton(IconData icon, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
        ),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 22,
      ),
    );
  }

  Widget _buildAboutSection(bool isDark) {
    return _buildGlassCard(
      isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF4F46E5), const Color(0xFF7C3AED)]
                        : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.person_outline, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Text(
                'About Me',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Passionate Flutter developer with a keen eye for creating beautiful, '
            'performant mobile applications. I love transforming ideas into '
            'elegant solutions and building experiences that users love.',
            style: TextStyle(
              fontSize: 16,
              height: 1.6,
              color: isDark
                  ? Colors.white.withOpacity(0.8)
                  : const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillsSection(bool isDark) {
    return _buildGlassCard(
      isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFFEC4899), const Color(0xFFF59E0B)]
                        : [const Color(0xFFEF4444), const Color(0xFFF59E0B)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.code, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Text(
                'Skills',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildSkillItem('Flutter & Dart', 0.9, isDark),
          const SizedBox(height: 15),
          _buildSkillItem('UI/UX Design', 0.85, isDark),
          const SizedBox(height: 15),
          _buildSkillItem('State Management', 0.88, isDark),
          const SizedBox(height: 15),
          _buildSkillItem('Firebase & APIs', 0.82, isDark),
        ],
      ),
    );
  }

  Widget _buildSkillItem(String skill, double progress, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              skill,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : const Color(0xFF1E293B),
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white70 : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 8,
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : Colors.black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: progress,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: isDark
                      ? [const Color(0xFF4F46E5), const Color(0xFF7C3AED)]
                      : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(bool isDark) {
    return _buildGlassCard(
      isDark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: isDark
                        ? [const Color(0xFF10B981), const Color(0xFF06B6D4)]
                        : [const Color(0xFF14B8A6), const Color(0xFF06B6D4)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.contact_mail, color: Colors.white),
              ),
              const SizedBox(width: 15),
              Text(
                'Contact',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),
          _buildContactItem(
            Icons.email_outlined,
            'Email',
            'johnbamigbola10@gmail.com',
            isDark,
          ),
          const SizedBox(height: 20),
          _buildContactItem(
            Icons.phone_outlined,
            'Phone',
            '+ 234 567 8900',
            isDark,
          ),
          const SizedBox(height: 20),
          _buildContactItem(
            Icons.location_on_outlined,
            'Location',
            'Ibadan, Nigeria',
            isDark,
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(
      IconData icon, String title, String value, bool isDark) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark
                ? Colors.white.withOpacity(0.1)
                : const Color(0xFF6366F1).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: isDark ? Colors.white70 : const Color(0xFF6366F1),
            size: 22,
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isDark ? Colors.white60 : const Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : const Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildGlassCard(bool isDark, {required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.1)
              : Colors.white.withOpacity(0.8),
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}