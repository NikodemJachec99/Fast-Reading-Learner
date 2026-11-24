import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
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
      theme: AppTheme.lightTheme,
      home: const HomeScreen(),
    );
  }
}
