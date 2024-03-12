import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');

  FirebaseUserRepo({
    FirebaseAuth? firebaseAuth,
  }) : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> signIn() async {
    try {
      final microsoftProvider = MicrosoftAuthProvider();
      if (kIsWeb) {
        await _firebaseAuth.signInWithPopup(microsoftProvider);
      } else {
        await _firebaseAuth.signInWithProvider(microsoftProvider);
      }
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }
}
