import 'package:flutter/material.dart';
import '../app/router.dart';

class LoopHabitTrackerApp extends StatelessWidget {
  const LoopHabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Loop Habit Tracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: const Color(0xFF00897B),
        brightness: Brightness.light,
      ),
      routerConfig: appRouter,
    );
  }
}
