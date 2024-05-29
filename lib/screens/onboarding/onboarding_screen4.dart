import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OnboardingScreen4 extends StatelessWidget {
  final VoidCallback navigateToNextScreen;

  const OnboardingScreen4(this.navigateToNextScreen, {Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Image.asset(
              'assets/onboarding4.png', 
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            StudentCounter(navigateToNextScreen: navigateToNextScreen),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: InkWell(
                  onTap: navigateToNextScreen,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green[400],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class StudentCounter extends StatefulWidget {
  final VoidCallback navigateToNextScreen;

  const StudentCounter({super.key, required this.navigateToNextScreen});

  @override
  _StudentCounterState createState() => _StudentCounterState();
}

class _StudentCounterState extends State<StudentCounter> {
  late Stream<QuerySnapshot> _studentsStream;

  @override
  void initState() {
    super.initState();
    initializeFirebase(); // Initialize Firebase
    _studentsStream = FirebaseFirestore.instance
        .collection('users')
        .where('role', isEqualTo: 'student')
        .snapshots();
  }

  // Initialize Firebase
  Future<void> initializeFirebase() async {
    await Firebase.initializeApp();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: _studentsStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }

            int studentCount = snapshot.data?.docs.length ?? 0;

            return Positioned(
              left: MediaQuery.of(context).size.width * 0.7, 
              bottom: MediaQuery.of(context).size.height * 0.287,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                child: Text(
                  '$studentCount', 
                  key: ValueKey<int>(studentCount),
                  style: const TextStyle(
                    fontSize: 16.55,
                    fontWeight: FontWeight.w600, 
                    fontFamily: 'SFPro', 
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
