// import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

abstract class NewsletterRepository {
  Stream<List<Map<String, String>>> getNewsletter();
}
