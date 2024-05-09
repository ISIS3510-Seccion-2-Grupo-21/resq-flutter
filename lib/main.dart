import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resq/firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:resq/screens/map/map_view.dart';
import 'package:resq/screens/auth/login_process.dart';
import 'package:user_repository/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the app
  runApp(MyApp()); // Cambia LoginProcess por MyApp
}

Future<void> requestPermissions() async {
  // Request camera and storage permissions
  print("Requesting permissions");
  await Permission.location.request();
  await Permission.camera.request();
  await Permission.storage.request();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: InternetCheckScreen(),
    );
  }

  static Future<bool> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}

class InternetCheckScreen extends StatefulWidget {
  const InternetCheckScreen({Key? key}) : super(key: key);

  @override
  _InternetCheckScreenState createState() => _InternetCheckScreenState();
}

class _InternetCheckScreenState extends State<InternetCheckScreen> {
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    // Check for internet connection immediately
    checkInternetConnection();
    // Listen for changes in connectivity status
    Connectivity().onConnectivityChanged.listen((result) {
      setState(() {
        _isConnected = result != ConnectivityResult.none;
      });
    });
  }

  Future<void> checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return const Scaffold(
        body: Center(
          child: Text('No internet connection!'),
        ),
      );
    } else {
      return LoginProcess(FirebaseUserRepo());
    }
  }
}
