import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils.dart';



class SettingsView extends StatefulWidget {
  const SettingsView({Key? key}) : super(key: key);

  @override
  _SettingsViewState createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  ImageProvider? _image;
  final _firebaseAuth = FirebaseAuth.instance;
  String photo = 'none';
  String userId = 'none';


  @override
  void initState() {
    super.initState();
    print(_firebaseAuth.currentUser);
    if (_firebaseAuth.currentUser != null) {
      userId = _firebaseAuth.currentUser!.uid;
    }
    getImage();
  }

  void getImage() async {
    Reference ref = FirebaseStorage.instance.ref().child('profileImage$userId');
    var url = await ref.getDownloadURL();
    print(url);
    if (url != null) {
      setState(() {
        photo = url;
        _image = NetworkImage(url);
      });
    }
  }


  void selectImage() async {
    try {
      Uint8List? img = await pickImage(ImageSource.camera);
      Reference ref = FirebaseStorage.instance.ref().child('profileImage$userId');
      UploadTask uploadTask = ref.putData(img!);
      setState(() {
        _image = MemoryImage(img);
      });
      await uploadTask.whenComplete(() async {
        var url = await ref.getDownloadURL();
        if (url != null) {
          setState(() {
            photo = url;
          });
        }
      });
    } catch (e) {
      throw Exception('Error picking image: $e');
    }
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Settings'),
    ),
    body: SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 64,
                backgroundImage: _image,
              ),
              Positioned(
                bottom: -10,
                left: 80,
                child: IconButton(
                  onPressed: selectImage,
                  icon: Icon(Icons.add_a_photo),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              var result = await showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Logout'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop('logout');
                      },
                      child: Text('Logout'),
                    ),
                  ],
                ),
              );
              if (result == 'logout') {
                Navigator.of(context).pop('logout');
              }
            },
          ),
          ListTile(
            leading: Icon(Icons.lock),
            title: Text('Change Password'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChangePasswordPage()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Change Profile Picture'),
            onTap: () {
              selectImage();
            },
          ),
          ListTile(
            title: Text('ResQ version 0.4.1'),
          )
        ],
      ),
    ),
  );
}
  
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

  bool _containsUpperCase = false;
  bool _containsLowerCase = false;
  bool _containsNumber = false;
  bool _containsSpecialChar = false;
  bool _contains8Length = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    final currentUser = _auth.currentUser;

    if (currentUser != null) {
      try {
        final email = currentUser.email;
        final credential = EmailAuthProvider.credential(
          email: email!,
          password: _currentPasswordController.text,
        );

        await currentUser.reauthenticateWithCredential(credential);

        if (_newPasswordController.text == _confirmPasswordController.text) {
          await currentUser.updatePassword(_newPasswordController.text);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Password changed successfully'),
            ),
          );
          _loadSharedPreferences(_newPasswordController.text);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('New passwords do not match'),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Error changing password'),
          ),
        );
      }
    }
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a new password';
    }

    setState(() {
      _containsUpperCase = value.contains(RegExp(r'[A-Z]'));
      _containsLowerCase = value.contains(RegExp(r'[a-z]'));
      _containsNumber = value.contains(RegExp(r'[0-9]'));
      _containsSpecialChar =
        value.contains(RegExp(r'^(?=.*?[!@#$&*~`)\%\-(_+=;:,.<>/?"[{\]}\|^])'));
      _contains8Length = value.length >= 8;
    });
    if (!_containsUpperCase) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!_containsLowerCase) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!_containsNumber) {
      return 'Password must contain at least one number';
    }
    if (!_containsSpecialChar) {
      return 'Password must contain at least one special character';
    }
    if (!_contains8Length) {
      return 'Password must be at least 8 characters long';
    }

    return null;
  }

  Future<void> _loadSharedPreferences(password) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', password);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password'),
      ),
      body: SingleChildScrollView(
        child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Current Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your current password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'New Password',
                ),
                validator: _validatePassword,
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirm New Password',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your new password';
                  }
                  return null;
                },
              ),
              SizedBox(height: 32.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _changePassword();
                  }
                },
                child: Text('Change Password'),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}