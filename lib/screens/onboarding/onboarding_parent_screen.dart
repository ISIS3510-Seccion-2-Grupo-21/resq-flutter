import 'package:flutter/material.dart';
import 'package:resq/screens/onboarding/onboarding_screen1.dart';
import 'package:resq/screens/onboarding/onboarding_screen2.dart';
import 'package:resq/screens/onboarding/onboarding_screen3.dart';
import 'package:resq/screens/onboarding/final_onboarding_screen.dart';

class OnboardingParentScreen extends StatefulWidget {
  @override
  _OnboardingParentScreenState createState() => _OnboardingParentScreenState();
}

class _OnboardingParentScreenState extends State<OnboardingParentScreen> {
  PageController _pageController = PageController();
  late List<Widget> _onboardingPages;
  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    _onboardingPages = [
      OnboardingScreen1(navigateToNextScreen),
      OnboardingScreen2(navigateToNextScreen),
      OnboardingScreen3(navigateToNextScreen),
      FinalOnboardingScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: _onboardingPages,
          ),
          // Mostrar los indicadores de página en las pantallas 1, 2 y 3
          if (_currentPageIndex < 3)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (index) => buildIndicator(index),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget buildIndicator(int index) {
    Color color = index == _currentPageIndex ? Colors.grey[700]! : Colors.grey[300]!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }

  void navigateToNextScreen() {
    int nextPageIndex = _pageController.page!.round() + 1;
    if (nextPageIndex < _onboardingPages.length) {
      _pageController.animateToPage(
        nextPageIndex,
        duration: Duration(milliseconds: 500),
        curve: Curves.ease,
      );
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (context) => FinalOnboardingScreen()));
    }
  }
}