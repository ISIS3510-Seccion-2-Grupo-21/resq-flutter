import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:resq/blocs/chat_bloc/chat_bloc.dart';
import 'package:resq/main.dart';
import 'package:resq/screens/chat/chat_view.dart';
import 'package:resq/screens/home/emergency_form.dart';
import 'package:shake/shake.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool switchValue = true;
  String brigadeStudents = 'There are 0 brigade students available';
  Timer? _dataFetchTimer;
  bool _respondedSafe = true;
  final BlocProvider<ChatBloc> _chatBlocProvider = BlocProvider(
      create: (context) => ChatBloc(
        chatRepository: FirebaseChatRepository(
          firestore: FirebaseFirestore.instance,
          firebaseAuth: FirebaseAuth.instance,
        ),
        firebaseAuth: FirebaseAuth.instance,
      ),
      child: const ChatScreen(),
    );

  Future<void> fetchingPostgres() async {
    await Supabase.initialize(
        url: 'https://mpmipngzctcklmcjoxgv.supabase.co',
        anonKey:
            'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im1wbWlwbmd6Y3Rja2xtY2pveGd2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTI3NTY2NDcsImV4cCI6MjAyODMzMjY0N30.yfaJIi4YQQnvcRPbtSCsP14xjQW7nPCOGfBTO1oxhZs');

    final supabase = Supabase.instance.client;

    final result = await supabase
        .from('users')
        .select()
        .match({'role': 'brigadeStudent'}).count();
    print(result.count);
    var tempResult = '';
    if (result.count == 0) {
      tempResult = 'There are no brigade students available';
    } else if (result.count == 1) {
      tempResult = 'There is 1 brigade student available';
    } else {
      tempResult = 'There are ${result.count} brigade students available';
    }

    setState(() {
      brigadeStudents = tempResult;
    });
  }

  @override
  void initState() {
    super.initState();

    
    Connectivity().onConnectivityChanged.listen((result) {
      print(result[0] == ConnectivityResult.none);
      if (result[0] == ConnectivityResult.none) {
        showNoConnectionMessage();
      }
    });

    _dataFetchTimer = Timer.periodic(
        const Duration(seconds: 1000), (_) => fetchingPostgres());
    fetchingPostgres();
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        _shakeDialog();
        // Do stuff on phone shake
        //wait 10 seconds 
        Future.delayed(const Duration(seconds: 10), () {

        });

        if (!_respondedSafe) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => _chatBlocProvider),
          );
        }
      },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  Future<void> checkConnectivityAndShowMessage() async {
    bool isConnected = await MyApp.checkInternetConnection();
    if (!isConnected) {
      showNoConnectionMessage();
    }
  }

  Future<void> showNoConnectionMessage() {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return 
        Stack(
          children: [
            // fondo gris semi-transparente
            Container(
              color: Colors.black.withOpacity(0.2), 
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            AlertDialog(
              backgroundColor: Colors.white,
              content: Container(
                decoration: const BoxDecoration(
                  // border: Border.all(color: Colors.grey[900]!), 
                ),
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'No Wi-Fi connection',
                      style: TextStyle(
                        color: Colors.grey[900], 
                        fontWeight: FontWeight.bold,
                        fontSize: 15.0,
                      ),
                    ),
                    SizedBox(height: 6.0),
                    Text(
                      'Connect to Wi-Fi to access all the features of the app from the home screen.',
                      style: TextStyle(
                        color: Colors.grey[900], 
                      ),
                    ),
                  ],
                ),
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
            ),
          ],
        );
      },
    );
  }

  Future<void> _shakeDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you ok?'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('The phone was shaken.'),
                Text('Help will be called if you do not respond.'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('I am ok'),
              onPressed: () {
                _respondedSafe = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text(
          brigadeStudents,
          style: TextStyle(fontSize: 12),
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.read<SignInBloc>().add(const SignOutRequired());
            },
            icon: const Icon(Icons.login),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 1),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            indent: MediaQuery.of(context).size.width * 0.08,
            endIndent: MediaQuery.of(context).size.width * 0.08,
          ),
          const SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.75,
              height: 40,
              decoration: BoxDecoration(
                color: const Color.fromRGBO(232, 232, 232, 1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Center(
                child: Text(
                  'Homepage Universidad de Los Andes',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
          ),
          const SizedBox(height: 5),
          // Establecer navegación a newsletter
          Container(
            width: MediaQuery.of(context).size.width * 0.18,
            child: ElevatedButton(
              onPressed: () {},
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                overlayColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                elevation: MaterialStateProperty.all(0),
                shadowColor: MaterialStateProperty.all<Color>(
                  Colors.transparent,
                ),
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: Image.asset("assets/newsletter.png"),
              ),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => _chatBlocProvider!),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(80, 225, 130, 1),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Contact the student brigade',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(80, 225, 130, 1),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Report MAAD case',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(80, 225, 130, 1),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Safety tips on campus',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const EmergencyForm();
                        });
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      const Color.fromRGBO(80, 225, 130, 1),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: const Text(
                    'Report emergency',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          // Switch - Falta funcionalidad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Activate alerts',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                const SizedBox(width: 10),
                Switch(
                  value: switchValue,
                  onChanged: (value) {
                    setState(() {
                      switchValue = value;
                    });
                  },
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.grey,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: SingleChildScrollView(
              child: Placeholder(
                fallbackHeight: MediaQuery.of(context).size.height * 0.25,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
