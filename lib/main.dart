import 'package:flutter/material.dart';

import 'src/home_screen.dart';

void main() => runApp(const CalorieTrackerApp());

class CalorieTrackerApp extends StatelessWidget {
  const CalorieTrackerApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Calorie Tracker',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF9CD71B)),
      scaffoldBackgroundColor: const Color(0xFFF8F9F2),
    ),
    home: const HomeScreen(),
  );
}
