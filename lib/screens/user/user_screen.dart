import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq/utils.dart';

enum UserRole { student, brigadeStudent, brigadeProffesor, proffesor}

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {

  Uint8List? _image;
  UserRole? _selectedRole;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.camera);
    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit User')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              children: [
                _image != null ?
                CircleAvatar(
                  radius: 64,
                  backgroundImage: MemoryImage(_image!)
                ) :
                const CircleAvatar(
                  radius: 64,
                  backgroundImage: NetworkImage(
                      'https://static.thenounproject.com/png/363640-200.png'),
                ),
                Positioned(
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                )
              ],
            ),
            const SizedBox(height: 20),
            DropdownButton<UserRole>(
              hint: const Text('Select Role'),
              value: _selectedRole,
              onChanged: (UserRole? newValue) {
                setState(() {
                  _selectedRole = newValue;
                });
              },
              items: UserRole.values.map((UserRole role) {
                return DropdownMenuItem<UserRole>(
                  value: role,
                  child: Text(role.toString().split('.').last),
                );
              }).toList(),
            )
          ],
        ),
      ),
    );
  }
}
