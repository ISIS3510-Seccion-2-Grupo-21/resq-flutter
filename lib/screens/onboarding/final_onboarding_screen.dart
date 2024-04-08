import 'package:flutter/material.dart';
import 'package:resq/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:resq/screens/auth/welcome_screen.dart';

class FinalOnboardingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/onboardingFinal.png',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Get Started button centered in the screen
          Center(
            child: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.35, // Altura del SizedBox
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end, // Alinea el contenido al final del Column
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => WelcomeScreen()));
                    },
                    child: Text('Get Started'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
