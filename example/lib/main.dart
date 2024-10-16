import 'package:example/home_page.dart';
import 'package:flutter/material.dart';
import 'package:sdga_design_system/sdga_design_system.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  bool _isLightTheme = true;

  void _toggleTheme() {
    setState(() => _isLightTheme = !_isLightTheme);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: SDGAColors.primary,
          brightness: Brightness.light,
        ),
      ).applySDGATheme(),
      darkTheme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          seedColor: SDGAColors.primary,
          brightness: Brightness.dark,
        ),
      ).applySDGATheme(),
      themeMode: _isLightTheme ? ThemeMode.light : ThemeMode.dark,
      home: HomePage(toggleTheme: _toggleTheme),
    );
  }
}
