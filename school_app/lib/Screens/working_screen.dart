import 'package:flutter/material.dart';

class workingOnIt extends StatelessWidget {
  const workingOnIt({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.build,
              size: 50.0,
            ),
            Text(
              'Mας έπιασες, το δουλεύουμε',
              style: TextStyle(fontSize: 24.0),
            ),
          ],
        ),
      ),
    );
  }
}
