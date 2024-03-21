import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:user_repository/src/entities/entities.dart';
import 'package:user_repository/src/models/user.dart';
import 'package:user_repository/src/user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final userWithImageCollection = FirebaseFirestore.instance.collection('usersWithRI');

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
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<MyUser> signUp(MyUser myUser, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
          email: myUser.email, password: password);

      myUser = myUser.copyWith(userId: user.user!.uid);

      return myUser;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> setUserData(MyUser myUser) async {
    try {
      await usersCollection
          .doc(myUser.userId)
          .set(myUser.toEntity().toDocument());
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> logOut() async {
    await _firebaseAuth.signOut();
  }

  @override
  Future<String> uploadImage(String fileName, Uint8List file) async {
    Reference ref = _firebaseStorage.ref().child(fileName);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  @override
  Future<User> getCurrentUser() async {
    try {
      return _firebaseAuth.currentUser!;
    } catch (e) {
      log(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> updloadData(MyUser updatedUser) async {
    String resp = 'Some error ocurred';
    try {
      userWithImageCollection.add({
        'userId': updatedUser.userId,
        'name': updatedUser.name,
        'email': updatedUser.email,
        'role': updatedUser.role,
        'image': updatedUser.image,
      });
      resp = 'Data saved successfully';
    } catch (e) {
      log(e.toString());
      resp = e.toString();
    }

    return resp;
  }
}
