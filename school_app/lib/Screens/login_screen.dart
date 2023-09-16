import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:school_app/Functions/login.dart';
import 'package:school_app/Functions/schedule.dart';
import 'package:school_app/Screens/main_screen.dart';

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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const mainScreen()),
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
        title: const Text('Flutter Login Screen'),
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
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
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
                        : "Wrong credentials", // this will show "wrong password" only when isCorrect is false
                    style: TextStyle(color: Colors.red),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _login,
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
