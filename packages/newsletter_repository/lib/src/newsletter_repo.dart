// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'models/models.dart';

abstract class NewsletterRepository {
  Stream<List<Map<String, String>>> getNewsletter();
}
