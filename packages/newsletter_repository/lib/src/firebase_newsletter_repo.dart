import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'newsletter_repo.dart';
import 'models/models.dart';

class FirebaseNewsletterRepository implements NewsletterRepository {
  final FirebaseFirestore _firestore;

  FirebaseNewsletterRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

@override
Stream<List<Map<String, String>>> getNewsletter() {
  return _firestore.collection('newsletter').snapshots().map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'titulo': (data['titulo'] ?? '') as String,
        'imagen': (data['imagen'] ?? '') as String,
        'cuerpo': (data['cuerpo'] ?? '') as String,
      };
    }).toList();
  });
}}
