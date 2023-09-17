import 'package:flutter/material.dart';
import 'package:school_app/Functions/login.dart';
import 'package:school_app/Screens/main_screen.dart';
import 'Screens/login_screen.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Functions/schedule.dart';

final storage = new FlutterSecureStorage();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  print(prefs.getBool('firstLogin'));
  if (prefs.getBool('firstLogin') == false) {
    await login(null, null);
    await schedule();
    runApp(const MyApp2());
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Screen',
      theme: ThemeData.light(), // Use the light theme
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const LoginPage(),
    );
  }
}

class MyApp2 extends StatelessWidget {
  const MyApp2({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Login Screen',
      theme: ThemeData.light(), // Use the light theme
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      home: const mainScreen(),
    );
  }
}
