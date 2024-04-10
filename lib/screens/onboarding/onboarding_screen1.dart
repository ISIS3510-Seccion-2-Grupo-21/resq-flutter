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
          Image.asset(
            'assets/onboarding1.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                onTap: navigateToNextScreen,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
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
          ),
        ],
      ),
    );
  }
}
