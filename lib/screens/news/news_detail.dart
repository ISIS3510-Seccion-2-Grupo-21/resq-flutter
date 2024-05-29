import 'package:flutter/material.dart';
import 'package:newsletter_repository/newsletter_repository.dart';

class NewsDetailScreen extends StatelessWidget {
  final String newsletterId;
  final FirebaseNewsletterRepository newsletterRepository;

  NewsDetailScreen({
    required this.newsletterId,
    required this.newsletterRepository,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: FutureBuilder<Map<String, dynamic>>(
          future: newsletterRepository.getNewsletterById(newsletterId),
          builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading...');
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final newsletter = snapshot.data!;
              return Text(newsletter['titulo']);
            }
          },
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color.fromRGBO(80, 225, 130, 1),
          onPressed: () {
            Navigator.pop(context); // para volver a la pantalla anterior
          },
          padding: EdgeInsets.zero,
          splashRadius: 24,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.network(newsletter['imagen']),
                    SizedBox(height: 16.0),
                    Text(
                      newsletter['titulo'],
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Por ${newsletter['autor']} - ${newsletter['fecha']}',
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      newsletter['cuerpo'],
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
