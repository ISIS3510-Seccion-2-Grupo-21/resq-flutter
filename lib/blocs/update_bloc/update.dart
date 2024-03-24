import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class UpdateInformation {
  final UserRepository userRepository = FirebaseUserRepo();

  Future<String> saveData(
      {required String role, required Uint8List image}) async {
    String resp = 'Some error ocurred';
    try {
      if (image.isNotEmpty || role.isNotEmpty) {
        String imageUrl =
            await userRepository.uploadImage('profileImage', image);


        User user = await userRepository.getCurrentUser();

        MyUser currentUser = MyUser(
          userId: user.uid,
          name: user.displayName ?? '',
          email: user.email ?? '',
          role: role,
          image: imageUrl,
        );

        resp = await userRepository.updloadData(currentUser);
      }
    } catch (e) {
      resp = e.toString();
    }

    return resp;
  }
}
