import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../intro/intro_pages.dart';
import './login_page.dart';
import '../dashboard.dart';
import '../intro/intro_pages.dart';

class AuthChecker extends StatefulWidget {
  const AuthChecker({Key? key}) : super(key: key);

  @override
  State<AuthChecker> createState() => _AuthCheckerState();
}

class _AuthCheckerState extends State<AuthChecker> {
  bool isLoading = true;
  bool isFirstLaunch = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    // 1. Cek apakah first launch
    final prefs = await SharedPreferences.getInstance();
    final firstLaunch = prefs.getBool('first_launch') ?? true;

    // 2. Cek apakah sudah login
    const storage = FlutterSecureStorage();
    final token = await storage.read(key: 'auth_token');

    setState(() {
      isFirstLaunch = firstLaunch;
      isLoggedIn = token != null;
      isLoading = false;
    });

    // Set first_launch ke false setelah pertama kali
    if (firstLaunch) {
      await prefs.setBool('first_launch', false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (isFirstLaunch) {
      return const introPage();
    }

    if (isLoggedIn) {
      return const Dashboard();
    }

    // Gunakan key untuk memastikan build baru
    return LoginPage(key: UniqueKey(), forceRefresh: true);
  }
}
