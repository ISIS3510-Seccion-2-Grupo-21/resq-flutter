import 'package:flutter/material.dart';
import 'package:resq/main.dart';
import 'package:resq/screens/onboarding/onboarding_screen1.dart';
import 'package:resq/screens/onboarding/onboarding_screen2.dart';
import 'package:resq/screens/onboarding/onboarding_screen3.dart';
import 'package:resq/screens/onboarding/final_onboarding_screen.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:resq/screens/onboarding/onboarding_screen4.dart';

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
    Connectivity().onConnectivityChanged.listen((result) {
      if (result[0] == ConnectivityResult.none) {
        showNoConnectionMessage();
      }
    });
    checkConnectivityAndShowMessage();

    _onboardingPages = [
      OnboardingScreen1(navigateToNextScreen),
      OnboardingScreen2(navigateToNextScreen),
      OnboardingScreen3(navigateToNextScreen),
      OnboardingScreen4(navigateToNextScreen),
      const FinalOnboardingScreen(),
    ];
  }

  Future<void> checkConnectivityAndShowMessage() async {
    bool isConnected = await MyApp.checkInternetConnection();
    if (!isConnected) {
      showNoConnectionMessage();
    }
  }

void showNoConnectionMessage() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        content: 
            Row(
              children: [
                Icon(
                  Icons.wifi,
                  color: Colors.grey[900],
                ),
                SizedBox(width: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.grey[900]!),
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  child: Text(
                    'You have lost connection.',
                    style: TextStyle(color: Colors.grey[900]),
                  ),
                ),
              ],
            ), 
        actions: [
                TextButton(
                  onPressed:() {
                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(80, 225, 130, 1),
                    ),
                  ),
                  child: Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
        ],
      );
    },
  );
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
          if (_currentPageIndex < 4)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
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

 