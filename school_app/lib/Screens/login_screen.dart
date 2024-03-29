import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:school_app/Functions/login.dart';
import 'package:school_app/Functions/schedule.dart';
// ignore: unused_import
import 'package:school_app/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

void setstate() {
  setstate();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

   

  void _login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (_formKey.currentState!.validate()) {
      // Perform login logic here
      _showprogress = true;
      setState(() {});
      bool correct = await login(
          '${_usernameController.text}', '${_passwordController.text}');
      if (correct == true) {
        if (prefs.getString('username') == null) {
          prefs.setString('username', '${_usernameController.text}');
          prefs.setString('password', '${_passwordController.text}');
          await schedule();

            prefs.setBool('firstLogin', false);
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MyApp2()),
            );
          
        }
      } else {
        _showprogress = false;
        setState(() {});
      }
    }
  }

  void _showDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Icon(Icons.info),
          content: const Column(
             
            children: [
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('1: Ο δημιουργός αυτής της εφαρμογής δεν είναι υπεύθυνος για τυχόν παραπληροφόρηση που εμφανίζεται κατά τη χρήση.'),
              ),
              
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('2: Αυτή η εφαρμογή χρησιμοποιεί google analytics.'),
              )
              ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // This will close the dialog
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }


  bool _showprogress = false;
  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showDialog(context);
    });
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Σύνδεση'),
      ),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Αρ. Μητρώου',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Εισαγωγή Αρ. Μητρώου';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Αρ. Ταυτότητας',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Εισαγωγή Αρ. Ταυτότητας';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: [
                    Icon(
                      passwordCorrect
                          ? null
                          : Icons
                              .warning, // this will show a warning icon only when isCorrect is false
                      color: Colors.red,
                    ),
                    Text(
                      passwordCorrect
                          ? ""
                          : "Λάθος διαπιστευτήρια", // this will show "wrong password" only when isCorrect is false
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: _login,
                  child: const Text('Σύνδεση'),
                ),
              ],
            ),
          ),
        ),
        if (_showprogress)
          const Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LinearProgressIndicator(),
          ),
          

          
      ]),
    );
  }
}
