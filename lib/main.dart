import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:resq/screens/auth/login_process.dart';
import 'package:resq/screens/home/home_screen.dart';// Importa tu pantalla de inicio
import 'package:resq/firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:user_repository/user_repository.dart';
import 'package:permission_handler/permission_handler.dart'; // Importa el paquete de manejo de permisos

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Set up Firebase Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  // Request permissions
  await requestPermissions();

  // Run the app
  runApp(LoginProcess(FirebaseUserRepo())); // Cambia LoginProcess por MyApp
}

Future<void> requestPermissions() async {
  // Request camera and storage permissions
  await Permission.camera.request();
  await Permission.storage.request();
}
