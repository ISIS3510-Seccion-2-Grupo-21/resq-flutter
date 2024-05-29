import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseNewsletterRepository {
  final FirebaseFirestore _firestore;

  FirebaseNewsletterRepository({
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  Stream<List<Map<String, String>>> getNewsletter() {
    return _firestore.collection('newsletter').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'titulo': (data['titulo'] ?? '') as String,
          'imagen': (data['imagen'] ?? '') as String,
          'cuerpo': (data['cuerpo'] ?? '') as String,
          'autor': (data['autor'] ?? '') as String,
          'fecha': (data['fecha'] ?? '') as String,
        };
      }).toList();
    });
  }

  Future<Map<String, dynamic>> getNewsletterById(String newsletterId) async {
    final DocumentSnapshot<Map<String, dynamic>> snapshot =
        await _firestore.collection('newsletter').doc(newsletterId).get();

    if (snapshot.exists) {
      final data = snapshot.data()!;
      return {
        'titulo': (data['titulo'] ?? '') as String,
        'imagen': (data['imagen'] ?? '') as String,
        'cuerpo': (data['cuerpo'] ?? '') as String,
        'autor': (data['autor'] ?? '') as String,
        'fecha': (data['fecha'] ?? '') as String,
      };
    } else {
      throw Exception('Newsletter with ID $newsletterId not found.');
    }
  }
}

