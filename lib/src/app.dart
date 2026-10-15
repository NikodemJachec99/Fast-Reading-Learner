import 'package:flutter/material.dart';

import 'features/home/home_screen.dart';

/// Root widget of the application.
class FastReadingApp extends StatelessWidget {
  const FastReadingApp({super.key});

  static const String title = 'Fast Reading Learner';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
          brightness: Brightness.dark,
        ),
      ),
      home: const HomeScreen(),
    );
  }
}
