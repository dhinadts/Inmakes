import 'package:flutter/material.dart';
import 'package:inmakes_flutter_basics/data/dogs_info.dart';
import 'package:inmakes_flutter_basics/dog_info.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange, brightness: Brightness.light),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.yellow,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange, brightness: Brightness.dark),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.orange,
        ),
      ),
      themeMode: ThemeMode.system, // Change this to ThemeMode.light or ThemeMode.dark as needed
      home: SafeArea(child: const MyHomePage(title: 'Dog App')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var data = dogs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var dog in data)
              Card(
                child: ListTile(
                  leading: CircleAvatar(
                    child: ClipOval(
                      child: Image.asset(
                        'assets/${dog['image']}',
                        fit: BoxFit.cover,
                        width: 40,
                        height: 40,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.error,
                            color: Colors.red,
                            size: 40.0,
                          );
                        },
                      ),
                    ),
                  ),
                  title: Text(dog['name'] ?? 'Unknown'),
                  subtitle: Text(dog['description'] ?? 'No description'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DogDetailPage(dog: dog),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

