import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/item_viewmodel.dart';
import 'views/intro/intro_pages.dart';
import 'views/dashboard.dart';
import 'viewmodels/activity_viewmodel.dart';
import 'views/auth/auth_checker.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
        ChangeNotifierProvider(create: (_) => ItemViewModel()),
        ChangeNotifierProvider(create: (_) => ActivityViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lost and Found Items',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
      ),
      home: const AuthChecker(),
    );
  }
}
