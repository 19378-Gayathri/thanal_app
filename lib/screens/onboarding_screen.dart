import 'package:flutter/material.dart';
import 'location_permission.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, dynamic>> onboardingData = [
    {
      "title": "Real-time Alerts",
      "description": "Get instant disaster alerts for your area.",
      "icon": Icons.warning_amber_rounded
    },
    {
      "title": "Offline Survival Tools",
      "description":
          "Access checklists, guides, and contacts even without network.",
      "icon": Icons.checklist_rounded
    },
    {
      "title": "Volunteer & Donation Help",
      "description": "Find or offer help during disasters easily.",
      "icon": Icons.volunteer_activism_rounded
    },
    {
      "title": "AI Chatbot + Elder Mode",
      "description":
          "Talk to our assistant or switch to easy-access Elder Mode.",
      "icon": Icons.support_agent_rounded
    },
  ];

  void _nextPage() {
    if (_currentPage < onboardingData.length - 1) {
      _controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut);
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => LocationPermissionScreen()),
      );
    }
  }

  void _skip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LocationPermissionScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // 🔵 Blue Gradient Background
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 38, 124, 221),
              Color(0xFF1E88E5),
              Color(0xFF42A5F5),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: PageView.builder(
          controller: _controller,
          itemCount: onboardingData.length,
          onPageChanged: (index) =>
              setState(() => _currentPage = index),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 30.0, vertical: 80.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 🔹 Icon with Circle Background
                  Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      onboardingData[index]["icon"],
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // 🔹 Title
                  Text(
                    onboardingData[index]["title"],
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  // 🔹 Description
                  Text(
                    onboardingData[index]["description"],
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white70,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),

                  const Spacer(),

                  // 🔹 Page Indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onboardingData.length,
                      (dotIndex) => Container(
                        margin:
                            const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentPage == dotIndex ? 14 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == dotIndex
                              ? Colors.white
                              : Colors.white54,
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // 🔹 Buttons
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _skip,
                        child: const Text(
                          "SKIP",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor:
                              const Color(0xFF1565C0),
                          padding:
                              const EdgeInsets.symmetric(
                                  horizontal: 28,
                                  vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(30),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          _currentPage ==
                                  onboardingData.length - 1
                              ? "Get Started"
                              : "NEXT",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}