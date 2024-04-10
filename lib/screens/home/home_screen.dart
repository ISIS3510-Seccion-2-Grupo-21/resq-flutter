import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:resq/blocs/sign_in_bloc/sign_in_bloc.dart';
import 'package:resq/screens/map/map_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool switchValue = true;

  @override
  Widget build(BuildContext context) {
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
              child: SizedBox(
                width: double.infinity,
                child: Image.asset("assets/newsletter.png"),
              ),
            ),
          ),
          SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
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
          // Mapa "preview" con GestureDetector
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapView()),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 0.25,
              child: MapView(),
            ),
          ),
        ],
      ),
    );
  }
}
