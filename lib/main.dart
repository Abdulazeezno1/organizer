import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salaryplan/screens/bottom_nav.dart';
import 'package:salaryplan/core/theme/app_theme.dart';

void main() {
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SalaryPlan',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: BottomNav(),
    );
  }
}
