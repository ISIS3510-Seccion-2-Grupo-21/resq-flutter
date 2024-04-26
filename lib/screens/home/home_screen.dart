import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:resq/blocs/chat_bloc/chat_bloc.dart';
import 'package:resq/screens/chat/chat_view.dart';
import 'package:resq/screens/news/news_detail.dart';
import 'package:shake/shake.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_repository/chat_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:firebase_core/firebase_core.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool switchValue = true;

  @override
  void initState() {
    super.initState();
    ShakeDetector detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        print('Phone shook!');
        _shakeDialog();
        // Do stuff on phone shake
        },
      minimumShakeCount: 1,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

Future<List<Map<String, dynamic>>> _getNewsletterData() async {
  final QuerySnapshot<Map<String, dynamic>> querySnapshot =
      await FirebaseFirestore.instance.collection('newsletters').get();
  return querySnapshot.docs.map((doc) => doc.data()).toList();
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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildCardSwiper() {
  return FutureBuilder<List<Map<String, dynamic>>>(
    future: _getNewsletterData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return CircularProgressIndicator(); // Indicador de carga mientras se obtienen los datos
      } else {
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final List<Map<String, dynamic>> data = snapshot.data!;
          return SizedBox(
            height: 300,
            child: Swiper(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final newsletter = data[index];
                return GestureDetector(
                  onTap: () {
                    // Navegación al detalle de la noticia
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewsDetailScreen(newsletter),
                      ),
                    );  
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.network(newsletter['imagen'] ?? ''),
                        Container(
                          padding: EdgeInsets.all(8),
                          color: Colors.grey,
                          child: Text(newsletter['titulo'] ?? ''),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }
      }
    },
  );
}



  @override
  Widget build(BuildContext context) {
    final chatBlocProvider = BlocProvider(
      create: (context) => ChatBloc(
        chatRepository: FirebaseChatRepository(
          firestore: FirebaseFirestore.instance,
          firebaseAuth: FirebaseAuth.instance,
        ),
        firebaseAuth: FirebaseAuth.instance,
      ),
      child: const ChatScreen(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
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
          SizedBox(height: 1),
          Divider(
            color: Colors.grey[300],
            thickness: 1,
            indent: MediaQuery.of(context).size.width * 0.08,
            endIndent: MediaQuery.of(context).size.width * 0.08,
          ),
          SizedBox(height: 5), 
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
              child: Center(
                child: Text(
                  'Homepage Universidad de Los Andes',
                  style: TextStyle(color: Colors.black, fontSize: 15),
                ),
              ),
            ),
          ),
          SizedBox(height: 5),
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
              child: _buildCardSwiper(),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => chatBlocProvider),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(80, 225, 130, 1),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    'Contact the student brigade',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(80, 225, 130, 1),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    'Report MAAD case',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromRGBO(80, 225, 130, 1),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  child: Text(
                    'Safety tips on campus',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5),
          // Switch - Falta funcionalidad
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Activate alerts',
                  style: TextStyle(color: Colors.black, fontSize: 14),
                ),
                SizedBox(width: 10),
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
          SizedBox(height: 20),
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



