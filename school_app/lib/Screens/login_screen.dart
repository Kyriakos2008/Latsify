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

      //login('${_usernameController.text}', '${_passwordController.text}');
      //print('Username: ${_usernameController.text}');
      //print('Password: ${_passwordController.text}'); // calls function to login
      bool correct = await login(
          '${_usernameController.text}', '${_passwordController.text}');
      if (correct == true) {
        print('sosto');
        await schedule();

        if (prefs.getString('username') == null) {
          prefs.setString('username', '${_usernameController.text}');
          prefs.setString('password', '${_passwordController.text}');
          print('kati kamno me to usename dame jj en exo idea');
        }
        print('username' + "${prefs.getString('username')}");

        prefs.setBool('firstLogin', false);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const MyApp2()),
        );
      } else {
        setState(() {});
        print('lathos');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Σύνδεση'),
      ),
      body: Padding(
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
                    style: TextStyle(color: Colors.red),
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
    );
  }
}
