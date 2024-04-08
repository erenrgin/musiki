import 'package:flutter/material.dart';
import 'package:musiki/app_pages/out_pages/splash_page.dart';
import 'package:musiki/custom_designs/custom_color.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'custom_functions/account_shared_preferences.dart';

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
SupabaseClient supabase = Supabase.instance.client;
final User? user = Supabase.instance.client.auth.currentUser;

Future<void> main() async {

  //Connect to database
  await Supabase.initialize(
      url: 'https://ewifocwiqzblbdxutvqe.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImV3aWZvY3dpcXpibGJkeHV0dnFlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTE5NTY4NjYsImV4cCI6MjAyNzUzMjg2Nn0.xOi4BaV3ELA4RECZYMqBVEnIxyWipfyaINH1pZHaYgQ');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool userIsLoggedIn = false;

  @override
  void initState() {
    super.initState();
    getLoggedInState();
  }

  getLoggedInState() async {
    await AccountSharedPreferences.getUserLoggedInSharedPreference()
        .then((value) {
      setState(() {
        userIsLoggedIn = value!;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MUSIKI',
      theme: ThemeData(
        primarySwatch: customAppColor,
      ),
      home: SplashScreen(userIsLoggedIn),
    );
  }
}
