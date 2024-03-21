import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resq/blocs/update_bloc/update.dart';
import 'package:resq/screens/home/home_screen.dart';
import 'package:resq/utils.dart';

enum UserRole { student, brigadeStudent, brigadeProffesor, proffesor }

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  Uint8List? _image;
  UserRole? _selectedRole;

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void saveProfile() async {
    String role = _selectedRole.toString().split('.').last;
    String resp =
        await UpdateInformation().saveData(role: role, image: _image!);

    print(resp);
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
                _image != null
                    ? CircleAvatar(
                        radius: 64, backgroundImage: MemoryImage(_image!))
                    : const CircleAvatar(
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
            ),
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: saveProfile, child: const Text('Save Profile'))
          ],
        ),
      ),
    );
  }
}
