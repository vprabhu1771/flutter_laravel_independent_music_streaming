import 'package:flutter/material.dart';
import 'package:flutter_laravel_independent_music_streaming/screens/GenreScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GenreScreen(title: 'Genre'),
    );
  }
}