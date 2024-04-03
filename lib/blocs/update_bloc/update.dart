import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:user_repository/user_repository.dart';

class UpdateInformation {
  final UserRepository userRepository = FirebaseUserRepo();

  Future<String> saveData({required Uint8List image}) async {
    String resp = 'Some error ocurred';
    try {
      User user = await userRepository.getCurrentUser();
      String imageUrl =
          await userRepository.uploadImage("ProfileImage${user.uid}", image);

      resp = imageUrl;
    } catch (e) {
      resp = e.toString();
    }

    return resp;
  }
}
