import 'package:flutter/material.dart';

class DogDetailPage extends StatelessWidget {
  const DogDetailPage({super.key, required this.dog});

  final Map<String, dynamic> dog;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: Text(dog['name'] ?? 'Unknown')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          dog['name'] ?? 'Unknown',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        iconTheme: Theme.of(context).appBarTheme.iconTheme,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/${dog['image']}',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
            ),
            SizedBox(height: 16),
            Text(dog['description'] ?? 'No description'),
          ],
        ),
      ),
    );
  }
}
