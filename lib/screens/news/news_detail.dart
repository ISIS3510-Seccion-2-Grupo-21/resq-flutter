import 'package:flutter/material.dart';
import 'package:newsletter_repository.dart/newsletter_repository.dart';

class NewsDetailScreen extends StatelessWidget {
  final String newsletterId;
  final NewsletterRepository newsletterRepository;

  NewsDetailScreen({
    required this.newsletterId,
    required this.newsletterRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Newsletter Detail'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: newsletterRepository.getNewsletterById(newsletterId),
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final newsletter = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(newsletter['imagen']),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(newsletter['cuerpo']),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
