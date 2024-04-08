import 'package:flutter/material.dart';

class OnboardingScreen1 extends StatelessWidget {
  
  final VoidCallback navigateToNextScreen;
  OnboardingScreen1(this.navigateToNextScreen);

  @override
  Widget build(BuildContext context) {
    print('Building OnboardingScreen1');
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/onboarding1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Next button at the bottom left corner
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextButton(
                onPressed: navigateToNextScreen,
                child: Text(
                  'Next',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
